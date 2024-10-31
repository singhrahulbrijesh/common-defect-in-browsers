\set ECHO all

drop table if exists dev_info;
create table dev_info ( 
    username text,
	first_dt timestamp with time zone,
    first_year integer,
    last_year integer, 
    first_commit integer,
    last_commit integer, 
    total_commits numeric,
    primary key (username)
);

insert into dev_info 
    select username, min(committer_dt), min(year), max(year),  min(period),  max(period), count(*)
        from (select username, period, extract(year from committer_dt) as year, committer_dt from git_commit) as r 
        group by username;


