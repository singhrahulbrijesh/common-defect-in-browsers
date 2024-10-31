# dev info related to the periods and some aliasing

1. you probably want to do some real [name aliasing](https://github.com/CESEL/internal_tools/tree/master/NamesCleaningAndAliasing) and then go to step 4 (dev_info.sql)
2. but if not you can just add username to git_commit using
```
psql -d <databasename> -f add_username.sql
```
3. consistent company usernames, eg Avaya, Google Chrome
```
psql -d <databasename> -f company_username_aliasing.sql
```

4. calculate the dev info on leavers, joiners, etc
```
psql -d <databasename> -f dev_info.sql
```
