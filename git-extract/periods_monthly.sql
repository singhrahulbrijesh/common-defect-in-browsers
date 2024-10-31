\set ECHO all

drop table if exists periods;
create table periods (
	period SERIAL primary key,
	yr numeric, 
	unit numeric,
	last_commit text
);

insert into periods (yr, unit)
	select extract(year from committer_dt) yr, extract(month from committer_dt) unit
		from git_commit 
		group by extract(year from committer_dt), extract(month from committer_dt) order by yr, unit;

alter table git_commit add column period integer;
update git_commit set period = l.period from periods l where extract(year from committer_dt) = yr and extract(month from committer_dt) = unit;

update periods set last_commit = commit from git_commit c, (select yr, unit, max(committer_dt) from periods q, git_commit c where yr = extract(year from committer_dt) and unit = extract(month from committer_dt) group by yr, unit) as r where max = committer_dt and periods.yr = r.yr and periods.unit = r.unit;

--skip first year and last year
drop table if exists period_range;
create table period_range as select min_range, max_range from (select 1 as joiner, min(period) + 12 as min_range from periods) s natural join (select 1 as joiner, max(period) - 12 as max_range from periods) e;

select * from period_range;
