select count(*) from ch_git_commit

select commit from ch_git_commit where log ~ "bug fix"
where log ~ (select bug_id from chz-bug)

SELECT commit
FROM ch_git_commit
WHERE log LIKE '%' || "bug fix" || '%' and where log (SELECT bug_id FROM ch_bug_data)

SELECT count(log) 
FROM ch_git_commit 
WHERE log LIKE '%' || 'bug fix' || '%';


SELECT log
FROM ch_git_commit 
WHERE log LIKE '%' || 'bug fix' || '%';
------------------------------------------------
-- Table: public.ch_bugfix_commits_new

-- DROP TABLE IF EXISTS public.ch_bugfix_commits_new;

CREATE TABLE IF NOT EXISTS public.ch_bugfix_commits_new
(
    commit text COLLATE pg_catalog."default",
    bug_id_raw text COLLATE pg_catalog."default",
    component_id numeric,
    component_name text COLLATE pg_catalog."default",
    sub_component text COLLATE pg_catalog."default"
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.ch_bugfix_commits_new
    OWNER to postgres;
-- Index: commit_idx1

-- DROP INDEX IF EXISTS public.commit_idx1;

CREATE INDEX IF NOT EXISTS commit_idx1
    ON public.ch_bugfix_commits_new USING btree
    (commit COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: component_name_idx1

-- DROP INDEX IF EXISTS public.component_name_idx1;

CREATE INDEX IF NOT EXISTS component_name_idx1
    ON public.ch_bugfix_commits_new USING btree
    (component_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
---------------------------------------------------------------------
UPDATE ch_bugfix_commits_new AS table_alias
SET bug_id_raw = subquery.bug_id
FROM (
    SELECT commit, 
        CASE 
            WHEN position(':' in bug_id_raw) > 0 AND position('}' in bug_id_raw) > position(':' in bug_id_raw)
            THEN replace(trim(substring(bug_id_raw, position(':' in bug_id_raw) + 1, position('}' in bug_id_raw) - position(':' in bug_id_raw) - 1)), '"', '')
            ELSE null
        END AS bug_id
    FROM ch_bugfix_commits_new
    WHERE lower(bug_id_raw) LIKE '%bug:%'
) AS subquery
WHERE table_alias.commit = subquery.commit;
------------------------------------------------------------------+
CREATE INDEX commit_idx2 ON ch_git_revision (commit);
---------------------------------------------------------------

select g.bug_id_raw from ch_bugfix_commits_new as g
join ch_component_new as c on
g.component_name = c.component_name


update ch_component_new  set commit = g.commit 
from ch_git_revision as g
join ch_component_new as c on
c.component_id = g.component_id
where c.commit is null

select * from ch_bugfix_commits_new


SELECT g.bug_id_raw, c.add,c.remove,c.t_churn,c.developer_count
FROM ch_bugfix_commits_new AS g
JOIN ch_component_new AS c 
ON g.component_id = c.component_id;


select * from ch_bugfix_commits_new

select * from ch_component_new

----------------------------------------------------------------------------------------------------
Todays one for ch_bugfix_commits_new

-- Table: public.ch_bugfix_commits_new

-- DROP TABLE IF EXISTS public.ch_bugfix_commits_new;

CREATE TABLE IF NOT EXISTS public.ch_bugfix_commits_new
(
    commit text COLLATE pg_catalog."default",
    bug_id text COLLATE pg_catalog."default",
    component_id bigint,
    component_name text COLLATE pg_catalog."default",
    sub_component text COLLATE pg_catalog."default",
    add numeric,
    remove numeric,
    t_churn numeric,
    developer_count bigint
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.ch_bugfix_commits_new
    OWNER to postgres;
-- Index: commit_idx1

-- DROP INDEX IF EXISTS public.commit_idx1;

CREATE INDEX IF NOT EXISTS commit_idx1
    ON public.ch_bugfix_commits_new USING btree
    (commit COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: component_name_idx1

-- DROP INDEX IF EXISTS public.component_name_idx1;

CREATE INDEX IF NOT EXISTS component_name_idx1
    ON public.ch_bugfix_commits_new USING btree
    (component_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: sub_componentidx1

-- DROP INDEX IF EXISTS public.sub_componentidx1;

CREATE INDEX IF NOT EXISTS sub_componentidx1
    ON public.ch_bugfix_commits_new USING btree
    (sub_component COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;

------------------------------------------------------------------
schema for ch_component_new  

-- Table: public.ch_component_new

-- DROP TABLE IF EXISTS public.ch_component_new;

CREATE TABLE IF NOT EXISTS public.ch_component_new
(
    component_id bigint,
    component_name text COLLATE pg_catalog."default",
    sub_component text COLLATE pg_catalog."default",
    add numeric(100,0),
    remove numeric(100,0),
    t_churn numeric(100,0),
    developer_count bigint
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.ch_component_new
    OWNER to postgres;
-- Index: component_idx1

-- DROP INDEX IF EXISTS public.component_idx1;

CREATE INDEX IF NOT EXISTS component_idx1
    ON public.ch_component_new USING btree
    (component_id ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: component_name_idx

-- DROP INDEX IF EXISTS public.component_name_idx;

CREATE INDEX IF NOT EXISTS component_name_idx
    ON public.ch_component_new USING btree
    (component_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: component_nameidx

-- DROP INDEX IF EXISTS public.component_nameidx;

CREATE INDEX IF NOT EXISTS component_nameidx
    ON public.ch_component_new USING btree
    (component_name COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;
-- Index: sub_componentidx

-- DROP INDEX IF EXISTS public.sub_componentidx;

CREATE INDEX IF NOT EXISTS sub_componentidx
    ON public.ch_component_new USING btree
    (sub_component COLLATE pg_catalog."default" ASC NULLS LAST)
    TABLESPACE pg_default;


