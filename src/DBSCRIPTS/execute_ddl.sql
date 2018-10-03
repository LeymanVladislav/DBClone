declare
  v$DDLFull varchar2(4000) := ?;
  v$DDL     varchar(4000);

  /**
  * ��������� ������� ������ ������� ";" �� DDL
  * ��� ���������� DDL ����� execute immediate, DDL ��� �� ������ ������������� �� ";", ������ ���� ��� �� �������� END;
  */
  procedure ModifyDDLForExImmediate(p$DDL in out nocopy varchar2) is
    v$ChrPos pls_integer;
    v$ChrCnt pls_integer;
  begin
    v$ChrCnt := regexp_count(v$DDL,
                             ';');
    v$ChrPos := regexp_instr(v$DDL,
                             ';',
                             1,
                             v$ChrCnt);
    -- �������� �� ���������� ������� ";"
    v$DDL := substr(v$DDL,
                    1,
                    v$ChrPos - 1);
    -- ���� ��������� �������� END ��������������� END;
    v$DDL := regexp_replace(v$DDL,
                            '(END)$',
                            'END;');
  end;
begin
  for i in 1 .. 999 loop
    -- ��������� DDL ��� �� ��������� ������� �� ����������� "/"
    v$DDL := regexp_substr(v$DDLFull,
                           '[^/]+',
                           1,
                           i);
  
    -- ������� ������ ";"
    ModifyDDLForExImmediate(v$DDL);
    dbms_output.put_line('i:' || i || ' DDL:' || v$DDL);
  
    if v$DDL is null then
      exit;
    end if;
  -- ��������� �������
  begin
  execute immediate v$DDL;
  exception
  when others then
    dbms_output.put_line('Error: ' || sqlerrm);
  end;
  
  end loop;
end;
