\set ECHO all

alter table git_revision add column dir text;
update git_revision set dir = substring(canonical from E'(.*?/)[^/]+\\s*$');
create index dir_idx on git_revision(dir);

