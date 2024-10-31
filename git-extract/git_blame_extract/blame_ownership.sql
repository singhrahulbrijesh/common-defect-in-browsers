\set ECHO all

--check that we got all the commits
--select commit, count(*) from git_blame_raw group by commit order by count desc;

drop table if exists git_blame;
create table git_blame as 
		select p.period, b.commit, b.filename, a.username, sum(lines) as lines 
			from git_blame_raw b, periods p, 
			--aliased names
			(select author, username from git_commit group by author, username) as a
			where b.commit = p.last_commit
				and b.author = a.author
				--these are commits that we've explicitly ignored
				and b.auth_commit not in (select commit from git_blame_ignore)
			group by p.period, b.commit, b.filename, a.username;

drop index if exists pf_git_blame_idx;
create index pf_git_blame_idx on git_blame(period, filename);
drop index if exists ufp_git_blame_idx;
create index ufp_git_blame_idx on git_blame(username, filename, period); 


--ownership percentage
alter table git_blame add column total numeric;
update git_blame set total = t.total 
	from (select period, filename, sum(lines) total from git_blame group by period, filename) as t 
	where git_blame.period = t.period and git_blame.filename = t.filename;

--get rid of any files that have no lines because their lines have been removed by ignoring first commits
delete from git_blame where total = 0;

--percentage of ownership
alter table git_blame add column percentage numeric;
update git_blame set percentage = round(lines/(total)*100, 2);

--leaver?
alter table git_blame add column has_left boolean default true;
update git_blame b set has_left = false from dev_info d
	where b.username = d.username and b.period <= d.last_commit and b.period >= d.first_commit;
create index has_left_blame_idx on git_blame(has_left);


