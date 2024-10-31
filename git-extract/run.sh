echo "db = $1 and Config = $2"

date

#Libs:
echo "Install libs"
sudo apt-get install libdbd-pg-perl libencode-perl libconfig-general-perl

echo "Make a config file, an example config file is config/lx.conf"

echo "create tables"
psql $1 -f git_extract.sql 

git config --global diff.renamelimit 100000 

echo "extract everything, by default you'll only get commits attached to head"
./git_extract_head_only.pl $2
#-- for all commits including those only accessible from refs/tags use: ./git_extract.pl $2

echo "extract old and new path names"
./git_paths.pl $2

echo "get canonical names, ie replace renames with original name"
./git_paths_canonical.pl $2

echo "add dir level, basically just remove file name"
psql $1 -f git_dir_level.sql 

#echo "Script to find added and deleted files (used when doing predictions of successors)"
#will modify git_revision to add column rev_type
#./git_rev_type.pl $2

echo "setup periods table for turnover paper"
# keep in mind that git_commit may have been changed by for successors (eg commits that include more than 100 files), if you rerun consider using git_commit
#if you have an old periods table, see run periods_fix_old.sql
#if you want quarterly periods use periods_quarterly.sql
psql $1 -f periods_monthly.sql



echo "Scripts to calculate git-blame at particular time periods
- git_blame_extract/

Old script that you don't need to run
-run git_new_path.sql to use the new paths and eliminate the '=>'

More info on time and frequency can be found in 
mining_procedure/freq"

date
