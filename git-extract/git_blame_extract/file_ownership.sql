\set ECHO all

--level of co-ownership
drop table if exists blame_file;
create table blame_file (
	period integer,
	filename text,
	total_devs_all numeric,
	total_devs numeric default 0,
	current_devs numeric default 0
);

insert into blame_file select period, filename, count(distinct(username)) 
	from git_blame 
	group by period, filename;

--update blame_file set total_devs = 0;
update blame_file set total_devs = devs 
	from 
		(select period, filename, count(distinct(username)) as devs
			from git_blame 
			where percentage >= 10
			group by period, filename
		) as l
	where l.period = blame_file.period and l.filename = blame_file.filename;

--update blame_file set current_devs = 0;
update blame_file set current_devs = devs 
	from 
		(select period, filename, count(distinct(b.username)) devs from git_blame b, dev_info d 
			where b.username = d.username 
				--in the period of your last commit, you've already abandoned it
				and b.period < d.last_commit 
				and percentage >= 10 
			group by period, filename
		) as l 
	where l.period = blame_file.period and l.filename = blame_file.filename;

