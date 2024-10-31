\set ECHO all

alter table git_blame rename to git_blame_initial_commit;
alter index ufp_git_blame_idx rename to ufp_git_blame_initial_idx;
alter index pf_git_blame_idx rename to pf_git_blame_initial_idx;
alter table git_blame_raw rename to git_blame_raw_initial_commit;
alter table blame_file rename to blame_file_initial_commit;
