
PROMPT
PROMPT =============================== CREATE TABLE JOB_PARAMS ===============================
CREATE TABLE "CB"."JOB_PARAMS" 
   (	"JOB_NAME" VARCHAR2(100), 
	"PNAME" VARCHAR2(100), 
	"PVALUE" VARCHAR2(2000), 
	 CONSTRAINT "JOB_PARAMS_PK" PRIMARY KEY ("JOB_NAME", "PNAME") ENABLE
   ) ORGANIZATION INDEX NOCOMPRESS ;

PROMPT
PROMPT =============================== CREATE TABLE CUR_RATES_CB ===============================
CREATE TABLE "CB"."CUR_RATES_CB" 
   (	"ID" NUMBER, 
	"CB_CODE" VARCHAR2(10), 
	"CUR_DATE" DATE, 
	"VALUE" NUMBER, 
	"LOAD_DATE" DATE
   ) ;

PROMPT
PROMPT =============================== CREATE TABLE LOG ===============================
CREATE TABLE "CB"."LOG" 
   (	"ID" NUMBER, 
	"DTIME" DATE, 
	"MODUL" VARCHAR2(200), 
	"CODE" VARCHAR2(100), 
	"MESSAGE" VARCHAR2(4000)
   ) ;

PROMPT
PROMPT =============================== CREATE TABLE CUR_LIST ===============================
CREATE TABLE "CB"."CUR_LIST" 
   (	"CB_CODE" VARCHAR2(10), 
	"CB_PARENT_CODE" VARCHAR2(10), 
	"ISO_NUM_CODE" NUMBER(3,0), 
	"ISO_CHAR_CODE" VARCHAR2(3), 
	"NAME" VARCHAR2(100), 
	"ENG_NAME" VARCHAR2(100), 
	"NOMINAL" NUMBER
   ) ;

PROMPT
PROMPT =============================== CREATE COMMENT CUR_RATES_CB ===============================
 COMMENT ON COLUMN "CB"."CUR_RATES_CB"."ID" IS '�����䨪��� ����';
 COMMENT ON COLUMN "CB"."CUR_RATES_CB"."CB_CODE" IS '�����䨪��� ������ ��';
 COMMENT ON COLUMN "CB"."CUR_RATES_CB"."CUR_DATE" IS '��� ��⠭���� ����';
 COMMENT ON COLUMN "CB"."CUR_RATES_CB"."VALUE" IS '���祭�� ���� ��� 㪠������� ��������';
 COMMENT ON COLUMN "CB"."CUR_RATES_CB"."LOAD_DATE" IS '��� ����㧪� ����';
 COMMENT ON TABLE "CB"."CUR_RATES_CB"  IS '������ � ��ࠬ� ����� ��';


PROMPT
PROMPT =============================== CREATE COMMENT CUR_LIST ===============================
 COMMENT ON COLUMN "CB"."CUR_LIST"."CB_CODE" IS 'CB-��� ������';
 COMMENT ON COLUMN "CB"."CUR_LIST"."CB_PARENT_CODE" IS '��뫪� �� த�⥫�᪨� CB-��� ������';
 COMMENT ON COLUMN "CB"."CUR_LIST"."ISO_NUM_CODE" IS '���஢�� ISO-��� ������';
 COMMENT ON COLUMN "CB"."CUR_LIST"."ISO_CHAR_CODE" IS '�������� ISO-��� ������';
 COMMENT ON COLUMN "CB"."CUR_LIST"."NAME" IS '�������� ������';
 COMMENT ON COLUMN "CB"."CUR_LIST"."ENG_NAME" IS 'Currency name';
 COMMENT ON COLUMN "CB"."CUR_LIST"."NOMINAL" IS '������� ������ ��� �⮡ࠦ���� ����';
 COMMENT ON TABLE "CB"."CUR_LIST"  IS '������ � ���ᠭ��� �����';


PROMPT
PROMPT =============================== CREATE COMMENT JOB_PARAMS ===============================
 COMMENT ON COLUMN "CB"."JOB_PARAMS"."JOB_NAME" IS '�������� �������';
 COMMENT ON COLUMN "CB"."JOB_PARAMS"."PNAME" IS '�������� ��ࠬ���';
 COMMENT ON COLUMN "CB"."JOB_PARAMS"."PVALUE" IS '���祭�� ��ࠬ���';
 COMMENT ON TABLE "CB"."JOB_PARAMS"  IS '������ � ����ன���� ��� �������';


