#!/usr/bin/perl -w
#test -- my @lines = split(/\n/, qx(git log --since="four weeks ago" --pretty=format:"%H %T %an <%ae> %aD %cn <%ce>% %cD %P%n") );

use warnings;
use strict;

use DBI;
use Cwd;


#stop stdout buffering
$| = 1;

use Config::General;

my $config_path = shift @ARGV;
if (!defined $config_path) {
	$config_path = 'config';
}
die "Config file \'$config_path\' does not exist"
	unless (-e $config_path);
my %config =  Config::General::ParseConfig($config_path);
#test -- print "$config{repo_path}, $config{db_name}\n";

my $dbh = DBI->connect("dbi:Pg:database=$config{db_name}", '', '', {AutoCommit => 1});

# If it fails, probably already exists
$dbh->do(q{alter table git_revision add column rev_type text default 'modified'}) or warn "Adding column rev_type fails ", $dbh->errstr;

my $get_possible_commits = $dbh->prepare(q{select repo, r.commit from git_revision c, git_repo r where r.commit = c.commit and (add = 0 or remove = 0) group by repo, r.commit});
my $update_rev_type = $dbh->prepare(q{update git_revision set rev_type = ? where commit = ? and path = ?});

$get_possible_commits->execute or die "Can't get possible commits ", $dbh->errstr;

while (my ($repo, $commit) = $get_possible_commits->fetchrow_array) {

    my $path = $config{repo_path}.$repo;
    #my $path = $config{repo_path}."src";
    chdir $path or die "Cannot processes $path";

    my @history = split(/\n/, qx(git log $commit -1 -p)); 

    if (!defined $history[0]) {
        print STDERR "Error processing git repo $path\n";
        return;
    }

    my $commit;
    my $line;
    my $prev_line;
    while (@history) {
        $line = shift @history;
        if ($line =~ /^commit (\S{40})/) {
            $commit = $1;
        }
        # added file
        # --- /dev/null
        # +++ b/sync/syncable/scoped_kernel_lock.cc
        elsif ($line =~ m|^[-]{3} /dev/null|) {
            $line = shift @history;
            if (defined $line and $line =~ m|^[+]{3} b/(.*?)\s*$|) {
                print "$commit added file $1\n";
                $update_rev_type->execute('new', $commit,  $1) or warn "Problem with $commit, $1, new ", $dbh->errstr;

            }
        }
        # removed file
        # --- a/sync/syncable/syncable_mock.h
        # +++ /dev/null
        elsif ($line =~ m|^[+]{3} /dev/null|) {
            if (defined $prev_line and $prev_line =~ m|^[-]{3} a/(.*?)\s*$|) {
                print "$commit removed file $1\n";
                $update_rev_type->execute('deleted', $commit, $1) or warn "Problem with $commit, $1, deleted ", $dbh->errstr;
            }
        }

        $prev_line = $line;

    }

}
$get_possible_commits->finish;
$update_rev_type->finish;
$dbh->disconnect;

