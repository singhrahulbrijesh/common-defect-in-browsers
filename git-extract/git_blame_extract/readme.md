# Get the blame info

Firstly, you need to determine the time range that you want to investigate by setting the *min_range* and *max_range* columns of *period_range* table. Then you need to create a config file to determine the file types that you are intrested in and consider as source files.

```
db_name=turnover_review_vscode
file_types=js|ts|json|cs|cpp|c|java|sh
clone_path=/home/ehsan/Documents/Repositories/vscode
tmp_repo_path=/tmp/blame/vscode/ 
max_threads = 8 // it's better to set it equal to number of cpu cores

```
Lasly, the following script will extract the blame information of the last commit of periods between *min_range* and *max_range* values of *period_range*.

```
./run_blame.sh <db_name> <config_file>
```

You can get the count of different file types and number of cpu cores with the following commands:

```
cat /proc/cpuinfo | grep processor | wc -l
find . -type f | sed -n 's/..*\.//p' | sort | uniq -c
```

## 1. Name Aliasing
You need to set up [dev_info](https://github.com/CESEL/internal_tools/tree/master/git_extract/dev_info) and do [name aliasing](https://github.com/CESEL/internal_tools/tree/master/NamesCleaningAndAliasing) before you can assign ownership.

## 2. Ignoring Irrelevant Commits
You'll may want to investigate which commits to [ignore](https://github.com/CESEL/internal_tools/blob/master/git_extract/git_blame_extract/git_blame_ignore.sql) (migration commits, mega commits from branches, anything without proper attribution), which will ignore any blame line with these commit hashes from git_blame_raw. For example, you can ignore commits with more than 200 changes (mega commits) by inserting their sha to git_blame_ignore table like below:

``` SQL

drop table if exists git_blame_ignore;
create table git_blame_ignore (
	commit text
);

insert into git_blame_ignore
select git_commit.commit from git_commit
inner join git_revision on git_commit.commit=git_revision.commit
group by git_commit.commit
having count(*)>200
```

## 3. Calculate Blame Ownership
Next, set up git_blame table which contains the percentage of each file that each dev owns in each period.
```
psql -d <databasename> -f blame_ownership.sql 
```

## 4. Remove Non-Source Files
you'll also want to ignore non-source files from git_blame table, because they do not represent any domain knowledge about source code and they are basically related to build processes or documentation.
The remove scripts are supposed to located inside [clean](https://github.com/CESEL/internal_tools/tree/master/git_extract/git_blame_extract/clean) folder. If you are working on a new dataset you need to create a new script which is specific to your dataset.

The clean scripts is generally like the below script:
```
\set ECHO all

create table git_blame_backup as select * from git_blame;
delete from git_blame where lower(filename) !~ E'\\.(cpp|h|java|js|ts|html|css|vb|c|cs|js|pl|sh|py|cxx)$';
delete from git_blame where filename ~ 'third_party';

VACUUM git_blame ;
ANALYZE git_blame ;
```
And then you can run the script to remove the undesired files from git_blame.
```
psql -d <databasename> -f  clean/<project_name>.sql 
```
## 5. Calculate File Ownership

In this step, we calculate how many owners are sharing a single file. 
To run this query you need to specify the value of ownership threshold. You can change the threshold by modifying the first line of file_owenrship file. As a matter of fact, the recommended threshold value is 5%.
```
\set ownership_threshold 5
```
After setting the threshold, you need to run the file_ownership script.

```
psql -d <databasename> -f  file_ownership.sql
```

## 6. Calculate Stayed Ownership
The following query computes the percentage of source code that is owned by remaining developers who have not left the project.
To run this query you need to specify the value of ownership threshold. You can change the threshold by modifying the first line of simulation_not_left.sql file. As a matter of fact, the recommended threshold value is 5%.

(OLD DESCRIPTION: you'll want to run as it'll tell you how many files are still around and is needed for simulation and loss distribution)
```
\set ownership_threshold 5
```
After setting the threshold, you need to run the following script.

```
psql -d <databasename> -f  simulation_not_left.sql
```

## 7. Top Quantile and Leavers

Follow the [instructions](https://github.com/CESEL/internal_tools/tree/master/git_extract/git_blame_extract/top_quantile) for calculating top developers and leavers.



### See [turnover/turnover_paper/src](https://github.com/CESEL/turnover/tree/master/turnover_paper/src) for more processing
