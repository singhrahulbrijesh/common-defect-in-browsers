\set ECHO all

create table git_blame_backup as select * from git_blame;
delete from git_blame where lower(filename) !~ E'\\.(cpp|h|java|c|cs|js|pl|sh|py|cxx)$';

VACUUM git_blame ;
ANALYZE git_blame ;
