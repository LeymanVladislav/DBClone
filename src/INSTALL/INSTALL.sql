--=============================== SQLPLUS settings ===============================
SET VERIFY OFF TIMING ON TERMOUT ON ECHO OFF HEADING OFF FEEDBACK ON SERVEROUTPUT ON LINESIZE 80 PAGESIZE 50

PROMPT
PROMPT =============================== Connect CB user ===============================
CONNECT CB/1@DB_REPL

PROMPT
PROMPT =============================== Execute INSTALL_CB.sql ===============================
@src/INSTALL/SCHEMS/INSTALL_CB.sql

