# Top Quantile and Leavers

## Top Quantile
Firstly, you need to specify top and non-top developers. Before running the following perl script you need to create a config file specific to your dataset. The schema of the config file is:
```
db_name = <databasename>
quantile = .80
```

The **Top Developers** are those with highest amount of ownership which their total ownership is less than or equal to the **quantile** parameter.

```
perl top_quantile.pl ./config/<configname>.conf
```

## Determine Leavers

The following script creates a table called **leavers** which determines how many core and non-core developers have left the project in each period.

```
psql -d <databasename> -f people_loss.sql
```
