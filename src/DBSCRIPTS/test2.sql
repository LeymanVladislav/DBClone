declare
 res clob;
begin
  ? := dbms_metadata.get_ddl(object_type => 'SEQUENCE',name => 'CUR_RATES_CB_ID_SEQ');
end;
