\set ECHO all

--choose a file
select * from git_blame_raw b, periods p where b.commit not in (select commit from git_blame_ignore) and p.last_commit = b.commit and filename = 'tcm/tcm_fpga.h' and period = 12;

--see when the person left
select * from dev_info where username = 'whleung' or username = 'mstewart';

--test that it the right num of developers
select * from blame_file where filename = 'tcm/tcm_fpga.h' and period = 12;
select * from blame_file where filename = 'tcm/tcm_fpga.h' and period = 11;
