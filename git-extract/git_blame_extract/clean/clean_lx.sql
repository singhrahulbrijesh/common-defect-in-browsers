\set ECHO all

create table git_commit_backup as select * from git_commit;
create table git_revision_backup as select * from git_revision;

create table com_files as select commit, count(*) as files from git_revision group by commit;

delete FROM git_revision where commit in (select commit from com_files where files > 100); 

--delete from git_revision where canonical !~ E'\.[hc]';

delete from git_commit where commit in (select commit from git_commit except select commit from git_revision);

--fix up garbage user names
--update git_commit set username = committer where username not in (select username from git_commit group by username having count(*) > 30);
--alter table git_commit add column username text;
--update git_commit set username = substring(lower(author) from E'\\<(.+?)(@|at|AT)');
--update git_commit set username = substring(lower(committer) from E'\\<(.+?)(@|at|AT)') where username is null;
--create index username_idx on git_commit(username);

drop table com_files;

VACUUM git_commit ;
VACUUM git_revision ;
ANALYZE git_revision ;
ANALYZE git_commit ;

