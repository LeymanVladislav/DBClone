declare
  v$owner       varchar2(32) := ?; --'CB';
  v$ObjName     varchar2(128) := ?; --'CUR_RATES_CB';
  v$ObjectTypes varchar2(128) := ?; --'TABLE'; --��� TABLE ��������� ������������ ������ � ���������� � ����������, � ����� AQ_TABLES
  v$EnableTCT   boolean := case ?
                             when 1 then
                              true
                             else
                              false
                           end; --true; --�������� �������� ������������ ��� ������

  --v$ObjDDL Clob;
  v$ObjDDLst clob;
  v$TMPStr   clob;
  function GetObjDLL(p$ObjName     in varchar2,
                     p$ObjNameNew  in varchar2 default null,
                     p$ObjectTypes in varchar2, -- TABLE,INDEX,COMMENT,PACKAGE
                     p$EnableTCT   in boolean default false -- ��� p$ObjectTypes = TABLE �������� �����������
                     ) return varchar2 is
  
    v$ObjectTypes varchar2(100);
    v$ObjDDL      clob;
    v_obj$ddls    sys.ku$_ddls;
    v#hdl         pls_integer;
    v#th1         pls_integer;
    v#th2         pls_integer;
    no_inmemory_ex exception;
  
    pragma exception_init(no_inmemory_ex,
                          -31600);
  
    procedure print_lob(p_clob in clob) is
      v#linesize pls_integer := 4000;
      v$buffer   varchar2(4000);
      v#buffer   pls_integer;
    begin
      v#buffer := dbms_lob.getlength(p_clob);
      for i in 0 .. floor(v#buffer / v#linesize) loop
        v$buffer := dbms_lob.substr(p_clob,
                                    v#linesize,
                                    1 + v#linesize * i);
        dbms_output.put_line(v$buffer);
      end loop;
    end print_lob;
  
  begin
    -- ��������� ����
    v$ObjectTypes := case p$ObjectTypes
                       when 'JOB' then
                        'PROCOBJ'
                       else
                        p$ObjectTypes
                     end;
  
    -- ���������� �������� ���� TABLE
    v#hdl := sys.dbms_metadata.open(v$ObjectTypes);
  
    if v$ObjectTypes in ('COMMENT') then
      -- ��������� �������
      sys.dbms_metadata.set_filter(v#hdl,
                                   'BASE_OBJECT_SCHEMA',
                                   v$owner);
      sys.dbms_metadata.set_filter(v#hdl,
                                   'BASE_OBJECT_NAME',
                                   p$ObjName);
    else
      -- ��������� �������
      if v$ObjectTypes not in ('USER') then
      sys.dbms_metadata.set_filter(v#hdl,
                                   'SCHEMA',
                                   v$owner);
      end if;
                                   
      sys.dbms_metadata.set_filter(v#hdl,
                                   'NAME',
                                   p$ObjName);
    end if;
  
    if v$ObjectTypes = 'TABLE'
       and p$ObjNameNew is not null then
      -- ���������� ������������� �������� �������
      v#th1 := sys.dbms_metadata.add_transform(v#hdl,
                                               'MODIFY',
                                               null,
                                               'TABLE');
    
      -- ��������� �������� ������� ��� ������������� v#th1
      sys.dbms_metadata.set_remap_param(v#th1,
                                        'REMAP_NAME',
                                        p$ObjName,
                                        p$ObjNameNew);
    
      -- ���� � PART_TUNING ������ ��, ��  ������� ����� ������� � ���
      /*sys.dbms_metadata.set_remap_param(v#th1,
      'REMAP_TABLESPACE',
      v$defTableSpaceNameSrc,
      v$tableSpaceNameNew);*/
    
    end if;
  
    -- ���������� ��� ����� �������������, ��� ��������� ������� �������� XML �� DDL(�����)
  
    v#th2 := sys.dbms_metadata.add_transform(v#hdl,
                                             'DDL');
  
    -- ���������� ������������ ��� ������������� v_th2
    sys.dbms_metadata.set_transform_param(v#th2,
                                          'SQLTERMINATOR',
                                          true);
                                          
    sys.dbms_metadata.set_transform_param(v#th2,
                                          'PRETTY',
                                          true);
  
    if v$ObjectTypes = 'TABLE' then
    
      if p$EnableTCT then
        -- �������� ������������ ��������� �������� ��� ������������� v#th2                                               
        sys.dbms_metadata.set_transform_param(v#th2,
                                              'CONSTRAINTS_AS_ALTER',
                                              true);
      
        -- ��������� ������������ ��� ������������� v#th2                                               
        sys.dbms_metadata.set_transform_param(v#th2,
                                              'CONSTRAINTS',
                                              true);
      
        -- ��������� ������� ������ ��� ������������� v#th2                                      
        sys.dbms_metadata.set_transform_param(v#th2,
                                              'REF_CONSTRAINTS',
                                              true);
        -- �������� ������������ ����� ALTE v#th2
        sys.dbms_metadata.set_transform_param(v#th2,
                                              'CONSTRAINTS_AS_ALTER',
                                              true);
      else
        -- ��������� ������������ ��� ������������� v#th2                                               
        sys.dbms_metadata.set_transform_param(v#th2,
                                              'CONSTRAINTS',
                                              false);
      
        -- ��������� ������� ������ ��� ������������� v#th2                                      
        sys.dbms_metadata.set_transform_param(v#th2,
                                              'REF_CONSTRAINTS',
                                              false);
      
      end if;
    
      -- ��������� INMEMORY ��� ������������� v#th2
      begin
        sys.dbms_metadata.set_transform_param(v#th2,
                                              'INMEMORY',
                                              false);
        -- ��������� ���������� �.�. �� ����� ���� INMEMORY
      exception
        when no_inmemory_ex then
          null;
      end;
    
    end if;
  
    if v$ObjectTypes in ('TABLE',
                         'INDEX') then
      -- ��������� ��������������� ��� ������������� v#th2
      sys.dbms_metadata.set_transform_param(v#th2,
                                            'PARTITIONING',
                                            false);
    
      -- ��������� �������������� ��������� ��� ������������� v#th2
      sys.dbms_metadata.set_transform_param(v#th2,
                                            'SEGMENT_ATTRIBUTES',
                                            false);
    end if;
  
    loop
      v_obj$ddls := sys.dbms_metadata.fetch_ddl(v#hdl);
      exit when v_obj$ddls is null;
      for i in 1 .. cardinality(v_obj$ddls) loop
        v$TMPStr := v_obj$ddls(i).ddlText;
        if v$ObjectTypes = 'COMMENT' then
          v$TMPStr := replace(v$TMPStr,
                              ';',
                              ';' || chr(10));
        end if;
        v$ObjDDL := v$ObjDDL || v$TMPStr;
      end loop;
    end loop;
  
    sys.dbms_metadata.close(v#hdl);
  
    return v$ObjDDL;
  exception
    when others then
      sys.dbms_metadata.close(v#hdl);
      raise;
  end;

begin
  v$ObjDDLst := GetObjDLL(p$ObjName     => v$ObjName,
                          p$ObjectTypes => v$ObjectTypes,
                          p$EnableTCT   => v$EnableTCT);
  ?          := v$ObjDDLst;
end;
