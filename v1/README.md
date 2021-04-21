### Simulate changes in Dev 
```bash
[oracle@ol8 v1]$ sql devuser/devuser@pdb1
```

```sql
SQL> @dev_setup.sql
SQL> @populate_t_salesrep.sql
```

### Unload the changes from Dev

Unload schema (alternatively, lb can generate objects instead of whole schema)
```sql
SQL> lb genschema -grants

[Method loadCaptureTable]:                  Running
[Type - TYPE_SPEC]:                          397 ms
[Type - TYPE_BODY]:                           73 ms
[Type - SEQUENCE]:                            19 ms
[Type - DIRECTORY]:                           21 ms
[Type - CLUSTER]:                           1724 ms
[Type - TABLE]:                             7885 ms
[Type - MATERIALIZED_VIEW_LOG]:               31 ms
[Type - MATERIALIZED_VIEW]:                   17 ms
[Type - VIEW]:                              1023 ms
[Type - DIMENSION]:                           27 ms
[Type - FUNCTION]:                            45 ms
[Type - PROCEDURE]:                           40 ms
[Type - PACKAGE_SPEC]:                        43 ms
[Type - DB_LINK]:                             23 ms
[Type - SYNONYM]:                             26 ms
[Type - INDEX]:                              902 ms
[Type - TRIGGER]:                             70 ms
[Type - PACKAGE_BODY]:                        57 ms
[Type - JOB]:                                 29 ms
[Type - OBJECT_GRANT]:                        72 ms
[Method loadCaptureTable]:                 12525 ms
[Method parseCaptureTableRecords]:             9 ms
[Method sortCaptureTable]:                    10 ms
[Method cleanupCaptureTable]:                  6 ms
[Method writeChangeLogs]:                      4 ms


Export Flags Used:

Export Grants           true
Export Synonyms         false
```

Unload data
```sql
SQL> lb data -object T_SALESREP

Action successfully completed please review created file data.xml
```

### Deploy the changes into UAT

