declare
  --trigger_not_exists pls_integer := -04080;  
  v$ObjType varchar2(100) := ?;
  v$ObjSchema varchar2(100) := ?;
  v$ObjNAme varchar2(100) := ?;
begin
  if v$ObjType = 'JOB' then
    dbms_scheduler.drop_job(job_name => v$ObjSchema || '.' || v$ObjNAme);
  elsif v$ObjType = 'COMMENT' then
    null;
  else
    execute immediate 'drop ' || v$ObjType || ' ' || v$ObjSchema || '.' || v$ObjNAme;
  end if;
exception
  when others then
    ? := sqlerrm;
end;
