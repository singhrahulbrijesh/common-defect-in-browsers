\set ECHO all

drop table if exists periods;
create table periods (
	period SERIAL primary key,
	yr numeric, 
	qr numeric,
	last_commit text
);

insert into periods (yr, qr)
	select extract(year from committer_dt) yr, extract(quarter from committer_dt) qr
		from git_commit 
		group by extract(year from committer_dt), extract(quarter from committer_dt) order by yr, qr;

alter table git_commit add column period integer;
update git_commit set period = l.period from periods l where extract(year from committer_dt) = yr and extract(quarter from committer_dt) = qr;

update periods set last_commit = commit from git_commit c, (select yr, qr, max(committer_dt) from periods q, git_commit c where yr = extract(year from committer_dt) and qr = extract(quarter from committer_dt) group by yr, qr) as r where max = committer_dt and periods.yr = r.yr and periods.qr = r.qr;

--skip first two years and last year
drop table if exists period_range;
create table period_range as select min_range, max_range from (select 1 as joiner, min(period) + 8 as min_range from periods) s natural join (select 1 as joiner, max(period) - 4 as max_range from periods) e;

