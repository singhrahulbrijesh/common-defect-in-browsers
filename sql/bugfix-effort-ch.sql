\copy (select bug_id, churn from ch_bugfix_commits where churn > 0 and component_id > 0 order by churn desc) to '~/Documents/CommonDefects/bugfix-effort-ch.csv' delimiter ',' csv header;
