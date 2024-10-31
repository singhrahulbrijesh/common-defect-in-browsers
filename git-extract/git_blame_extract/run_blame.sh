
#look in this ./config
#will need to know the dominate file type:
## select substring(path from E'(\\.\\w+)$') as extension, count(*) from git_revision group by substring(path from E'(\\.\\w+)$') order by count(*) desc;
echo "db = $1 and Config = $2"

# see lx.conf as an example config file (you'll need a tmp location for cloned repos)

# if you're re-running git_blame, run git_blame_pre_copy.sql to preserve the old tables 

# create the tables in db 
psql $1 -f git_blame_extract.sql

# will kick off multiple versions of the following:
## system("./git_blame_one.pl $config_path $commit 2> $out_path/$commit.error > $out_path/$commit.out &"); 
./git_blame_threaded.pl $2