```bash
[oracle@ol8 v1]$ sql uatuser/uatuser@pdb1
```
Preview the changes for schema
```sql
SQL> lb updatesql -changelog controller.xml

ScriptRunner Logging: t_salesrep_table.xml::5f7092574ca12d6a42648f21717d9758429fd514::(DEVUSER)-Generated -- DONE
ScriptRunner Logging: p_payroll_procedure.xml::b93abb866de9e240f190ced94fbfe1a165d14175::(DEVUSER)-Generated -- DONE
ScriptRunner Logging: object_grant0.xml::afc9430c6e5d0a1bfaa85ff2620f6ad147f600b0::(DEVUSER)-Generated -- DONE

-- *********************************************************************
-- Update Database Script
-- *********************************************************************
-- Change Log: controller.xml
-- Ran at: 4/21/21 10:16 AM
-- Against: UATUSER@jdbc:oracle:oci8:@pdb1
-- Liquibase version: 4.1.1
-- *********************************************************************

-- Create Database Lock Table
CREATE TABLE UATUSER.DATABASECHANGELOGLOCK (ID INTEGER NOT NULL, LOCKED NUMBER(1) NOT NULL, LOCKGRANTED TIMESTAMP, LOCKEDBY VARCHAR2(255), CONSTRAINT PK_DATABASECHANGELOGLOCK PRIMARY KEY (ID));

-- Initialize Database Lock Table
DELETE FROM UATUSER.DATABASECHANGELOGLOCK;

INSERT INTO UATUSER.DATABASECHANGELOGLOCK (ID, LOCKED) VALUES (1, 0);

-- Lock Database
UPDATE UATUSER.DATABASECHANGELOGLOCK SET LOCKED = 1, LOCKEDBY = 'ol8.oci.net (10.0.2.15)', LOCKGRANTED = TO_TIMESTAMP('2021-04-21 10:16:58.592', 'YYYY-MM-DD HH24:MI:SS.FF') WHERE ID = 1 AND LOCKED = 0;

-- Create Database Change Log Table
CREATE TABLE UATUSER.DATABASECHANGELOG (ID VARCHAR2(255) NOT NULL, AUTHOR VARCHAR2(255) NOT NULL, FILENAME VARCHAR2(255) NOT NULL, DATEEXECUTED TIMESTAMP NOT NULL, ORDEREXECUTED INTEGER NOT NULL, EXECTYPE VARCHAR2(10) NOT NULL, MD5SUM VARCHAR2(35), DESCRIPTION VARCHAR2(255), COMMENTS VARCHAR2(255), TAG VARCHAR2(255), LIQUIBASE VARCHAR2(20), CONTEXTS VARCHAR2(255), LABELS VARCHAR2(255), DEPLOYMENT_ID VARCHAR2(10));

-- Changeset t_salesrep_table.xml::5f7092574ca12d6a42648f21717d9758429fd514::(DEVUSER)-Generated
CREATE TABLE "T_SALESREP"
   (    "ID" NUMBER,
        "FULLNAME" VARCHAR2(30),
        "SALARY" NUMBER,
        PRIMARY KEY ("ID")
  USING INDEX
  PCTFREE 10 INITRANS 2 MAXTRANS 255 LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS"  ENABLE
   ) SEGMENT CREATION IMMEDIATE
  PCTFREE 10 PCTUSED 40 INITRANS 1 NOCOMPRESS LOGGING
  STORAGE( INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1
  BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS";

-- Logging Oracle Extension actions to the Database.
 DECLARE
 id varchar2(200) := '5f7092574ca12d6a42648f21717d9758429fd514';
 rawAction clob;
 rawSxml clob;
 myrow varchar2(2000);
 action clob := '';
 sxml clob := '';
 dep varchar2(200) := '8971418554';
 author varchar2(200) := '(DEVUSER)-Generated';
 filename varchar2(200) := 't_salesrep_table.xml';
 insertlog varchar2(200) := 'insert into DATABASECHANGELOG_ACTIONS (id,author,filename,sql,sxml,deployment_id) values (:id,:author,:filename,:action,:sxml,:dep) returning rowid into :out';
 updateaction varchar2(200) := 'update DATABASECHANGELOG_ACTIONS set sql = sql ||:action where rowid = :myrow ';
 updatesxml varchar2(200) := 'update DATABASECHANGELOG_ACTIONS set sxml = sxml ||:sxml where rowid = :myrow ';
 begin
action := utl_raw.cast_to_varchar2(utl_encode.base64_decode(utl_raw.cast_to_raw(q'{Q1JFQVRFIFRBQkxFICJUX1NBTEVTUkVQIiAKICAgKAkiSUQiIE5VTUJFUiwKCSJGVUxMTkFNRSIgVkFSQ0hBUjIoMzApLAoJIlNBTEFSWSIgTlVNQkVSLAoJUFJJTUFSWSBLRVkgKCJJRCIpCiAgVVNJTkcgSU5ERVgKICBQQ1RGUkVFIDEwIElOSVRSQU5TIDIgTUFYVFJBTlMgMjU1IExPR0dJTkcKICBTVE9SQUdFKElOSVRJQUwgNjU1MzYgTkVYVCAxMDQ4NTc2IE1JTkVYVEVOVFMgMSBNQVhFWFRFTlRTIDIxNDc0ODM2NDUgCiAgUENUSU5DUkVBU0UgMCBGUkVFTElTVFMgMSBGUkVFTElTVCBHUk9VUFMgMSBCVUZGRVJfUE9PTCBERUZBVUxUIEZMQVNIX0NBQ0hFIERFRkFVTFQgQ0VMTF9GTEFTSF9DQUNIRSBERUZBVUxUKQogIFRBQkxFU1BBQ0UgIlVTRVJTIiAgRU5BQkxFCiAgICkgU0VHTUVOVCBDUkVBVElPTiBJTU1FRElBVEUKICBQQ1RGUkVFIDEwIFBDVFVTRUQgNDAgSU5JVFJBTlMgMSBOT0NPTVBSRVNTIExPR0dJTkcKICBTVE9SQUdFKCBJTklUSUFMIDY1NTM2IE5FWFQgMTA0ODU3NiBNSU5FWFRFTlRTIDEgTUFYRVhURU5UUyAyMTQ3NDgzNjQ1CiAgUENUSU5DUkVBU0UgMCBGUkVFTElTVFMgMSBGUkVFTElTVCBHUk9VUFMgMQogIEJVRkZFUl9QT09MIERFRkFVTFQgRkxBU0hfQ0FDSEUgREVGQVVMVCBDRUxMX0ZMQVNIX0NBQ0hFIERFRkFVTFQpCiAgVEFCTEVTUEFDRSAiVVNFUlMiOw==}')));
 execute immediate insertlog using id,author,filename,action,sxml,dep returning into myrow;
end;
/
--;

INSERT INTO UATUSER.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('5f7092574ca12d6a42648f21717d9758429fd514', '(DEVUSER)-Generated', 't_salesrep_table.xml', SYSTIMESTAMP, 1, '8:95f32c4a3b5d0d7cd0d85deb33943760', 'createSxmlObject objectName=T_SALESREP, ownerName=DEVUSER', '', 'EXECUTED', NULL, NULL, '4.1.1', '8971418554');

-- Changeset p_payroll_procedure.xml::b93abb866de9e240f190ced94fbfe1a165d14175::(DEVUSER)-Generated
CREATE OR REPLACE EDITIONABLE PROCEDURE "P_PAYROLL"
as
        v_salary        number;
begin
        -- omit implementation detail
        null;
end;

-- Logging Oracle Extension actions to the Database.
 DECLARE
 id varchar2(200) := 'b93abb866de9e240f190ced94fbfe1a165d14175';
 rawAction clob;
 rawSxml clob;
 myrow varchar2(2000);
 action clob := '';
 sxml clob := '';
 dep varchar2(200) := '8971418554';
 author varchar2(200) := '(DEVUSER)-Generated';
 filename varchar2(200) := 'p_payroll_procedure.xml';
 insertlog varchar2(200) := 'insert into DATABASECHANGELOG_ACTIONS (id,author,filename,sql,sxml,deployment_id) values (:id,:author,:filename,:action,:sxml,:dep) returning rowid into :out';
 updateaction varchar2(200) := 'update DATABASECHANGELOG_ACTIONS set sql = sql ||:action where rowid = :myrow ';
 updatesxml varchar2(200) := 'update DATABASECHANGELOG_ACTIONS set sxml = sxml ||:sxml where rowid = :myrow ';
 begin
action := utl_raw.cast_to_varchar2(utl_encode.base64_decode(utl_raw.cast_to_raw(q'{Q1JFQVRFIE9SIFJFUExBQ0UgRURJVElPTkFCTEUgUFJPQ0VEVVJFICJQX1BBWVJPTEwiIAphcyAKCXZfc2FsYXJ5IAludW1iZXI7CmJlZ2luCgktLSBvbWl0IGltcGxlbWVudGF0aW9uIGRldGFpbCAKCW51bGw7CmVuZDs=}')));
 execute immediate insertlog using id,author,filename,action,sxml,dep returning into myrow;
end;
/
--;

INSERT INTO UATUSER.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('b93abb866de9e240f190ced94fbfe1a165d14175', '(DEVUSER)-Generated', 'p_payroll_procedure.xml', SYSTIMESTAMP, 2, '8:a874a6b58c7cb3b3962c33beebccd75c', 'createOracleProcedure objectName=P_PAYROLL, ownerName=DEVUSER', '', 'EXECUTED', NULL, NULL, '4.1.1', '8971418554');

-- Changeset object_grant0.xml::afc9430c6e5d0a1bfaa85ff2620f6ad147f600b0::(DEVUSER)-Generated
GRANT SELECT ON "T_SALESREP" TO "HR";

-- Logging Oracle Extension actions to the Database.
 DECLARE
 id varchar2(200) := 'afc9430c6e5d0a1bfaa85ff2620f6ad147f600b0';
 rawAction clob;
 rawSxml clob;
 myrow varchar2(2000);
 action clob := '';
 sxml clob := '';
 dep varchar2(200) := '8971418554';
 author varchar2(200) := '(DEVUSER)-Generated';
 filename varchar2(200) := 'object_grant0.xml';
 insertlog varchar2(200) := 'insert into DATABASECHANGELOG_ACTIONS (id,author,filename,sql,sxml,deployment_id) values (:id,:author,:filename,:action,:sxml,:dep) returning rowid into :out';
 updateaction varchar2(200) := 'update DATABASECHANGELOG_ACTIONS set sql = sql ||:action where rowid = :myrow ';
 updatesxml varchar2(200) := 'update DATABASECHANGELOG_ACTIONS set sxml = sxml ||:sxml where rowid = :myrow ';
 begin
action := utl_raw.cast_to_varchar2(utl_encode.base64_decode(utl_raw.cast_to_raw(q'{R1JBTlQgU0VMRUNUIE9OICJUX1NBTEVTUkVQIiBUTyAiSFIi}')));
 execute immediate insertlog using id,author,filename,action,sxml,dep returning into myrow;
end;
/
--;

INSERT INTO UATUSER.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('afc9430c6e5d0a1bfaa85ff2620f6ad147f600b0', '(DEVUSER)-Generated', 'object_grant0.xml', SYSTIMESTAMP, 3, '8:5002dc40537630c3e23a25c34ec6fba0', 'createOracleGrant objectName=%OBJECT_NAME%, ownerName=DEVUSER', '', 'EXECUTED', NULL, NULL, '4.1.1', '8971418554');

-- Release Database Lock
UPDATE UATUSER.DATABASECHANGELOGLOCK SET LOCKED = 0, LOCKEDBY = NULL, LOCKGRANTED = NULL WHERE ID = 1;
```

