\set ECHO all

--get the files that are still around and ignore the people who leave in this period
drop table if exists simulation_not_left;
create table simulation_not_left as 
	select period, filename, sum(percentage) as percentage 
		from git_blame b, dev_info d 
		where d.username = b.username 
			  --pretend that the people who leave in the sim period are still around
			  and d.last_commit >= period
		group by period, filename 
		--ownership is still above 10
	 	having sum(percentage) >= 10;

alter table simulation_not_left add primary key (period, filename);
