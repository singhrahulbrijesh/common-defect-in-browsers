\set ECHO all



--make sure there is a true and false for all periods
drop table if exists leavers;
create table leavers as 
	select period, false as in_top, 0 as devs 
		from periods p, period_range pr
		where pr.min_range <= period and period <= pr.max_range ;

insert into leavers 	
	select period, true as in_top, 0 as devs 
		from periods p, period_range pr
		where pr.min_range <= period and period <= pr.max_range ;

update leavers set devs = count from 
	( 
	select q.period, in_top, count(*) 
		from dev_info d, top_quantile q
		where d.username = q.username
			and last_commit = q.period
		group by q.period, in_top 
	) as r 
	where r.period = leavers.period 
		  and r.in_top = leavers.in_top;

