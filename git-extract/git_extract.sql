\set ECHO all

drop table git_repo;
create table git_repo (
	commit text NOT NULL,
	repo text NOT NULL,
	primary key (commit, repo) 
);
create index git_repo_repo_idx on git_repo(repo);

drop table git_commit;
create table git_commit ( 
	commit text NOT NULL,
	tree text NOT NULL,
	author text NOT NULL,
	author_dt timestamp with time zone NOT NULL,
	auth_id integer, --the indiv_id of the author
	committer text NOT NULL,
	committer_dt timestamp with time zone NOT NULL,
	com_id integer, --the indiv_id of the committer
	subject text default '',
	num_child numeric default 0,
	num_parent numeric default 0,
	log text default '',
	primary key(commit)
);

drop table git_dag;
create table git_dag(
	child text NOT NULL,
	parent text NOT NULL,
	ordering integer default 0,
	primary key(child, parent)
);
create index git_dag_parent_idx on git_dag(parent);

drop table git_revision;
create table git_revision (
	commit text NOT NULL,
	add numeric, --can be null when binary files
	remove numeric,
	path text NOT NULL,
	primary key (commit, path)
);	
create index git_revision_commit_idx on git_revision(commit);

drop table git_refs_tags;
create table git_refs_tags (
	commit text NOT NULL,
	path text NOT NULL,
	primary key (commit, path)
);

drop table chain;
create table chain (
	commit text not null,
	name_addr text,
	indiv_id integer,
	type character(1) --s = Signed, a = Acked, c = Cc, r = Reviewed, t = Tested
);

create index chain_commit_idx on chain(commit);
