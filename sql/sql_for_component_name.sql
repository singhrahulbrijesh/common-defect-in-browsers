Todays working:- 


CREATE TABLE ch_component_bug_data (
    name TEXT NOT NULL
);

CREATE INDEX ch_component_name_idx ON ch_git_revision (component_name);


select distinct component_name from ch_bug_data


-- Do this if the component names in git_revision table is not cleaned
update ch_git_revision set component_name = null where component_name in
('codelabs','courgette','gin','chrome_cleaner','chrome','chrome_elf','chrome_frame','chromecast','build','gears','dartium_tools','components')


UPDATE ch_component_bug_data SET name = LOWER(name);


SELECT r.component_id, b.name from ch_git_revision r join ch_component b on r.component_id = b.id WHERE r.dir LIKE '%' || b.name || '%' and b.source = 'b';

UPDATE ch_git_revision SET component_id = b.id FROM ch_component b WHERE ch_git_revision.dir LIKE '%' || b.name || '%' and b.source = 'b';

After running the above query total null 1.6 million

UPDATE ch_git_revision
SET component_name = b.name
FROM ch_component b
WHERE ch_git_revision.dir LIKE '%' || b.name || '%' and ch_git_revision.component_name is null

After populating component_name we got 900 thousand null values

UPDATE ch_git_revision
SET component_name = b.name
FROM ch_component b
WHERE ch_git_revision.new_path LIKE '%' || b.name || '%' and ch_git_revision.component_name is null

after populating component_name through new_path 359729 null values

