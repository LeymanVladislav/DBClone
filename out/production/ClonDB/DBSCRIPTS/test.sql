def log_prefix = dbms_parallel_execute_insert
set feedback off
set heading off
set timing off
set echo off
col current_date new_value current_date noprint
select to_char(sysdate, 'yyyymmdd"_"hh24miss') current_date from dual;
def spool_file=spool_&log_prefix._&current_date..log
spool &spool_file.
col a for a100 fold_a
select 'DB_NAME:        '||sys_context('userenv', 'db_name')a,
       'INSTANCE_NAME:  '||sys_context('userenv', 'instance_name')a,
       'ISDBA:          '||sys_context('userenv', 'isdba')a,
       'SERVER_HOST:    '||sys_context('userenv', 'server_host')a,
       'SESSION_USER:   '||sys_context('userenv', 'session_user')a
  from dual;
set feedback on
set heading on
set serveroutput on size unlimited
set time on
set timing on
set echo on

declare
  test_param varchar2(10) := '&1';
begin
  dbms_output.put_line('Загружен тестовый параметр:' || test_param);
  null;
end;
/

spool off;

exit;
