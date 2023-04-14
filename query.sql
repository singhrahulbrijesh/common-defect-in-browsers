SELECT Component, SUM(TotalChurns) 
FROM ch_final_dataset_cromium
WHERE Component = 'Blink'
GROUP BY Component;
-----------------------------------

select count(distinct component_name) from ch_git_revision
where component_name not in ('dev-keys',
'ceee',
'support',
'build_overrides',
'styleguide',
'cros')
 ------------------------------


DELETE FROM ch_component_new
WHERE ctid IN (
  SELECT ctid
  FROM ch_component_new
  ORDER BY ctid
  LIMIT 76
);
--------------------------------

-- UPDATE ch_component_new
-- SET component_name = 'dartium_tools'
-- WHERE component_name IS NULL and c omponent_id = 174;


--------------------------------------
insert into ch_component_april
select component_id, component_name, sub_component, add, remove, (add + remove) as t_churn  from ch_git_revision
where component_name not in ('dev-keys',
'ceee',
'support',
'build_overrides',
'styleguide',
'cros')


select distinct component from ch_final_dataset_cromium

select * from ch_git_revision


UPDATE ch_git_revision AS r
SET developer = subquery.num_developers
FROM (
  SELECT component_name, sub_component, COUNT(DISTINCT commit) AS num_developers
  FROM ch_git_revision
  GROUP BY component_name, sub_component
) AS subquery
WHERE r.component_name = subquery.component_name
  AND r.sub_component = subquery.sub_component;
  
  
SELECT component_name, sub_component, COUNT(DISTINCT commit) AS num_developers
FROM ch_git_revision
GROUP BY component_name, sub_component;

select * from ch_component_new;

update ch_component_new set dev

update ch_git_revision set developer_count = (
select component_name, sub_component, count(author) nAuthors from ch_git_revision
group by component_name, sub_component
order by component_name, sub_component asc
)

UPDATE ch_git_revision
SET developer_count = (
    SELECT COUNT(author)
    FROM ch_git_revision subquery
    WHERE ch_git_revision.component_name = subquery.component_name
    AND ch_git_revision.sub_component = subquery.sub_component
)

UPDATE ch_git_revision AS t1
SET developer_count = (
    SELECT COUNT(author) AS nAuthors
    FROM ch_git_revision AS t2
    WHERE t2.component_name = t1.component_name
    AND t2.sub_component = t1.sub_component
    GROUP BY t2.component_name, t2.sub_component
)

UPDATE ch_git_revision AS t1
SET developer_count = (
    SELECT COUNT(author) AS nAuthors
    FROM ch_git_revision AS t2
    WHERE t2.component_name = t1.component_name
    AND t2.sub_component = t1.sub_component
    GROUP BY t2.component_name, t2.sub_component
)

insert into ch_component_new(developer_count)
select count(*) from (
SELECT COUNT(author) AS nAuthors
FROM ch_git_revision AS t2
GROUP BY t2.component_name, t2.sub_component
) as t

UPDATE ch_component_new 
SET developer_count = (
    SELECT COUNT(author) AS nAuthors
    FROM ch_git_revision AS t2
    WHERE ch_component_new.component_name = t2.component_name
    AND ch_component_new.sub_component = t2.sub_component
    GROUP BY component_name, sub_component
)
where developer_count is null

select * from ch_component_new 