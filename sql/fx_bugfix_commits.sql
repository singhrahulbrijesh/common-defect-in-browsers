-- Create fx_bugfix_commits
create table fx_bugfix_commits as select commit, regexp_matches(subject, 'bug\s*(\d+)?', 'i') as bug_id_raw from fx_git_commit where lower(subject) similar to ('%bug\s*\d+?%');

--update fx_git_revision AS t1
--SET developer_count = t2.nAuthors
--FROM (
--    SELECT component_name, sub_component, COUNT(author) AS nAuthors
--    FROM fx_git_revision
--    WHERE developer_count IS NULL
--    GROUP BY component_name, sub_component
--) AS t2
--WHERE t1.component_name = t2.component_name
--AND t1.sub_component = t2.sub_component;

--UPDATE fx_git_revision 
--SET component_id = f.component_id 
--FROM fx_component_new AS f
--WHERE f.sub_component = fx_git_revision.sub_component 
--AND f.component_name = fx_git_revision.component_name;

--UPDATE fx_component_bugfix_effort
--SET sub_component = trim(
--    case 
--        when sub_component LIKE '%{%}' or sub_component LIKE '% %' 
--            then replace(replace(sub_component, '{', ''), '}', '') 
--        else sub_component 
--    end
--);

--ALTER TABLE fx_bugfix_commits ALTER COLUMN bug_id TYPE integer USING (bug_id::integer);
ALTER TABLE fx_bugfix_commits ADD COLUMN churn numeric(50,0);
ALTER TABLE fx_bugfix_commits ADD COLUMN component_id numeric(50,0);

ALTER TABLE fx_bugfix_commits ADD PRIMARY KEY (commit);
CREATE INDEX fx_bugfix_commits_component_id ON fx_bugfix_commits(component_id);

UPDATE fx_bugfix_commits SET churn = sq.churn, component_id = sq.component_id FROM (SELECT grf.commit, gc.author, gc.author_dt, (grf.add + grf.remove) AS churn, grf.component_id FROM fx_git_revision_final grf, fx_git_commit gc, fx_bugfix_commits bc WHERE grf.commit = bc.commit and bc.commit=gc.commit) sq WHERE fx_bugfix_commits.commit = sq.commit;

-- Download total churn by bug_id
\COPY (select bug_id, sum(churn) as t_churn from fx_bugfix_commits where churn > 0 group by bug_id order by t_churn desc) TO '/home/taj/Documents/CommonDefects/fx_bugfix_commits.csv' DELIMITER ',' CSV HEADER;
