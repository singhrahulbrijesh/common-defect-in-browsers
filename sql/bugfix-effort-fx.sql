\copy (select bug_id, churn from fx_bugfix_commits where churn > 0 and component_id > 0 order by churn desc) to '~/Documents/CommonDefects/bugfix-effort-fx.csv' delimiter ',' csv header;
