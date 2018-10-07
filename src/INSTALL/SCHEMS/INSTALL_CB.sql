
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
	"CB_CODE" VARCHAR2(10) CONSTRAINT "CUR_RATES_CB_NUM_CODE_NN" NOT NULL ENABLE, 
	"CUR_DATE" DATE CONSTRAINT "CUR_RATES_CB_CUR_DATE_NN" NOT NULL ENABLE, 
	"VALUE" NUMBER CONSTRAINT "CUR_RATES_CB_VALUE_NN" NOT NULL ENABLE, 
	"LOAD_DATE" DATE CONSTRAINT "CUR_RATES_CB_LOAD_DATE_NN" NOT NULL ENABLE
   ) ;
  ALTER TABLE "CB"."CUR_RATES_CB" ADD CONSTRAINT "CUR_RATES_CB_ID_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE;
  ALTER TABLE "CB"."CUR_RATES_CB" ADD CONSTRAINT "CUR_RATES_CB_CODE_DATE_UNQ" UNIQUE ("CB_CODE", "CUR_DATE")
  USING INDEX  ENABLE;
  ALTER TABLE "CB"."CUR_RATES_CB" ADD CONSTRAINT "CUR_RATES_CB_CODE_FK" FOREIGN KEY ("CB_CODE")
	  REFERENCES "CB"."CUR_LIST" ("CB_CODE") ENABLE;

PROMPT
PROMPT =============================== CREATE TABLE LOG ===============================
CREATE TABLE "CB"."LOG" 
   (	"ID" NUMBER, 
	"DTIME" DATE, 
	"MODUL" VARCHAR2(200), 
	"CODE" VARCHAR2(100), 
	"MESSAGE" VARCHAR2(4000)
   ) ;
  ALTER TABLE "CB"."LOG" ADD CONSTRAINT "LOG_ID_PK" PRIMARY KEY ("ID")
  USING INDEX  ENABLE;

PROMPT
PROMPT =============================== CREATE TABLE CUR_LIST ===============================
CREATE TABLE "CB"."CUR_LIST" 
   (	"CB_CODE" VARCHAR2(10), 
	"CB_PARENT_CODE" VARCHAR2(10) CONSTRAINT "CUR_LIST_CB_PARENT_CODE_NN" NOT NULL ENABLE, 
	"ISO_NUM_CODE" NUMBER(3,0), 
	"ISO_CHAR_CODE" VARCHAR2(3), 
	"NAME" VARCHAR2(100) CONSTRAINT "CUR_LIST_NAME_NN" NOT NULL ENABLE, 
	"ENG_NAME" VARCHAR2(100) CONSTRAINT "CUR_LIST_ENG_NAME_NN" NOT NULL ENABLE, 
	"NOMINAL" NUMBER CONSTRAINT "CUR_LIST_NOMINAL_NN" NOT NULL ENABLE
   ) ;
  ALTER TABLE "CB"."CUR_LIST" ADD CONSTRAINT "CUR_LIST_CB_CODE_PK" PRIMARY KEY ("CB_CODE")
  USING INDEX  ENABLE;

PROMPT
PROMPT =============================== CREATE COMMENT CUR_RATES_CB ===============================
 COMMENT ON COLUMN "CB"."CUR_RATES_CB"."ID" IS '?ý??¢ð¤ðòÿ¢?  ò£ ¡ÿ';
 COMMENT ON COLUMN "CB"."CUR_RATES_CB"."CB_CODE" IS '?ý??¢ð¤ðòÿ¢?  ÷ÿ?®¢« ??';
 COMMENT ON COLUMN "CB"."CUR_RATES_CB"."CUR_DATE" IS '?ÿ¢ÿ £¡¢ÿ??÷òð ò£ ¡ÿ';
 COMMENT ON COLUMN "CB"."CUR_RATES_CB"."VALUE" IS '??ÿ§??ð? ò£ ¡ÿ ý?¯ £òÿ?ÿ????? ???ð?ÿ?ÿ';
 COMMENT ON COLUMN "CB"."CUR_RATES_CB"."LOAD_DATE" IS '?ÿ¢ÿ ?ÿ? £?òð ò£ ¡ÿ';
 COMMENT ON TABLE "CB"."CUR_RATES_CB"  IS '?ÿö?ð¦ÿ ¡ ò£ ÿ?ð ÷ÿ?®¢ ??';


