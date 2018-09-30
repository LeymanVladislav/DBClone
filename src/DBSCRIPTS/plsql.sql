declare
  test_param varchar2(10) := ?;
begin
  --dbms_output.put_line('Загружен тестовый параметр:' || test_param);
  ? := 'Загружен тестовый параметр:' || test_param;
end;