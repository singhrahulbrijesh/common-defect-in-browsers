---This command is to copy particular columns to database from CSV file
\copy (select a.commit, b.bug_id, a.subject, b.churn from ch_git_commit a, ch_bugfix_commits b where a.commit = b.commit and b.churn > 0 order by b.churn desc) to '~/Documents/CommonDefects/bugfix-commits-subject-ch.csv' DELIMITER ',' CSV HEADER;
