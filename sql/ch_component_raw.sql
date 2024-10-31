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

--------------------------
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
-------------------------------------------------
insert into ch_component_new(developer_count)
select count(*) from (
SELECT COUNT(author) AS nAuthors
FROM ch_git_revision AS t2
GROUP BY t2.component_name, t2.sub_component
) as t
-----------------------------------------------------
UPDATE ch_git_revision AS t1
SET developer_count = t2.nAuthors
FROM (
    SELECT component_name, sub_component, COUNT(author) AS nAuthors
    FROM ch_git_revision
    WHERE developer_count IS NULL
    GROUP BY component_name, sub_component
) AS t2
WHERE t1.component_name = t2.component_name
AND t1.sub_component = t2.sub_component;
---------------------------------------------------------
UPDATE ch_git_revision AS t1
SET developer_count = t2.nAuthors
FROM (
    SELECT component_name, sub_component, COUNT(author) AS nAuthors
    FROM ch_git_revision
    WHERE developer_count IS NULL
    GROUP BY component_name, sub_component
) AS t2
WHERE t1.component_name = t2.component_name
AND t1.sub_component = t2.sub_component;
----------------------------------------------
UPDATE ch_component_new AS t1
SET developer_count = t2.nAuthors
FROM (
    SELECT component_name, sub_component, COUNT(author) AS nAuthors
    FROM ch_git_revision
    GROUP BY component_name, sub_component
) AS t2
WHERE t1.component_name = t2.component_name
AND t1.sub_component = t2.sub_component;
---------------------------------------------------------------

select component_id, component_name, sub_component, add, remove , t_churn from ch_component_new 
where add is null and  remove is null and t_churn is null
--------------------------------------------------------------------
delete from ch_component_new 
where component_id is null and component_name is null and sub_component is null and add is null and remove is null and t_churn is null 
----------------------------------------------------------

UPDATE ch_component_new
SET developer_count = (
    SELECT developer_count
    FROM ch_git_revision
    WHERE ch_git_revision.component_name = ch_component_new.component_name
    AND ch_git_revision.sub_component = ch_component_new.sub_component
)
where ch_component_new.component_id is not null





-- Extract bug id integer from the raw bug_id text
select bug_id, substring(bug_id from E'\{bug\s?\:\s?([0-9]*)\}$') as b_id from ch_bugfix_commits_new where bug_id~E'\{.*?bug\s?\:.*';