PROMPT
PROMPT =============================== CREATE COMMENT LOG ===============================
 COMMENT ON COLUMN "CB"."LOG"."DTIME" IS '��� � �६� �����';
 COMMENT ON COLUMN "CB"."LOG"."MODUL" IS '����� �� ���ண� ����祭� ᮮ�饭��';
 COMMENT ON COLUMN "CB"."LOG"."CODE" IS '��� �訡��';
 COMMENT ON COLUMN "CB"."LOG"."MESSAGE" IS '���ᠭ�� �訡��';
 COMMENT ON TABLE "CB"."LOG"  IS '������ � ������';


PROMPT
PROMPT =============================== CREATE INDEX CUR_RATES_CB_CODE_DATE_UNQ ===============================
CREATE UNIQUE INDEX "CB"."CUR_RATES_CB_CODE_DATE_UNQ" ON "CB"."CUR_RATES_CB" ("CB_CODE", "CUR_DATE") 
  ;

PROMPT
PROMPT =============================== CREATE INDEX LOG_D_M_IDX ===============================
CREATE INDEX "CB"."LOG_D_M_IDX" ON "CB"."LOG" ("DTIME", "MODUL") 
  ;

PROMPT
PROMPT =============================== CREATE SEQUENCE LOG_ID_SEQ ===============================
 CREATE SEQUENCE  "CB"."LOG_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 123 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;

PROMPT
PROMPT =============================== CREATE SEQUENCE CUR_RATES_CB_ID_SEQ ===============================
 CREATE SEQUENCE  "CB"."CUR_RATES_CB_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 667 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;

PROMPT
PROMPT =============================== CREATE TRIGGER CUR_RATES_CB_ID_TRG ===============================
CREATE OR REPLACE EDITIONABLE TRIGGER "CB"."CUR_RATES_CB_ID_TRG" 
  BEFORE INSERT ON CUR_RATES_CB
  FOR EACH ROW
BEGIN
  IF :new.ID IS NULL THEN
    :new.ID := CUR_RATES_CB_ID_SEQ.NEXTVAL;
  END IF;
END;
/
ALTER TRIGGER "CB"."CUR_RATES_CB_ID_TRG" ENABLE;

PROMPT
PROMPT =============================== CREATE TRIGGER LOG_TRG ===============================
CREATE OR REPLACE EDITIONABLE TRIGGER "CB"."LOG_TRG" 
  BEFORE INSERT ON LOG
  FOR EACH ROW
BEGIN
  IF :new.ID IS NULL THEN
    :new.ID := LOG_ID_SEQ.NEXTVAL;
  END IF;
END;
/
ALTER TRIGGER "CB"."LOG_TRG" ENABLE;

PROMPT
PROMPT =============================== CREATE PACKAGE LOG_PKG ===============================
CREATE OR REPLACE EDITIONABLE PACKAGE "CB"."LOG_PKG" AS

  PROCEDURE PUT_LOG(p$Modul   IN VARCHAR2,
                    p$Code    IN VARCHAR2,
                    p$Message IN VARCHAR2);

END LOG_PKG;
/
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CB"."LOG_PKG" AS

  PROCEDURE PUT_LOG(p$Modul   IN VARCHAR2,
                    p$Code    IN VARCHAR2,
                    p$Message IN VARCHAR2) AS

  BEGIN
    INSERT INTO LOG (DTIME, MODUL, CODE, MESSAGE) VALUES (SYSDATE, p$Modul, p$Code, p$Message);
    COMMIT;
  END PUT_LOG;

END LOG_PKG;
/

PROMPT
PROMPT =============================== CREATE PACKAGE SCHEDULER_PKG ===============================
CREATE OR REPLACE EDITIONABLE PACKAGE "CB"."SCHEDULER_PKG" AS

  -- ����� ���祭�� ��ࠬ��� ��� ������
  FUNCTION GET_PARAM_VAL(p$JOB_NAME IN JOB_PARAMS.JOB_NAME%TYPE,
                         p$PNAME    IN JOB_PARAMS.PNAME%TYPE) RETURN JOB_PARAMS.PVALUE%TYPE;

  -- ��楤�� ��� ������� ����㧪� ���ᮢ ��
  PROCEDURE LOAD_CUR_RATE_FROM_CB;

