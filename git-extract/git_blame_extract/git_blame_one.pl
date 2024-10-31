#!/usr/bin/perl -w

use warnings;
use strict;

use DBI;
use Config::General;
use Cwd;

#http://www.perlmonks.org/?node_id=591180
use utf8; 
use Encode;

use Data::Dumper;

my $config_path = shift @ARGV;
my $commit = shift @ARGV;

if (!defined $config_path) {
	$config_path = 'config';
}
die "Config file \'$config_path\' does not exist"
	unless (-e $config_path);

my %config =  Config::General::ParseConfig($config_path);

my $dbh_ref = DBI->connect("dbi:Pg:database=$config{db_name}", '', '', {AutoCommit => 0});

my $insert = $dbh_ref->prepare(q{insert into git_blame_raw(commit, filename, author, auth_commit, lines) values(?,?,?,?,?)});

my $repo_path = "$config{tmp_repo_path}/$commit";
system("git clone $config{clone_path} $repo_path");
chdir $repo_path or die "Cannot cd to $repo_path";
system("git checkout $commit");

my $in = "git ls-tree --name-only -r HEAD";
#print "$in\n";
my @files = split(/\n/, qx($in));
print "Processing $#files files\n";


my $cnt = 0;
foreach my $filename (@files) {
	#test: next unless $filename =~ /($config{file_types})$/;
	next unless $filename =~ /\.($config{file_types})$/;

	$in = "git blame -w -M --line-porcelain \'$filename\'";
	#print "$in\n";
	my @history = split(/\n/, qx($in));

	my %authors;
	while (@history) {
		my $line = shift @history;

		#print "$line \n";

		if ($line =~ /^(\w{40}) \s\d+ \s\d+ \s(\d+)$/xms) {

			my $commit_author = $1;
			my $line_cnt = $2;

			my $line = shift @history;
			#print "$line \n";

			if ($line =~ /^author\s (.*)$/xms) {
					$commit_author .= ": $1"; 
			}

			my $line = shift @history;
			#print "$line \n";

			if ($line =~ /^author-mail\s (.*)$/xms) {
					$commit_author .= " $1"; 
					#print "$commit_author \n";
					$authors{$commit_author} += $line_cnt;
			}

		}

	}

	print "\n\n$filename\n"; 
	while ( my ($author_commit, $lines) = each(%authors) ) {
		#print "$author_commit => $lines\n";
		if ($author_commit =~ /^(\w{40}):\s(.*)/xms) {
			my $auth_commit= $1;
			my $author = $2;
			$insert->execute($commit, encode("UTF-8", $filename), encode("UTF-8", $author), $auth_commit, $lines) 
				or warn "Problem inserting $commit, $filename, $author, $auth_commit, $lines ", $dbh_ref->errstr;
		}
	}

	#write every 1000 files 
	$cnt ++;
	if ($cnt >= 1000) {
		$dbh_ref->commit;
		$cnt = 0;
	}
}

$dbh_ref->commit;
$insert->finish;
$dbh_ref->disconnect;


