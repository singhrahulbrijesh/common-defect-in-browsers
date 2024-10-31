\set ECHO all

alter table periods add column last_commit text;

update periods set last_commit = r.first_commit from periods r where periods.period = r.period - 1;

--although you may just want to delete this
update periods set last_commit = commit from git_commit c, (select max(committer_dt) from git_commit) as r where r.max = c.committer_dt and last_commit is null;

create table periods_old as select * from periods;

--check that first is = last
--select * from periods order by period;

alter table periods drop column first_commit ;

update git_commit set period = r.period from periods r where last_commit = commit;
