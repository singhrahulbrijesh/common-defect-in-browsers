\set ECHO all

drop table if exists git_blame_raw;
create table git_blame_raw (
	commit text,
	filename text,
	author text,
	auth_commit text,
	lines numeric
);
