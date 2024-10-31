-- Performed string manipulation on new_comp_name in bug_data table 
UPDATE bug_data SET new_comp_name = SUBSTRING(component FROM 1 FOR POSITION('>' IN component || '>') - 1);


-- Take the root dir substring from the dir (not null) in git_revision and consider it as component, insert into compoments table only if it does not exist
-- INSERT INTO components (component_name)
-- SELECT TRIM(SUBSTRING(dir FROM 1 FOR POSITION('/' IN dir || '/') - 1))
-- FROM git_revision;


-- Take the root dir substring from the dir (not null) in git_revision and consider it as component, insert into compoments table only if it does not exist
Insert into components_1(component_name)
SELECT DISTINCT component_name FROM components


UPDATE components_1 SET component_id = floor(random() * 192) + 1;

UPDATE components_1 AS c1
SET component_id = (
  SELECT COALESCE(
    (SELECT component_id FROM components_1 AS c2 WHERE c2.component_name = c1.component_name),
    floor(random() * 192) + 1
  )
);



UPDATE components_1 c1
SET component_id = 
  (SELECT x FROM 
    (SELECT floor(random() * 192) + 1 AS x) AS rand_num 
    WHERE NOT EXISTS 
      (SELECT 1 FROM components_1 c2 WHERE c2.component_id = rand_num.x) 
    LIMIT 1
  )
WHERE component_id IS NULL;



-- create a new column "component_id" in git_revision table
Alter table git_revision add column component_id INTEGER
Alter table git_revision add column commit_1 text
ALTER TABLE git_revision DROP CONSTRAINT commit;

UPDATE git_revision SET commit_1 = commit;


UPDATE git_revision r
SET component_id = c.component_id
FROM components_1 c
WHERE split_part(r.dir, '/', 1) = c.component_name;



--for each row in git_revision table update with component id from components table
--update git_revision r set r.component_id = select c.component_id from components c where substr("regex", r.dir ) = substr("regex", c.component_name)

INSERT INTO git_revision (component_name)
SELECT TRIM(SUBSTRING(dir FROM 1 FOR POSITION('/' IN dir || '/') - 1))
FROM git_revision;
alter table components_1 add column add numeric
alter table components_1 add column remove numeric


---- To get the common component name in both the browser Here is the sql for firefox --- 
UPDATE fx_component_old AS c
SET common_category = b.name
FROM ch_component_old AS b
WHERE c.name = b.name;

---- created common component table for chromium -
create table ch_comp_common as
select c.name, c.id from ch_component_old as c
join fx_component_old as b on
c.name = b.name

---- created common component table for firefox
create table fx_comp_common as
select c.name, c.id from fx_component_old as c
join ch_component_old as b on
c.name = b.name

-- SELECT DISTINCT component_name FROM component_unique
-- WHERE component_name IN ('blink', 'base', 'services', 'apps', 'headless', 'sync', 'tools', 'printing', 'extensions', 'views', 'tests', 'aura', 'cloud_print', 'fuchsia', 'cc', 'content', 'gfx', 'infra', 'skia', 'ui', 'chromeos', 'google_update', 'media', 'gpu', 'mojo', 'crypto', 'src', 'gin', 'google_apis', 'components', 'chromecast', 'ios', 'sandbox', 'remoting');

-- update component_unique 
-- select  distinct component FROM file_comp_map
-- WHERE component in ('Blink', 'Security', 'UI', 'Mobile', 'IO', 'EnterpriseRetailMode', 'Services', 'Infra', 'Test', 'Tests', 'Speed', 'Enterprise', 'Tools', 'Privacy','FamilyExperiences', 'Webstore', 'Internals', 'Build')