PROMPT
PROMPT =============================== CREATE COMMENT CUR_LIST ===============================
 COMMENT ON COLUMN "CB"."CUR_LIST"."CB_CODE" IS 'CB-ò?ý ÷ÿ?®¢«';
 COMMENT ON COLUMN "CB"."CUR_LIST"."CB_PARENT_CODE" IS '?¡«?òÿ ?ÿ  ?ýð¢??¬¡òð? CB-ò?ý ÷ÿ?®¢«';
 COMMENT ON COLUMN "CB"."CUR_LIST"."ISO_NUM_CODE" IS '?ð¤ ?÷?? ISO-ò?ý ÷ÿ?®¢«';
 COMMENT ON COLUMN "CB"."CUR_LIST"."ISO_CHAR_CODE" IS '?ð?÷??¬?«? ISO-ò?ý ÷ÿ?®¢«';
 COMMENT ON COLUMN "CB"."CUR_LIST"."NAME" IS '?ÿ?÷ÿ?ð? ÷ÿ?®¢«';
 COMMENT ON COLUMN "CB"."CUR_LIST"."ENG_NAME" IS 'Currency name';
 COMMENT ON COLUMN "CB"."CUR_LIST"."NOMINAL" IS '???ð?ÿ? ÷ÿ?®¢« ý?¯ ?¢?ö ÿ???ð¯ ò£ ¡ÿ';
 COMMENT ON TABLE "CB"."CUR_LIST"  IS '?ÿö?ð¦ÿ ¡ ?ôð¡ÿ?ð?? ÷ÿ?®¢';


PROMPT
PROMPT =============================== CREATE COMMENT JOB_PARAMS ===============================
 COMMENT ON COLUMN "CB"."JOB_PARAMS"."JOB_NAME" IS '?ÿ?÷ÿ?ð? ?ÿýÿ?ð¯';
 COMMENT ON COLUMN "CB"."JOB_PARAMS"."PNAME" IS '?ÿ?÷ÿ?ð? ôÿ ÿ??¢ ÿ';
 COMMENT ON COLUMN "CB"."JOB_PARAMS"."PVALUE" IS '??ÿ§??ð? ôÿ ÿ??¢ ÿ';
 COMMENT ON TABLE "CB"."JOB_PARAMS"  IS '?ÿö?ð¦ÿ ¡ ?ÿ¡¢ ??òÿ?ð ý?¯ ?ÿýÿ?ð?';


