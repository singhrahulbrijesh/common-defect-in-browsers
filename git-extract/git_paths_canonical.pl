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

my $dbh_ref = DBI->connect("dbi:Pg:database=$config{db_name}", '', '', {AutoCommit => 1});

#print "add canonical column\n";
$dbh_ref->do(q{alter table git_revision add column canonical text}) or warn $dbh_ref->errstr; 

print "update canonical\n";
$dbh_ref->do(q{update git_revision set canonical = old_path}) or die $dbh_ref->errstr; 

print "add index\n";
$dbh_ref->do(q{create index canonical_idx on git_revision(canonical)}) or warn $dbh_ref->errstr; 

#get the order of the moves 
my $get_renames = $dbh_ref->prepare(q{select old_path, new_path from git_revision r, git_commit c where c.commit = r.commit and old_path <> new_path order by committer_dt desc});

$get_renames->execute or die $dbh_ref->errstr;

my $update_paths = $dbh_ref->prepare(q|update git_revision set canonical = ? where canonical = ?|);

while (my ($old_path, $new_path) = $get_renames->fetchrow_array) {
    $update_paths->execute($old_path, $new_path);
}

$get_renames->finish;
$update_paths->finish;
$dbh_ref->disconnect;