END SCHEDULER_PKG;
/
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CB"."SCHEDULER_PKG" AS
  C$NAME CONSTANT VARCHAR2(20) := 'SCHEDULER_PKG';

  FUNCTION GET_PARAM_VAL(p$JOB_NAME IN JOB_PARAMS.JOB_NAME%TYPE,
                         p$PNAME    IN JOB_PARAMS.PNAME%TYPE) RETURN JOB_PARAMS.PVALUE%TYPE AS
    C$CHILD_NAME CONSTANT VARCHAR2(20) := 'GET_PARAM_VAL';
    v$PVALUE JOB_PARAMS.PVALUE%TYPE;
  BEGIN
    SELECT PVALUE
      INTO v$PVALUE
      FROM JOB_PARAMS
     WHERE JOB_NAME = p$JOB_NAME
       AND PNAME = p$PNAME;
    RETURN v$PVALUE;

  EXCEPTION
    WHEN OTHERS THEN
      --dbms_output.put_line(C$NAME || '.' || C$CHILD_NAME || 'SQLERRM:' || SQLERRM);
      LOG_PKG.PUT_LOG(C$NAME || '.' || C$CHILD_NAME,SQLCODE,SQLERRM);
      RETURN NULL;
  END GET_PARAM_VAL;

  PROCEDURE LOAD_CUR_RATE_FROM_CB AS
    C$CHILD_NAME CONSTANT VARCHAR2(21) := 'LOAD_CUR_RATE_FROM_CB';
    v$PVALUE JOB_PARAMS.PVALUE%TYPE;
  BEGIN
    v$PVALUE := GET_PARAM_VAL('LOAD_CUR_RATE_CB',
                              'CUR_LIST');
    IF v$PVALUE IS NOT NULL THEN
      CUR_PKG.LOAD_CUR_RATE_FROM_CB(p$DATE_REQ1   => SYSDATE,
                                    p$DATE_REQ2   => SYSDATE,
                                    p$CUR_CB_LIST => v$PVALUE);
    END IF;

  END LOAD_CUR_RATE_FROM_CB;

END SCHEDULER_PKG;
/

PROMPT
PROMPT =============================== CREATE PACKAGE HTTP_UTL ===============================
CREATE OR REPLACE EDITIONABLE PACKAGE "CB"."HTTP_UTL" AS

  -- ��⮤�
  �$GET CONSTANT VARCHAR2(5) := 'GET';
  �$POST CONSTANT VARCHAR2(5) := 'POST';

  -- ����஢��
  �$WIN_1251 CONSTANT VARCHAR2(100) := 'windows-1251';

  FUNCTION request(p$url       IN VARCHAR2,
                   p$method    IN VARCHAR2,
                   p$charset   IN VARCHAR2,
                   p_clob$resp IN OUT NOCOPY CLOB) RETURN PLS_INTEGER;
END HTTP_UTL;
/
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CB"."HTTP_UTL" AS

  C$NAME CONSTANT VARCHAR2(10) := 'HTTP_UTL';

  FUNCTION REQUEST(p$url       IN VARCHAR2,
                   p$method    IN VARCHAR2,
                   p$charset   IN VARCHAR2,
                   p_clob$resp IN OUT NOCOPY CLOB) RETURN PLS_INTEGER AS

    C$CHILD_NAME CONSTANT VARCHAR2(20) := 'REQUEST';

    v_obj$Req     utl_http.req;
    v_obj$Reqsult utl_http.resp;
    v$Bufer       VARCHAR2(1000);
    v_clob$Resp   CLOB;

    v#Error PLS_INTEGER := 0;

  BEGIN
    v_obj$Req := utl_http.begin_request(p$url,
                                        p$method);

    -- ����ன�� ����஢�� windows-1251
    utl_http.set_header(v_obj$Req,
                        'Content-Type',
                        'text/xml; charset=' || p$charset);

    v_obj$Reqsult := utl_http.get_response(v_obj$Req);

    dbms_lob.createtemporary(v_clob$Resp,
                             TRUE);
    BEGIN
      LOOP
        utl_http.read_text(v_obj$Reqsult,
                           v$Bufer,
                           1000);
        dbms_lob.append(v_clob$Resp,
                        v$Bufer);
      END LOOP;
    EXCEPTION
      WHEN utl_http.end_of_body THEN
        utl_http.end_response(v_obj$Reqsult);
    END;

    p_clob$resp := v_clob$resp;
    dbms_lob.freetemporary(v_clob$resp);

    RETURN v#Error;
  EXCEPTION
    WHEN OTHERS THEN
      LOG_PKG.PUT_LOG(C$NAME || '.' || C$CHILD_NAME,SQLCODE,SQLERRM);
      RETURN 1;
  END REQUEST;

END HTTP_UTL;
/

PROMPT
PROMPT =============================== CREATE PACKAGE CUR_PKG ===============================
