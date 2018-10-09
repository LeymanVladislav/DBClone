declare
  v$owner       varchar2(32) := ?;
  v$ObjName     varchar2(128) := ?;
  v$ObjectTypes varchar2(128) := ?; --Для USER выполнять запуск от ДБА

  v$ObjDDL clob;
begin
  -- Обработка типа
  v$ObjectTypes := case v$ObjectTypes
                     when 'JOB' then
                      'PROCOBJ'
                     else
                      v$ObjectTypes
                   end;

  -- Настройки
  DBMS_METADATA.set_transform_param(DBMS_METADATA.session_transform,
                                    'SQLTERMINATOR',
                                    true);
  DBMS_METADATA.set_transform_param(DBMS_METADATA.session_transform,
                                    'PRETTY',
                                    true);

  if v$ObjectTypes in ('COMMENT') then
    v$ObjDDL := DBMS_METADATA.get_dependent_ddl(v$ObjectTypes,
                                                v$ObjName);
  else
    v$ObjDDL := DBMS_METADATA.GET_DDL(v$ObjectTypes,
                                      v$ObjName);
  
    -- Добавление грантов
    if v$ObjectTypes in ('TABLE',
                         'TYPE') then
      v$ObjDDL := v$ObjDDL || DBMS_METADATA.GET_GRANTED_DDL('OBJECT_GRANT',
                                                            v$ObjName);
    end if;
  end if;

  -- Добавление системных грантов для пользователя
  if v$ObjectTypes = 'USER' then
    v$ObjDDL := v$ObjDDL || DBMS_METADATA.GET_GRANTED_DDL('SYSTEM_GRANT',
                                                          v$ObjName);
    --v$ObjDDL := v$ObjDDL || DBMS_METADATA.GET_GRANTED_DDL('ROLE_GRANT',v$ObjName);   
  end if;

  --dbms_output.put_line(to_char(v$ObjDDL));
  ? := v$ObjDDL;
end;
