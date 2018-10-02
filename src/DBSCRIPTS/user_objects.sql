declare
  v_cur$UserObjects sys_refcursor;
  v$ObjectTypeList  varchar2(4000) := ?;
begin
  open v_cur$UserObjects for
    select *
      from (select o.OBJECT_NAME OBJECT_NAME,
                   o.OBJECT_TYPE OBJECT_TYPE
              from user_objects o
            
              left join user_constraints c
                on c.CONSTRAINT_NAME = o.OBJECT_NAME
             where
            -- Ќе создаем индекс дл€ первичного ключа, т.к. будет создан при создании таблицы
             nvl(c.CONSTRAINT_TYPE,
                 '~') <> 'P'
            union
            select tc.TABLE_NAME,
                   'COMMENT' OBJECT_NAME
              from user_tab_comments tc) t
    
      join (select regexp_substr(v$ObjectTypeList,
                                 '[^;]+',
                                 1,
                                 level) type,
                   rownum position
              from dual
            connect by regexp_substr(v$ObjectTypeList,
                                     '[^;]+',
                                     1,
                                     level) is not null) ot
        on ot.TYPE = t.OBJECT_TYPE
     order by position;

  ? := v_cur$UserObjects;
end;
