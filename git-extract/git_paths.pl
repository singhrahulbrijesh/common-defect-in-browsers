#!/usr/bin/perl -w

use warnings;
use strict;

use DBI;
use Config::General;

my $config_path = shift @ARGV;
if (!defined $config_path) {
	$config_path = 'config';
}
die "Config file \'$config_path\' does not exist"
	unless (-e $config_path);
my %config =  Config::General::ParseConfig($config_path);

my $dbh_ref = DBI->connect("dbi:Pg:database=$config{db_name}", '', '', {AutoCommit => 0});

print "added columns old_path and new_path to git_revision\n";
#add the columns
$dbh_ref->do(q{alter table git_revision add column old_path text}) or warn $dbh_ref->errstr;
$dbh_ref->commit;
$dbh_ref->do(q{alter table git_revision add column new_path text}) or warn $dbh_ref->errstr;
$dbh_ref->commit;

#do the ones that don't change names in one quiery instead of passing back and forth between the script
print "updating all rows where old = new, this might take a while!\n";
$dbh_ref->do(q|update git_revision set old_path = path, new_path = path where path !~ E'=>'|) or warn $dbh_ref->errstr;
$dbh_ref->commit;
print "done updating all rows where old = new\n";

my $get_paths = $dbh_ref->prepare(q|select commit, path from git_revision where path ~ E'=>'|); 
#my $get_paths = $dbh_ref->prepare(q|select commit, path from git_revision where path ~ E'\\{' order by random() limit 100|); 

my $update_paths = $dbh_ref->prepare(q|update git_revision set old_path = ?, new_path = ? where commit = ? and path = ?|);

$get_paths->execute or die $dbh_ref->errstr;

my $write = 0;
while (my ($commit, $path) = $get_paths->fetchrow_array) {

	print "$path\n";

	if ($path =~ m|^(.*?)\{(.*?) \s=>\s (.*?) \}(.*?)$|xms) {
		my ($start, $old, $new, $end) = ($1, $2, $3, $4);

		if (! defined $start) {
			$start = '';
		}

		if (! defined $end) {
			$end = '';
		}

		my $old_path = "$start$old$end";
		$old_path =~ s|//|/|g;
		my $new_path = "$start$new$end";
		$new_path =~ s|//|/|g;

		print "old path = $old_path\n";
		print "new path = $new_path\n";

		$update_paths->execute($old_path, $new_path, $commit, $path) 
			or warn "Problem with $commit in old/new path ", $dbh_ref->errstr;
	}
	elsif ($path =~ m|^(.*?) \s=>\s (.*?)$|xms) {
		print "old path = $1\n";
		print "new path = $2\n";

		$update_paths->execute($1, $2, $commit, $path) 
			or warn "Problem with $commit in complete mv file ", $dbh_ref->errstr;
	}
		
	else {
		print "old = new = $path\n";
		$update_paths->execute($path, $path, $commit, $path) 
			or warn "Problem with $commit in path same ", $dbh_ref->errstr;
	}

	if ($write % 10000 == 0) {
		$dbh_ref->commit;
	}

}

$dbh_ref->commit;

$update_paths->finish;
$get_paths->finish;
$dbh_ref->disconnect;
