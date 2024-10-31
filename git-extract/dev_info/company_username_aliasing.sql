\set ECHO all

--at a company the username is usually assigned, so we can just find that.
alter table git_commit add column username text;
--at avaya the username that comes before the @ is valid
update git_commit set username = lower(substring(author from E'<(.*?)@'));

--a check
select author, committer from git_commit where username is null;

-- no author
update git_commit set username = 'no author' where username is null;
