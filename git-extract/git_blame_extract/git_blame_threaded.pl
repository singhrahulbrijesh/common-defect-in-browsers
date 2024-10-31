#!/usr/bin/perl -w

use warnings;
use strict;

use DBI;
use Config::General;

use Data::Dumper;

use File::Path qw(make_path);

my $config_path = shift @ARGV;

if (!defined $config_path) {
	$config_path = 'config';
}
die "Config file \'$config_path\' does not exist"
	unless (-e $config_path);

my %config =  Config::General::ParseConfig($config_path);

my $out_path = $config{tmp_repo_path};
if ($out_path !~ m|/$|) {
	$out_path .= '/';
}
$out_path .= "run_output";
make_path($out_path) unless -d $out_path;

my $dbh_ref = DBI->connect("dbi:Pg:database=$config{db_name}", '', '', {AutoCommit => 1});

my $query = $dbh_ref->prepare(q{select last_commit, period 
									from periods p, period_range pr 
									where pr.min_range <= period and period <= pr.max_range 
										and last_commit not in (select commit from git_blame_raw) 
										and last_commit is not null order by period
						     });
$query->execute or die;
my $total = $query->rows;
my $processed = 0;

sub still_running () {

	my $running = qx(ps aux | grep 'git_blame_one' | wc -l) or die;
	#ignore the run from perl, and the one for the grep
	$running -= 2;

	my $finished = $processed - $running;
	print "We've finished $finished of $total and processing with $running threads.\n";

	return $running;

}

while ( my($commit, $period) = $query->fetchrow_array) {

	system("./git_blame_one.pl $config_path $commit 2> $out_path/$commit.error > $out_path/$commit.out &");
	print("Starting a thread for period $period with last commit $commit\n");
	$processed ++;
	sleep(60);

	while (still_running >= $config{max_threads}) {
		sleep(60*3);
	}

}

while(still_running > 0) {
	sleep(60*10);
}

$query->finish;
$dbh_ref->disconnect;

