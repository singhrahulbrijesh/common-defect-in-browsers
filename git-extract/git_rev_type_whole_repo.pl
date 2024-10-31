#!/usr/bin/perl -w
#test -- my @lines = split(/\n/, qx(git log --since="four weeks ago" --pretty=format:"%H %T %an <%ae> %aD %cn <%ce>% %cD %P%n") );

use warnings;
use strict;

use DBI;
use Cwd;

#http://www.perlmonks.org/?node_id=591180
use utf8; 
use Encode;

#alter table git_revision add column rev_type text default 'modified';

#stop stdout buffering
$| = 1;

sub process_git_repo ($$) {
	my ($db_name, $path) = @_;

	my $dbh = DBI->connect("dbi:Pg:database=$db_name", '', '', {AutoCommit => 1});
    my $update_rev_type = $dbh->prepare(q{update git_revision set rev_type = ? where commit = ? and path = ?});

	my @history = split(/\n/, qx(git log --full-history --all --numstat -M -C -p)); 
        #test -- qx(git log 9b00348a7fd079086fd7bc893ca49ed3b4301c25 -100 -p)); 

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
	$update_rev_type->finish;
	$dbh->disconnect;

}

#
# Step through all the directories
#
sub process_dir 
{
	my ($path, $config_ref) = @_;

	chdir $path or die "Cannot processes $path";
	my $cwd = getcwd;
	print $cwd, "\n";

	if (-e ".git") 
	#if ($path =~ /\w+.git\s*$/xms)
	{
		if ($cwd =~ /$config_ref->{repo_path_ignore}(.*)/) {
			my $short_path = $1;
			print "Processing git repo $short_path \n";
			process_git_repo($config_ref->{db_name}, $short_path);
		}
		else {
			warn "Problem processing cwd: $cwd";
		}
	}
	else {
		foreach my $next_path (<*>) 
		{
			if (-d $next_path) 
			{
				process_dir($next_path, $config_ref);
			}
		}
	}
	chdir '..' or die "Cannot backout of $path";
}

use Config::General;

my $config_path = shift @ARGV;
if (!defined $config_path) {
	$config_path = 'config';
}
die "Config file \'$config_path\' does not exist"
	unless (-e $config_path);
my %config =  Config::General::ParseConfig($config_path);
#test -- print "$config{repo_path}, $config{db_name}\n";

process_dir($config{repo_path}, \%config);


__END__

=head1 Extracts a git repo from the logs

See the README

=cut
