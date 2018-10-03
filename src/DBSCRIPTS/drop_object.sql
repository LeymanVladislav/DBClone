declare
  --trigger_not_exists pls_integer := -04080;
begin
  execute immediate 'drop ' || ? || ' ' || ? || '.' || ?;
exception
  when others then
    ? := sqlerrm;
end;
