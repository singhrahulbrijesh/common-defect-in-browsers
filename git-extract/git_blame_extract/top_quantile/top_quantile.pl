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

system("psql $config{db_name} -f top_quantile_pre.sql");

my $dbh_ref = DBI->connect("dbi:Pg:database=$config{db_name}", '', '', {AutoCommit => 0});

my $get_total_lines = $dbh_ref->prepare(q{select period, sum(lines) from git_blame group by period order by period});

my $query = $dbh_ref->prepare(q{select username, sum(lines) as dev_lines from git_blame where period = ? --and period = 20 and filename ~ 'futex.c' 
group by username order by dev_lines desc});
 

my $insert = $dbh_ref->prepare(q{insert into top_quantile(period, username, lines, in_top, quantile) values(?,?,?,?,?)});

$get_total_lines->execute or die;

while ( my($period, $total) = $get_total_lines->fetchrow_array) {

	$query->execute($period) or die;

	my $sum = 0;
	my $in_top = 1;
	while ( my($username, $lines) = $query->fetchrow_array) {

		$sum += $lines;
		my $quantile = $sum/$total;

		print "period: $period, fn: lines: $lines, total: $total, sum: $sum, in_top: $in_top, quant: $quantile, $username\n";
		$insert->execute($period, $username, $lines, $in_top, $quantile) 
			or die"Problem inserting $period, $username, $lines, $in_top, $quantile ", $dbh_ref->errstr;	

		if($in_top == 1 and $quantile >= $config{quantile}) {
			$in_top = 0;
		}
	}

	$dbh_ref->commit;
}

$dbh_ref->commit;

$get_total_lines->finish;
$insert->finish;
$query->finish;

$dbh_ref->disconnect;

system("psql $config{db_name} -f top_quantile_post.sql");

