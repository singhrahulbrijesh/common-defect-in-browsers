\set ECHO all

--should do real name aliasing, but if you want to ignore it then do this:
alter table git_commit add column username text;
update git_commit set username = author;
