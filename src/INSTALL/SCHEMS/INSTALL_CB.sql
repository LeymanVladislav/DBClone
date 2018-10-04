
PROMPT
PROMPT =============================== CREATE TABLE JOB_PARAMS ===============================
CREATE TABLE "CB"."JOB_PARAMS" 
   (	"JOB_NAME" VARCHAR2(100), 
	"PNAME" VARCHAR2(100), 
	"PVALUE" VARCHAR2(2000), 
	 CONSTRAINT "JOB_PARAMS_PK" PRIMARY KEY ("JOB_NAME", "PNAME") ENABLE
   ) ORGANIZATION INDEX NOCOMPRESS ;

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
PROMPT =============================== CREATE COMMENT CUR_RATES_CB ===============================
 COMMENT ON COLUMN "CB"."CUR_RATES_CB"."ID" IS 'Идентификатор курса';
 COMMENT ON COLUMN "CB"."CUR_RATES_CB"."CB_CODE" IS 'Идентификатор валюты ЦБ';
 COMMENT ON COLUMN "CB"."CUR_RATES_CB"."CUR_DATE" IS 'Дата установки курса';
 COMMENT ON COLUMN "CB"."CUR_RATES_CB"."VALUE" IS 'Значение курса для указанного номинала';
 COMMENT ON COLUMN "CB"."CUR_RATES_CB"."LOAD_DATE" IS 'Дата загрузки курса';
 COMMENT ON TABLE "CB"."CUR_RATES_CB"  IS 'Таблица с курами валют ЦБ';


PROMPT
PROMPT =============================== CREATE COMMENT LOG ===============================
 COMMENT ON COLUMN "CB"."LOG"."DTIME" IS 'Дата и время записи';
 COMMENT ON COLUMN "CB"."LOG"."MODUL" IS 'Модуль от которого получено сообщение';
 COMMENT ON COLUMN "CB"."LOG"."CODE" IS 'Код ошибки';
 COMMENT ON COLUMN "CB"."LOG"."MESSAGE" IS 'Описание ошибки';
 COMMENT ON TABLE "CB"."LOG"  IS 'Таблица с логами';


PROMPT
PROMPT =============================== CREATE COMMENT CUR_LIST ===============================
 COMMENT ON COLUMN "CB"."CUR_LIST"."CB_CODE" IS 'CB-код валюты';
 COMMENT ON COLUMN "CB"."CUR_LIST"."CB_PARENT_CODE" IS 'Ссылка на родительский CB-код валюты';
 COMMENT ON COLUMN "CB"."CUR_LIST"."ISO_NUM_CODE" IS 'Цифровой ISO-код валюты';
 COMMENT ON COLUMN "CB"."CUR_LIST"."ISO_CHAR_CODE" IS 'Символьный ISO-код валюты';
 COMMENT ON COLUMN "CB"."CUR_LIST"."NAME" IS 'Название валюты';
 COMMENT ON COLUMN "CB"."CUR_LIST"."ENG_NAME" IS 'Currency name';
 COMMENT ON COLUMN "CB"."CUR_LIST"."NOMINAL" IS 'Номинал валюты для отображения курса';
 COMMENT ON TABLE "CB"."CUR_LIST"  IS 'Таблица с описанием валют';


PROMPT
PROMPT =============================== CREATE COMMENT JOB_PARAMS ===============================
 COMMENT ON COLUMN "CB"."JOB_PARAMS"."JOB_NAME" IS 'Название задания';
 COMMENT ON COLUMN "CB"."JOB_PARAMS"."PNAME" IS 'Название параметра';
 COMMENT ON COLUMN "CB"."JOB_PARAMS"."PVALUE" IS 'Значение параметра';
 COMMENT ON TABLE "CB"."JOB_PARAMS"  IS 'Таблица с настройками для заданий';


PROMPT
PROMPT =============================== CREATE INDEX LOG_D_M_IDX ===============================
CREATE INDEX "CB"."LOG_D_M_IDX" ON "CB"."LOG" ("DTIME", "MODUL") 
  ;

PROMPT
PROMPT =============================== CREATE INDEX CUR_RATES_CB_CODE_DATE_UNQ ===============================
CREATE UNIQUE INDEX "CB"."CUR_RATES_CB_CODE_DATE_UNQ" ON "CB"."CUR_RATES_CB" ("CB_CODE", "CUR_DATE") 
  ;

PROMPT
PROMPT =============================== CREATE SEQUENCE LOG_ID_SEQ ===============================
 CREATE SEQUENCE  "CB"."LOG_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 123 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;

PROMPT
PROMPT =============================== CREATE SEQUENCE CUR_RATES_CB_ID_SEQ ===============================
 CREATE SEQUENCE  "CB"."CUR_RATES_CB_ID_SEQ"  MINVALUE 1 MAXVALUE 9999999999999999999999999999 INCREMENT BY 1 START WITH 665 CACHE 20 NOORDER  NOCYCLE  NOKEEP  NOSCALE  GLOBAL ;

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
Exit;
