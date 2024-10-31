\set ECHO all

drop table if exists top_quantile;
create table top_quantile (
	period integer,
	username text,
	lines numeric,
	in_top boolean,
	quantile numeric
);