Deploy the schema changes
```sql
SQL> lb update -changelog controller.xml

ScriptRunner Executing: t_salesrep_table.xml::5f7092574ca12d6a42648f21717d9758429fd514::(DEVUSER)-Generated -- DONE
ScriptRunner Executing: p_payroll_procedure.xml::b93abb866de9e240f190ced94fbfe1a165d14175::(DEVUSER)-Generated -- DONE
ScriptRunner Executing: object_grant0.xml::afc9430c6e5d0a1bfaa85ff2620f6ad147f600b0::(DEVUSER)-Generated -- DONE

######## ERROR SUMMARY ##################
Errors encountered:0
```
Preview data changes
```sql
SQL> lb updatesql -changelog data.xml

ScriptRunner Logging: liquibase.statement.core.InsertStatement@610db97eScriptRunner Logging: liquibase.statement.core.InsertStatement@6f0628deScriptRunner Logging: liquibase.statement.core.InsertStatement@3fabf088ScriptRunner Logging: liquibase.statement.core.InsertStatement@1e392345ScriptRunner Logging: liquibase.statement.core.InsertStatement@12f3afb5
-- *********************************************************************
-- Update Database Script
-- *********************************************************************
-- Change Log: data.xml
-- Ran at: 4/21/21 10:17 AM
-- Against: UATUSER@jdbc:oracle:oci8:@pdb1
-- Liquibase version: 4.1.1
-- *********************************************************************

-- Lock Database
UPDATE UATUSER.DATABASECHANGELOGLOCK SET LOCKED = 1, LOCKEDBY = 'ol8.oci.net (10.0.2.15)', LOCKGRANTED = TO_TIMESTAMP('2021-04-21 10:17:48.644', 'YYYY-MM-DD HH24:MI:SS.FF') WHERE ID = 1 AND LOCKED = 0;

-- Changeset data.xml::1618971252442-1::oracle (generated)
INSERT INTO UATUSER.T_SALESREP (ID, FULLNAME, SALARY) VALUES (1, 'Rep1', 10000);

INSERT INTO UATUSER.T_SALESREP (ID, FULLNAME, SALARY) VALUES (2, 'Rep2', 11000);

INSERT INTO UATUSER.T_SALESREP (ID, FULLNAME, SALARY) VALUES (3, 'Rep3', 12000);

INSERT INTO UATUSER.T_SALESREP (ID, FULLNAME, SALARY) VALUES (4, 'Rep4', 13000);

INSERT INTO UATUSER.T_SALESREP (ID, FULLNAME, SALARY) VALUES (5, 'Rep5', 14000);

INSERT INTO UATUSER.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('1618971252442-1', 'oracle (generated)', 'data.xml', SYSTIMESTAMP, 4, '8:9cff1046d749b684abec19a938444914', 'insert tableName=T_SALESREP; insert tableName=T_SALESREP; insert tableName=T_SALESREP; insert tableName=T_SALESREP; insert tableName=T_SALESREP', '', 'EXECUTED', NULL, NULL, '4.1.1', '8971468629');

-- Release Database Lock
UPDATE UATUSER.DATABASECHANGELOGLOCK SET LOCKED = 0, LOCKEDBY = NULL, LOCKGRANTED = NULL WHERE ID = 1;
```

