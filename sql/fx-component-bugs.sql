
-- Component id | number of bugs
select b.component_id, count(b.bug_id) as num_bugs from fx_git_revision_final a, fx_bugfix_commits b where a.commit = b.commit and b.component_id > 0 group by b.component_id order by count(b.bug_id) desc;

-- Component id | commit | number of bugs
select b.component_id, b.commit, count(b.bug_id) as num_bugs from fx_git_revision_final a, fx_bugfix_commits b where a.commit = b.commit and b.component_id > 0 group by b.component_id, b.commit order by count(b.bug_id) desc;

-- Component name | number of bugs
select c.name, count(b.bug_id) as num_bugs from fx_git_revision_final a, fx_bugfix_commits b, fx_component c where a.commit = b.commit and b.component_id = c.id and b.component_id > 0 group by c.name order by count(b.bug_id) desc;

\copy (select c.name, count(b.bug_id) as num_bugs from fx_git_revision_final a, fx_bugfix_commits b, fx_component c where a.commit = b.commit and b.component_id = c.id and b.component_id > 0 group by c.name order by count(b.bug_id) desc) to '~/Documents/CommonDefects/component-bugs-fx.csv' delimiter ',' csv header;

-- Component name | number of bugs (only common with Chromium)
select c.name, count(b.bug_id) as num_bugs from fx_git_revision_final a, fx_bugfix_commits b, fx_component c where a.commit = b.commit and b.component_id = c.id and b.component_id > 0 and c.name in (select name from ch_component) x group by c.name order by count(b.bug_id) desc;
