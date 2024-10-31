\set ECHO all


create index pfu_top_quantile_idx on top_quantile(period, username);

--alter table git_blame add column quantile numeric;
--alter table git_blame add column in_top boolean;
--update git_blame set quantile = t.quantile, in_top = t.in_top from top_quantile t where t.period = git_blame.period and t.filename = git_blame.filename and t.username = git_blame.username;

--drop table top_quantile;
