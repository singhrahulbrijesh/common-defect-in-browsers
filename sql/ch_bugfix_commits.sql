1. Remove the unwanted character and before applying this code check the datatype is array 
UPDATE ch_bugfix_commits
SET bug_id = array(
    SELECT string_agg(regexp_replace(elem, '[^0-9]', '', 'g'), '' ORDER BY idx)
    FROM unnest(bug_id) WITH ORDINALITY AS t(elem, idx)
);

-- After that change the datatype to text 
ALTER TABLE ch_bugfix_commits
ALTER COLUMN bug_id TYPE text;

-- code below is to remove the curly braces from the bug_id 

UPDATE ch_bugfix_commits
SET bug_id = REPLACE(REPLACE(bug_id, '{', ''), '}', '');

-- Change the datatype(bug_id) to numeric
UPDATE ch_bugfix_commits
SET bug_id = REPLACE(bug_id::text, ' ', '')::numeric;

2. Another way to remove the unwanted character from the bug_id in ch_bugfix_commits
UPDATE ch_bugfix_commits AS table_alias
SET bug_id = subquery.bug_id
FROM (
    SELECT commit, 
        CASE 
            WHEN position(':' in bug_id) > 0 AND position('}' in bug_id) > position(':' in bug_id) 
            THEN replace(trim(substring(bug_id, position(':' in bug_id) + 1, position('}' in bug_id) - position(':' in bug_id) - 1)), '"', '')
            ELSE null
        END AS bug_id
    FROM ch_bugfix_commits
    WHERE lower(bug_id) LIKE '%bug:%'
) AS subquery
WHERE table_alias.commit = subquery.commit;
------------------------------------------------------------------+


-- The below is the other section for ch_bugfix_commits 

UPDATE ch_bugfix_commits_raw
SET bug_id = substring(bug_id FROM E'[\\d]+')
WHERE bug_id ~ E'\\{?.*?^bug\\s?\\:.*}';

UPDATE ch_bugfix_commits
SET bug_id = substring(bug_id from '\d+')
WHERE bug_id ~ E'^\\{.*?BUg\\s?\\:\\s?(\\d+)\\}$';

alter table ch_bugfix_commits alter column bug_id TYPE integer USING (bug_id::integer);

UPDATE ch_bugfix_commits
SET bug_id = regexp_replace(bug_id, '[^0-9]', '', 'g')
WHERE bug_id ~ E'^\\{.*?BUg\\s?\\:\\s?(\\d+)\\}$' OR bug_id ~ E'^\\{:^BUg\\s?\\:\\s?(\\d+)$';

ALTER TABLE ch_bugfix_commits ADD COLUMN author text;
ALTER TABLE ch_bugfix_commits ADD COLUMN author_dt integer;
ALTER TABLE ch_bugfix_commits ADD COLUMN churn numeric(50,0);
ALTER TABLE ch_bugfix_commits ADD COLUMN component_id numeric(50,0);

ALTER TABLE ch_bugfix_commits ADD PRIMARY KEY (commit);
CREATE INDEX ch_bugfix_commits_component_id ON ch_bugfix_commits(component_id);
ALTER TABLE ch_bugfix_commits RENAME COLUMN author_dt TO uncle_dt;
ALTER TABLE ch_bugfix_commits ADD COLUMN author_dt timestamp WITH time zone NULL;
ALTER TABLE ch_bugfix_commits DROP COLUMN uncle_dt;

UPDATE ch_bugfix_commits SET author = sq.author, author_dt = sq.author_dt, churn = sq.churn, component_id = sq.component_id FROM (SELECT grf.commit, gc.author, gc.author_dt, (grf.add + grf.remove) AS churn, grf.component_id FROM ch_git_revision_final grf, ch_git_commit gc, ch_bugfix_commits bc WHERE grf.commit = bc.commit and bc.commit=gc.commit) sq WHERE ch_bugfix_commits.commit = sq.commit;

-- Download total churn by bug_id
\COPY (select bug_id, sum(churn) as t_churn from ch_bugfix_commits where churn > 0 group by bug_id order by t_churn desc) TO '/home/taj/Documents/CommonDefects/ch_bugfix_commits.csv' DELIMITER ',' CSV HEADER;

------Script to extract the bug_id from commit table (log column) 
WITH extracted_bugs AS (
    SELECT 
        commit,  -- Assuming you have a commit identifier
        (regexp_match(log, 'Bug:? ([0-9]+)'))[1]::BIGINT AS extracted_bug_id  -- Extract and cast valid numbers
    FROM 
        ch_git_commit
    WHERE 
        log LIKE '%Bug%'  -- Only select rows that contain 'Bug' or 'Bug:'
        AND (regexp_match(log, 'Bug:? ([0-9]+)'))[1] IS NOT NULL  -- Ensure the match is not NULL
        AND LENGTH((regexp_match(log, 'Bug:? ([0-9]+)'))[1]) BETWEEN 5 AND 8  -- Only include bug IDs between 5 and 8 digits
)
UPDATE ch_git_commit
SET log_bug_id = extracted_bugs.extracted_bug_id
FROM extracted_bugs
WHERE ch_git_commit.commit = extracted_bugs.commit;  -- Update only matching commits

----- select statement for matching bug_id from ch_bug_data table and ch_git_commit table 
SELECT DISTINCT 
    c.log_bug_id,  -- The extracted log bug ID
    b.bug_id,
    b.summary  -- The bug summary from the bug_data table
FROM 
    ch_git_commit c
JOIN 
    ch_bug_data b ON c.log_bug_id = b.bug_id  -- Matching log_bug_id with bug_id
WHERE 
    c.log_bug_id IS NOT NULL;  -- Ensure we're only looking at rows with a valid log_bug_id


