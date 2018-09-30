declare
  v_cur$UserObjects sys_refcursor;
  v$ObjectTypeList varchar2(4000) := ?;
begin
  open v_cur$UserObjects for
    select o.OBJECT_NAME OBJECT_NAME,
           o.OBJECT_TYPE OBJECT_TYPE
      from user_objects o
      join (select regexp_substr(v$ObjectTypeList,
                                 '[^;]+',
                                 1,
                                 level) type
              from dual
            connect by regexp_substr(v$ObjectTypeList,
                                     '[^;]+',
                                     1,
                                     level) is not null) ot
        on ot.TYPE = o.OBJECT_TYPE;

  ? := v_cur$UserObjects;
end;