PROMPT
PROMPT =============================== CREATE COMMENT LOG ===============================
 COMMENT ON COLUMN "CB"."LOG"."DTIME" IS '?ÿ¢ÿ ð ÷ ??¯ ?ÿôð¡ð';
 COMMENT ON COLUMN "CB"."LOG"."MODUL" IS '??ý£?¬ ?¢ ò?¢? ??? ô??£§??? ¡??ö©??ð?';
 COMMENT ON COLUMN "CB"."LOG"."CODE" IS '??ý ?¨ðöòð';
 COMMENT ON COLUMN "CB"."LOG"."MESSAGE" IS '?ôð¡ÿ?ð? ?¨ðöòð';
 COMMENT ON TABLE "CB"."LOG"  IS '?ÿö?ð¦ÿ ¡ ???ÿ?ð';


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

  -- ?ÿô ?¡ ??ÿ§??ð¯ ôÿ ÿ??¢ ÿ ý?¯ ?ÿýÿ?ð
  FUNCTION GET_PARAM_VAL(p$JOB_NAME IN JOB_PARAMS.JOB_NAME%TYPE,
                         p$PNAME    IN JOB_PARAMS.PNAME%TYPE) RETURN JOB_PARAMS.PVALUE%TYPE;

  -- ? ?¦?ý£ ÿ ý?¯ ?ÿýÿ?ð¯ ?ÿ? £?òð ò£ ¡?÷ ??
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

  -- ??¢?ý«
  ?$GET CONSTANT VARCHAR2(5) := 'GET';
  ?$POST CONSTANT VARCHAR2(5) := 'POST';

  -- ??ýð ?÷òð
  ?$WIN_1251 CONSTANT VARCHAR2(100) := 'windows-1251';

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

    -- ?ÿ¡¢ ??òÿ ò?ýð ?÷òð windows-1251
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
CREATE OR REPLACE EDITIONABLE PACKAGE "CB"."CUR_PKG" AS

  -- ?ôð¡?ò URL
  c$URL_LOAD_CUR_LIST_FROM_CB CONSTANT VARCHAR2(1000) := 'http://www.cbr.ru/scripts/XML_valFull.asp';
  c$URL_LOAD_CUR_RATE_FROM_CB CONSTANT VARCHAR2(1000) := 'http://www.cbr.ru/scripts/XML_dynamic.asp';

  -- ?? ?ÿ¢ ýÿ¢« ý?¯ ?ÿ? £?òð ò£ ¡?÷ ??
  c$DATE_FORMAT_URL CONSTANT VARCHAR2(1000) := 'DD/MM/YYYY'; -- ?? ?ÿ¢ ýÿ¢« ô? ?ýÿ÷ÿ??«? ÷ URL
  c$DATE_FORMAT_XML CONSTANT VARCHAR2(1000) := 'DD.MM.YYYY'; -- ?? ?ÿ¢ ýÿ¢« ÷ XML ?¢÷?¢?

  -- ?£?ò¦ð¯ ?ÿ? £?òð ¡ôð¡òÿ ÷ÿ?®¢ ¡  ?¡£ ¡ÿ ??
  FUNCTION LOAD_CUR_LIST_FROM_CB RETURN PLS_INTEGER;

  -- ?£?ò¦ð¯ ô ?÷? òð ¡£©?¡¢?÷?÷ÿ?ð¯ ò£ ¡ÿ
  FUNCTION EXISTS_CUR_CB(p$CUR_CB CUR_LIST.CB_CODE%TYPE) RETURN PLS_INTEGER;

  /* ?£?ò¦ð¯ ?ÿ? £?òð ò£ ¡?÷ £òÿ?ÿ???? ÷ÿ?®¢«, ?ÿ £òÿ?ÿ??«? ô? ð?ý ¡  ?¡£ ¡ÿ ??
  - p$DATE_REQ1 ?ÿ¢ÿ ?ÿ§ÿ?ÿ ô? ð?ýÿ ?ÿ? £?òð
  - p$DATE_REQ1 ?ÿ¢ÿ ?ÿ÷? ¨??ð¯ ô? ð?ýÿ ?ÿ? £?òð
  - p$CUR_CB ÷ÿ?®¢ÿ ÷ ¤? ?ÿ¢? ò?ýÿ ??
  */
  FUNCTION LOAD_CUR_RATE_FROM_CB(p$DATE_REQ1 IN DATE,
                                 p$DATE_REQ2 IN DATE,
                                 p$CUR_CB    IN CUR_LIST.CB_CODE%TYPE) RETURN PLS_INTEGER;

  /* ?£?ò¦ð¯ ?ÿ? £?òð ò£ ¡?÷ £òÿ?ÿ????? ¡ôð¡òÿ ÷ÿ?®¢, ?ÿ £òÿ?ÿ??«? ô? ð?ý ¡  ?¡£ ¡ÿ ??
  - p$DATE_REQ1 ?ÿ¢ÿ ?ÿ§ÿ?ÿ ô? ð?ýÿ ?ÿ? £?òð
  - p$DATE_REQ1 ?ÿ¢ÿ ?ÿ÷? ¨??ð¯ ô? ð?ýÿ ?ÿ? £?òð
  - p$CUR_CB_LIST ÷ÿ?®¢ÿ ÷ ¤? ?ÿ¢? ò?ýÿ ??
  */
  PROCEDURE LOAD_CUR_RATE_FROM_CB(p$DATE_REQ1   IN DATE,
                                 p$DATE_REQ2   IN DATE,
                                 p$CUR_CB_LIST IN VARCHAR2);