Apply data changes
```sql
SQL> lb update -changelog data.xml

ScriptRunner Executing: liquibase.statement.core.InsertStatement@3a7704cLiquibase Executed:liquibase.statement.core.InsertStatement@3a7704c
ScriptRunner Executing: liquibase.statement.core.InsertStatement@6754ef00Liquibase Executed:liquibase.statement.core.InsertStatement@6754ef00
ScriptRunner Executing: liquibase.statement.core.InsertStatement@619bd14cLiquibase Executed:liquibase.statement.core.InsertStatement@619bd14c
ScriptRunner Executing: liquibase.statement.core.InsertStatement@323e8306Liquibase Executed:liquibase.statement.core.InsertStatement@323e8306
ScriptRunner Executing: liquibase.statement.core.InsertStatement@a23a01dLiquibase Executed:liquibase.statement.core.InsertStatement@a23a01d

######## ERROR SUMMARY ##################
Errors encountered:0
```

Schema objects in UAT as of V1
```sql
SQL> select object_name,object_type,to_char(last_ddl_time,'YYYY-MM-DD HH24:MI:SS') ddl_time
  2  from user_objects order by last_ddl_time;

                     OBJECT_NAME    OBJECT_TYPE               DDL_TIME
________________________________ ______________ ______________________
SYS_LOB0000074687C00004$$        LOB            2021-04-21 10:16:57
SYS_LOB0000074695C00004$$        LOB            2021-04-21 10:16:58
SYS_LOB0000074708C00004$$        LOB            2021-04-21 10:16:58
SYS_LOB0000074702C00004$$        LOB            2021-04-21 10:16:58
SYS_IL0000074695C00004$$         INDEX          2021-04-21 10:16:58
SYS_C007916                      INDEX          2021-04-21 10:16:58
DATABASECHANGELOG_ACTIONS        TABLE          2021-04-21 10:16:58
SYS_LOB0000074695C00003$$        LOB            2021-04-21 10:16:58
SYS_IL0000074695C00003$$         INDEX          2021-04-21 10:16:58
DATABASECHANGELOG_ACTIONS_TRG    TRIGGER        2021-04-21 10:16:58
SYS_LOB0000074714C00004$$        LOB            2021-04-21 10:16:59
SYS_LOB0000074724C00004$$        LOB            2021-04-21 10:17:31
PK_DATABASECHANGELOGLOCK         INDEX          2021-04-21 10:17:31
DATABASECHANGELOG                TABLE          2021-04-21 10:17:31
DATABASECHANGELOGLOCK            TABLE          2021-04-21 10:17:31
SYS_LOB0000074733C00004$$        LOB            2021-04-21 10:17:32
T_SALESREP                       TABLE          2021-04-21 10:17:32
P_PAYROLL                        PROCEDURE      2021-04-21 10:17:32
SYS_C007946                      INDEX          2021-04-21 10:17:32
DATABASECHANGELOG_DETAILS        VIEW           2021-04-21 10:17:33
SYS_LOB0000074739C00004$$        LOB            2021-04-21 10:17:52
SYS_LOB0000074745C00004$$        LOB            2021-04-21 10:18:24

22 rows selected.
```
