\set ECHO all

--ignores looks at any line within a file
-- in contrast, clean_* removes files

drop table if exists git_blame_ignore;
create table git_blame_ignore (
	commit text
);

--you'll want to look for migration commits, ie the oldest commits in the repo
--select count(*) files, committer_dt, sum(add+remove) lines, r.commit, log from git_revision r, git_commit c where c.commit = r.commit group by r.commit, committer_dt, log order by committer_dt;

--you'll now need to insert into this table whatever commits you think should be ignored.
--you can make your own list like this one for Chrome:
insert into git_blame_ignore select commit from git_commit where commit ~ E'(94ab292d2c79b1675de0d6ff0a7361ecfbf20cfb)';

--how many files, etc does this commit cover over the lifetime of the project?
--select committer_dt, auth_commit, count(distinct(filename)) as files, sum(lines) lines, count(distinct(r.commit)) as commits, sum(lines)/count(distinct(r.commit)), log from git_blame_raw r, git_commit c where c.commit = r.auth_commit group by auth_commit, committer_dt, log having count(distinct(filename)) >= 100 order by committer_dt;

--you could ignore really large commits
insert into git_blame_ignore
--test: select committer_dt, auth_commit, count(distinct(filename)) as files, sum(lines) lines, count(distinct(r.commit)) as commits, sum(lines)/count(distinct(r.commit)) 
select r.auth_commit
	from git_blame_raw r, git_commit c 
	where c.commit = r.auth_commit 
	group by auth_commit, committer_dt 
	having count(distinct(filename)) >= 1000;

--this will show you the commits with the most files and lines changed
--select count(*) files, committer_dt, sum(add+remove) lines, r.commit, log from git_revision r, git_commit c where c.commit = r.commit group by r.commit, committer_dt, log order by files desc;

--perhaps insert the top ten largest files changes
--insert into git_blame_ignore select commit from git_revision group by commit order by count(*) desc limit 10;

