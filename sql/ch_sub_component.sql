

-- Populate t_commit in ch_sub_components table
update ch_sub_components s set t_commit = a.t_commit from (select component_id, sub_component, count(distinct commit) as t_commit from ch_git_revision group by component_id, sub_component) a where s.component_id = a.component_id and s.sub_component = a.sub_component;

-- Populating t_churn in ch_sub_components table
UPDATE ch_sub_components SET t_churn = subquery.t_churn FROM 
( SELECT component_id, sub_component, SUM(add + remove) AS t_churn FROM ch_git_revision 
 GROUP BY component_id, sub_component) AS subquery
 WHERE ch_sub_components.component_id = subquery.component_id AND ch_sub_components.sub_component = subquery.sub_component;

-- Populating t_dev in ch_sub_components table
update ch_sub_components s set t_dev = a.t_dev from (select r.component_id, r.sub_component, count(c.author) as t_dev from ch_git_commit c join ch_git_revision r on c.commit=r.commit group by r.component_id, r.sub_component) a where s.component_id = a.component_id and s.sub_component = a.sub_component;




