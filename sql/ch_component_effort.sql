--- Other code for ch_component_effort
CREATE TABLE ch_component_effort(component_id NUMERIC, t_commit NUMERIC, t_devs NUMERIC, t_churn NUMERIC, dev_effort NUMERIC);
CREATE INDEX fx_component_effort_component_id_idx ON fx_component_effort(component_id);
ALTER TABLE fx_component_effort ADD CONSTRAINT fx_component_effort_component_id_unique UNIQUE (component_id);

INSERT INTO ch_component_effort(component_id, t_churn, t_devs) 
	SELECT component_id, sum(`add` + `remove`) t_churn, COUNT(author) t_devs 
	FROM ch_git_revision_final gr 
	WHERE gr.component_id > 0 
	GROUP BY component_id;

UPDATE ch_component_effort SET t_commit = q1.t_commits FROM (
	SELECT gr.component_id, COUNT(DISTINCT gc.commit) t_commits 
	FROM ch_git_commit gc, ch_git_revision_final gr 
	WHERE gc.commit = gr.commit and gr.component_id > 0
	GROUP BY gr.component_id
	) q1
WHERE ch_component_effort.component_id = q1.component_id;

UPDATE ch_component_effort SEt dev_effort = (t_churn + t_commit) / t_devs;
ALTER TABLE ch_component_effort ADD COLUMN churn_dev NUMERIC;
UPDATE ch_component_effort SET churn_dev = (t_churn / t_devs);
ALTER TABLE ch_component_effort ADD COLUMN commit_dev NUMERIC;
UPDATE ch_component_effort SET commit_dev = (t_commit / t_devs);

SELECT ce.component_id, c.name, ce.t_commit, ce.t_devs, ce.t_churn, ce.dev_effort, ce.churn_dev, ce.commit_dev FROM ch_component c, ch_component_effort ce WHERE c.id=ce.component_id ORDER BY c.name ASC;

\COPY (SELECT ce.component_id, c.name, ce.t_commit, ce.t_devs, ce.t_churn, ce.dev_effort, ce.churn_dev, ce.commit_dev FROM ch_component c, ch_component_effort ce WHERE c.id=ce.component_id ORDER BY c.name ASC) TO '/home/taj/Documents/CommonDefects/ch_component_effort.csv' DELIMITER ',' CSV HEADER;
