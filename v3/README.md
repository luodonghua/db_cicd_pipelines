### Identify the issue and fix in Dev 
Assume the issue for V2 was caused by missing commission data, script "populate_commission_data.sql" prepared to fixed this in Dev

```sql
SQL> @populate_commission_data.sql
```
### Update from V1 to V3 in UAT

Re-run the schema changes generated as V2
```sql
SQL> lb update -changelog controller.xml

ScriptRunner Executing: t_salesrep_table.xml::d432612f147b82ce2f5439f5cd874be79a7f0b4c::(DEVUSER)-Generated -- DONE
ScriptRunner Executing: p_payroll_procedure.xml::32744d1e42d4c81f89f8fcc4a3ce75ad58b8e82e::(DEVUSER)-Generated -- DONE
ScriptRunner Executing: object_grant0.xml::afc9430c6e5d0a1bfaa85ff2620f6ad147f600b0::(DEVUSER)-Generated -- DONE

######## ERROR SUMMARY ##################
Errors encountered:0
```

Use lb to run the script as well, detail refer to populate_commission_data.xml

Preview
```sql
SQL> lb updatesql -changelog populate_commission_data.xml

ScriptRunner Logging: populate_commission_data.xml::RunScriptFilePopulate_T_SALESREP_COMM::Donghua -- DONE

-- *********************************************************************
-- Update Database Script
-- *********************************************************************
-- Change Log: populate_commission_data.xml
-- Ran at: 4/21/21 10:43 AM
-- Against: UATUSER@jdbc:oracle:oci8:@pdb1
-- Liquibase version: 4.1.1
-- *********************************************************************

-- Lock Database
UPDATE UATUSER.DATABASECHANGELOGLOCK SET LOCKED = 1, LOCKEDBY = 'ol8.oci.net (10.0.2.15)', LOCKGRANTED = TO_TIMESTAMP('2021-04-21 10:43:32.307', 'YYYY-MM-DD HH24:MI:SS.FF') WHERE ID = 1 AND LOCKED = 0;

-- Changeset populate_commission_data.xml::RunScriptFilePopulate_T_SALESREP_COMM::Donghua
-- populate commission data
update t_salesrep set commission=0.1;
commit;

-- Logging Oracle Extension actions to the Database.
 DECLARE
 id varchar2(200) := 'RunScriptFilePopulate_T_SALESREP_COMM';
 rawAction clob;
 rawSxml clob;
 myrow varchar2(2000);
 action clob := '';
 sxml clob := '';
 dep varchar2(200) := '8973012296';
 author varchar2(200) := 'Donghua';
 filename varchar2(200) := 'populate_commission_data.xml';
 insertlog varchar2(200) := 'insert into DATABASECHANGELOG_ACTIONS (id,author,filename,sql,sxml,deployment_id) values (:id,:author,:filename,:action,:sxml,:dep) returning rowid into :out';
 updateaction varchar2(200) := 'update DATABASECHANGELOG_ACTIONS set sql = sql ||:action where rowid = :myrow ';
 updatesxml varchar2(200) := 'update DATABASECHANGELOG_ACTIONS set sxml = sxml ||:sxml where rowid = :myrow ';
 begin
action := utl_raw.cast_to_varchar2(utl_encode.base64_decode(utl_raw.cast_to_raw(q'{LS0gcG9wdWxhdGUgY29tbWlzc2lvbiBkYXRhCnVwZGF0ZSB0X3NhbGVzcmVwIHNldCBjb21taXNzaW9uPTAuMTsKY29tbWl0Ow==}')));
 execute immediate insertlog using id,author,filename,action,sxml,dep returning into myrow;
end;
/
--;

INSERT INTO UATUSER.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('RunScriptFilePopulate_T_SALESREP_COMM', 'Donghua', 'populate_commission_data.xml', SYSTIMESTAMP, 8, '8:a6c8540428de02a14ec31b6257b140fc', 'runOracleScript objectName=populate_commission_data, ownerName=Donghua', '', 'EXECUTED', NULL, NULL, '4.1.1', '8973012296');

-- Release Database Lock
UPDATE UATUSER.DATABASECHANGELOGLOCK SET LOCKED = 0, LOCKEDBY = NULL, LOCKGRANTED = NULL WHERE ID = 1;
```
Actual run (Rollback is not supported for sql script)
```sql
SQL> lb update -changelog populate_commission_data.xml

ScriptRunner Executing: populate_commission_data.xml::RunScriptFilePopulate_T_SALESREP_COMM::Donghua -- DONE

######## ERROR SUMMARY ##################
Errors encountered:0
```