END CUR_PKG;
/
CREATE OR REPLACE EDITIONABLE PACKAGE BODY "CB"."CUR_PKG" AS
  C$NAME CONSTANT VARCHAR2(10) := 'CUR_PKG';

  FUNCTION LOAD_CUR_LIST_FROM_CB RETURN PLS_INTEGER AS
    C$CHILD_NAME CONSTANT VARCHAR2(21) := 'LOAD_CUR_LIST_FROM_CB';

    v_clob$resp CLOB;
    v#Error     PLS_INTEGER := 0;

  BEGIN
    -- ???£§??ð? ¡ôð¡òÿ ÷ÿ?®¢
    v#Error := HTTP_UTL.REQUEST(p$url       => c$URL_LOAD_CUR_LIST_FROM_CB,
                                p$method    => HTTP_UTL.?$GET,
                                p$charset   => HTTP_UTL.?$WIN_1251,
                                p_clob$resp => v_clob$resp);

    -- ?ÿ? £?òÿ ¡ôð¡òÿ ÷ öÿ?£
    IF v#Error <> 0 THEN
      RETURN v#Error;
    ELSIF V_CLOB$RESP IS NOT NULL THEN
      MERGE INTO CUR_LIST TBL
      USING (SELECT --RegistryType_STRUCT(extract(t.column_value,'//PNameID/text()').getStringVal(),
              extract(column_value, '//Item/@ID').getStringVal() CB_CODE,
              extract(column_value, '//ParentCode/text()').getStringVal() CB_PARENT_CODE,
              extract(column_value, '//ISO_Num_Code/text()').getStringVal() ISO_NUM_CODE,
              extract(column_value, '//ISO_Char_Code/text()').getStringVal() ISO_CHAR_CODE,
              extract(column_value, '//Name/text()').getStringVal() NAME,
              extract(column_value, '//EngName/text()').getStringVal() ENG_NAME,
              extract(column_value, '//Nominal/text()').getStringVal() NOMINAL
               FROM TABLE(XMLSequence(xmltype(v_clob$resp).extract('//Valuta/Item')))) VW
      ON (TBL.CB_CODE = VW.CB_CODE)
      WHEN MATCHED THEN
        UPDATE
           SET TBL.CB_PARENT_CODE = VW.CB_PARENT_CODE,
               TBL.ISO_NUM_CODE   = VW.ISO_NUM_CODE,
               TBL.ISO_CHAR_CODE  = VW.ISO_CHAR_CODE,
               TBL.NAME           = VW.NAME,
               TBL.ENG_NAME       = VW.ENG_NAME,
               TBL.NOMINAL        = VW.NOMINAL
         WHERE TBL.CB_PARENT_CODE <> VW.CB_PARENT_CODE
            OR TBL.ISO_NUM_CODE <> VW.ISO_NUM_CODE
            OR TBL.ISO_CHAR_CODE <> VW.ISO_CHAR_CODE
            OR TBL.NAME <> VW.NAME
            OR TBL.ENG_NAME <> VW.ENG_NAME
            OR TBL.NOMINAL <> VW.NOMINAL
      WHEN NOT MATCHED THEN
        INSERT (TBL.CB_CODE, TBL.CB_PARENT_CODE, TBL.ISO_NUM_CODE, TBL.ISO_CHAR_CODE, TBL.NAME, TBL.ENG_NAME, TBL.NOMINAL) VALUES (VW.CB_CODE, VW.CB_PARENT_CODE, VW.ISO_NUM_CODE, VW.ISO_CHAR_CODE, VW.NAME, VW.ENG_NAME, VW.NOMINAL);
      dbms_output.put_line(C$NAME || '.' || C$CHILD_NAME || 'count:' || SQL%ROWCOUNT);
      COMMIT;
    ELSE
      RETURN 3;
    END IF;

    RETURN v#Error;

  EXCEPTION
    WHEN OTHERS THEN
      --dbms_output.put_line(C$NAME || '.' || C$CHILD_NAME || 'SQLERRM:' || SQLERRM);
      LOG_PKG.PUT_LOG(C$NAME || '.' || C$CHILD_NAME,SQLCODE,SQLERRM);
      RETURN 1;
  END LOAD_CUR_LIST_FROM_CB;

  FUNCTION EXISTS_CUR_CB(p$CUR_CB CUR_LIST.CB_CODE%TYPE) RETURN PLS_INTEGER AS
    C$CHILD_NAME CONSTANT VARCHAR2(20) := 'EXISTS_CUR_CB';

    v#Count PLS_INTEGER;
  BEGIN
    SELECT COUNT(*) INTO v#Count FROM CUR_LIST WHERE CB_CODE = p$CUR_CB;

    IF v#Count > 0 THEN
      RETURN 0;
    ELSE
      RETURN 1;
    END IF;

  EXCEPTION
    WHEN OTHERS THEN
      --dbms_output.put_line(C$NAME || '.' || C$CHILD_NAME || 'SQLERRM:' || SQLERRM);
      LOG_PKG.PUT_LOG(C$NAME || '.' || C$CHILD_NAME,SQLCODE,SQLERRM);
      RETURN 1;
  END EXISTS_CUR_CB;

  FUNCTION LOAD_CUR_RATE_FROM_CB(p$DATE_REQ1 IN DATE,
                                 p$DATE_REQ2 IN DATE,
                                 p$CUR_CB    CUR_LIST.CB_CODE%TYPE) RETURN PLS_INTEGER AS
    C$CHILD_NAME CONSTANT VARCHAR2(21) := 'LOAD_CUR_RATE_FROM_CB';

    v_clob$resp CLOB;
    v#Error     PLS_INTEGER := 0;

  BEGIN
    -- ? ?÷? òÿ ?ÿ ¡£©?¡¢?÷ÿ?ð? ò£ ¡ÿ
    IF EXISTS_CUR_CB(p$CUR_CB) = 1 THEN
      --dbms_output.put_line(C$NAME || '.' || C$CHILD_NAME || ' CUR:' || p$CUR_CB || ' not exists');
      LOG_PKG.PUT_LOG(C$NAME || '.' || C$CHILD_NAME,'1','CUR:' || p$CUR_CB || ' not exists');
      RETURN 1;
    END IF;

    -- ???£§??ð? ò£ ¡?÷ £òÿ?ÿ???? ÷ÿ?®¢«
    v#Error := HTTP_UTL.REQUEST(p$url       => c$URL_LOAD_CUR_RATE_FROM_CB || '?' || 'date_req1=' || TO_CHAR(p$DATE_REQ1,
                                                                                                       c$DATE_FORMAT_URL) || '&' || 'date_req2=' || TO_CHAR(p$DATE_REQ2,
                                                                                                                                                      c$DATE_FORMAT_URL) || '&' || 'VAL_NM_RQ=' || p$CUR_CB,
                                p$method    => HTTP_UTL.?$GET,
                                p$charset   => HTTP_UTL.?$WIN_1251,
                                p_clob$resp => v_clob$resp);

    -- ?ÿ? £?òÿ ò£ ¡?÷ ÷ öÿ?£
    IF v#Error <> 0 THEN
      RETURN v#Error;
    ELSIF V_CLOB$RESP IS NOT NULL THEN
      --dbms_output.put_line(v_clob$resp);
      MERGE INTO CUR_RATES_CB TBL
      USING (SELECT extract(column_value, '//Record/@Date').getStringVal() CUR_DATE,
                    extract(column_value, '//Value/text()').getStringVal() VALUE
               FROM TABLE(XMLSequence(xmltype((v_clob$resp)).extract('//ValCurs/Record')))) VW
      ON (TBL.CB_CODE = p$CUR_CB AND TBL.CUR_DATE = TO_DATE(VW.CUR_DATE, c$DATE_FORMAT_XML))
      WHEN MATCHED THEN
        UPDATE
           SET TBL.VALUE     = VW.VALUE,
               TBL.LOAD_DATE = SYSDATE
         WHERE TBL.VALUE <> VW.VALUE
      WHEN NOT MATCHED THEN
        INSERT
          (TBL.CB_CODE, TBL.CUR_DATE, TBL.VALUE, TBL.LOAD_DATE)
        VALUES
          (p$CUR_CB,
           TO_DATE(VW.CUR_DATE,
                    c$DATE_FORMAT_XML), VW.VALUE, SYSDATE);
      dbms_output.put_line(C$NAME || '.' || C$CHILD_NAME || ' load rows for cur:' || p$CUR_CB || ' count:' || SQL%ROWCOUNT);
      COMMIT;
    ELSE
      RETURN 3;
    END IF;

    RETURN v#Error;

  EXCEPTION
    WHEN OTHERS THEN
      --dbms_output.put_line(C$NAME || '.' || C$CHILD_NAME || 'SQLERRM:' || SQLERRM);
      LOG_PKG.PUT_LOG(C$NAME || '.' || C$CHILD_NAME,SQLCODE,SQLERRM);
      RETURN 1;
  END LOAD_CUR_RATE_FROM_CB;

  PROCEDURE LOAD_CUR_RATE_FROM_CB(p$DATE_REQ1   IN DATE,
                                  p$DATE_REQ2   IN DATE,
                                  p$CUR_CB_LIST IN VARCHAR2) AS

    C$CHILD_NAME CONSTANT VARCHAR2(21) := 'LOAD_CUR_RATE_FROM_CB';

    v#Error  PLS_INTEGER := 0;
    v#i      PLS_INTEGER := 0;
    v$CUR_CB CUR_LIST.CB_CODE%TYPE;
  BEGIN
    LOOP
      v#i      := v#i + 1;
      v$CUR_CB := regexp_substr(p$CUR_CB_LIST,
                                '[^,]+',
                                1,
                                v#i);
      IF v$CUR_CB IS NULL THEN
        EXIT;
      END IF;

      v#Error := CUR_PKG.LOAD_CUR_RATE_FROM_CB(p$DATE_REQ1 => p$DATE_REQ1,
                                               p$DATE_REQ2 => p$DATE_REQ2,
                                               p$CUR_CB    => v$CUR_CB);

      IF v#Error <> 0 THEN
        dbms_output.put_line(C$NAME || '.' || C$CHILD_NAME || ' v#Error:' || v#Error || ' for load rate CUR_CB:' || v$CUR_CB);
      END IF;

    END LOOP;
  END LOAD_CUR_RATE_FROM_CB;

END CUR_PKG;
/

PROMPT
PROMPT =============================== CREATE JOB LOAD_CUR_RATE_CB ===============================

BEGIN 
dbms_scheduler.create_job('"LOAD_CUR_RATE_CB"',
job_type=>'STORED_PROCEDURE', job_action=>
'SCHEDULER_PKG.LOAD_CUR_RATE_FROM_CB'
, number_of_arguments=>0,
start_date=>TO_TIMESTAMP_TZ('15-SEP-2018 10.00.00,000000000 AM +07:00','DD-MON-RRRR HH.MI.SSXFF AM TZR','NLS_DATE_LANGUAGE=english'), repeat_interval=> 
'FREQ=DAILY;INTERVAL=1'
, end_date=>NULL,
job_class=>'"DEFAULT_JOB_CLASS"', enabled=>FALSE, auto_drop=>FALSE,comments=>
NULL
);
sys.dbms_scheduler.set_attribute('"LOAD_CUR_RATE_CB"','NLS_ENV','NLS_LANGUAGE=''RUSSIAN'' NLS_TERRITORY=''CIS'' NLS_CURRENCY=''à.'' NLS_ISO_CURRENCY=''CIS'' NLS_NUMERIC_CHARACTERS='', '' NLS_CALENDAR=''GREGORIAN'' NLS_DATE_FORMAT=''DD.MM.RR'' NLS_DATE_LANGUAGE=''RUSSIAN'' NLS_SORT=''RUSSIAN'' NLS_TIME_FORMAT=''HH24:MI:SSXFF'' NLS_TIMESTAMP_FORMAT=''DD.MM.RR HH24:MI:SSXFF'' NLS_TIME_TZ_FORMAT=''HH24:MI:SSXFF TZR'' NLS_TIMESTAMP_TZ_FORMAT=''DD.MM.RR HH24:MI:SSXFF TZR'' NLS_DUAL_CURRENCY=''à.'' NLS_COMP=''BINARY'' NLS_LENGTH_SEMANTICS=''BYTE'' NLS_NCHAR_CONV_EXCP=''FALSE''');
dbms_scheduler.enable('"LOAD_CUR_RATE_CB"');
COMMIT; 
END; 
/ 
Exit;
