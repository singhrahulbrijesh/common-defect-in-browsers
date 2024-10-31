\set ECHO all

alter table git_revision add column new_path text;

--a bit kludgy
update git_revision set new_path = r.new_path from (select path, substring(path from E'(.*)\\{.*\\=\\>\\s.*\\}.*') || substring(path from E'.*\\{.*\\=\\>\\s(.*)\\}.*') || substring(path from E'.*\\{.*\\=\\>\\s.*\\}(.*)') as new_path from git_revision where path ~ E'\\{') as r where r.path = git_revision.path;

update git_revision set new_path = path where new_path is null;

--a straight move with nothing in common
update git_revision set new_path = substring(path from E'.*=>\\s+(.*)$') where new_path ~ '=>';
