### Simulate Changes in Dev

```sh
[oracle@ol8 v2]$ sql devuser/devuser@pdb1
```

```sql
SQL> @dev_setup_v2.sql
```
### Unload schema from Dev

```sql
SQL> lb genschema -grants
[Method loadCaptureTable]:                  Running
[Type - TYPE_SPEC]:                          232 ms
[Type - TYPE_BODY]:                           71 ms
[Type - SEQUENCE]:                            18 ms
[Type - DIRECTORY]:                           20 ms
[Type - CLUSTER]:                           1539 ms
[Type - TABLE]:                             9169 ms
[Type - MATERIALIZED_VIEW_LOG]:               37 ms
[Type - MATERIALIZED_VIEW]:                   18 ms
[Type - VIEW]:                              1010 ms
[Type - DIMENSION]:                           20 ms
[Type - FUNCTION]:                            42 ms
[Type - PROCEDURE]:                           72 ms
[Type - PACKAGE_SPEC]:                        39 ms
[Type - DB_LINK]:                             20 ms
[Type - SYNONYM]:                             27 ms
[Type - INDEX]:                              874 ms
[Type - TRIGGER]:                             64 ms
[Type - PACKAGE_BODY]:                        57 ms
[Type - JOB]:                                 29 ms
[Type - OBJECT_GRANT]:                        79 ms
[Method loadCaptureTable]:                 13438 ms
[Method parseCaptureTableRecords]:          1476 ms
[Method sortCaptureTable]:                    24 ms
[Method cleanupCaptureTable]:                  5 ms
[Method writeChangeLogs]:                     16 ms


Export Flags Used:

Export Grants           true
Export Synonyms         false
```

### Upgrade UAT from V1 to V2

```sh
[oracle@ol8 v2]$ sql uatuser/uatuser@pdb1
```

Preview the changes
```sql
SQL> lb updatesql -changelog controller.xml

ScriptRunner Logging: t_salesrep_table.xml::d432612f147b82ce2f5439f5cd874be79a7f0b4c::(DEVUSER)-Generated -- DONE
ScriptRunner Logging: p_payroll_procedure.xml::32744d1e42d4c81f89f8fcc4a3ce75ad58b8e82e::(DEVUSER)-Generated -- DONE

-- *********************************************************************
-- Update Database Script
-- *********************************************************************
-- Change Log: controller.xml
-- Ran at: 4/21/21 10:21 AM
-- Against: UATUSER@jdbc:oracle:oci8:@pdb1
-- Liquibase version: 4.1.1
-- *********************************************************************

-- Lock Database
UPDATE UATUSER.DATABASECHANGELOGLOCK SET LOCKED = 1, LOCKEDBY = 'ol8.oci.net (10.0.2.15)', LOCKGRANTED = TO_TIMESTAMP('2021-04-21 10:21:32.859', 'YYYY-MM-DD HH24:MI:SS.FF') WHERE ID = 1 AND LOCKED = 0;

-- Changeset t_salesrep_table.xml::d432612f147b82ce2f5439f5cd874be79a7f0b4c::(DEVUSER)-Generated
ALTER TABLE "T_SALESREP" ADD ("COMMISSION" NUMBER);

-- Logging Oracle Extension actions to the Database.
 DECLARE
 id varchar2(200) := 'd432612f147b82ce2f5439f5cd874be79a7f0b4c';
 rawAction clob;
 rawSxml clob;
 myrow varchar2(2000);
 action clob := '';
 sxml clob := '';
 dep varchar2(200) := '8971692813';
 author varchar2(200) := '(DEVUSER)-Generated';
 filename varchar2(200) := 't_salesrep_table.xml';
 insertlog varchar2(200) := 'insert into DATABASECHANGELOG_ACTIONS (id,author,filename,sql,sxml,deployment_id) values (:id,:author,:filename,:action,:sxml,:dep) returning rowid into :out';
 updateaction varchar2(200) := 'update DATABASECHANGELOG_ACTIONS set sql = sql ||:action where rowid = :myrow ';
 updatesxml varchar2(200) := 'update DATABASECHANGELOG_ACTIONS set sxml = sxml ||:sxml where rowid = :myrow ';
 begin
action := utl_raw.cast_to_varchar2(utl_encode.base64_decode(utl_raw.cast_to_raw(q'{QUxURVIgVEFCTEUgIlRfU0FMRVNSRVAiIEFERCAoIkNPTU1JU1NJT04iIE5VTUJFUikKLw==}')));
sxml := utl_raw.cast_to_varchar2(utl_encode.base64_decode(utl_raw.cast_to_raw(q'{PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+PFRBQkxFIHhtbG5zPSJodHRwOi8veG1sbnMub3JhY2xlLmNvbS9rdSIgdmVyc2lvbj0iMS4wIj4KICAgPFNDSEVNQT5VQVRVU0VSPC9TQ0hFTUE+CiAgIDxOQU1FPlRfU0FMRVNSRVA8L05BTUU+CiAgIDxSRUxBVElPTkFMX1RBQkxFPgogICAgICA8Q09MX0xJU1Q+CiAgICAgICAgIDxDT0xfTElTVF9JVEVNPgogICAgICAgICAgICA8TkFNRT5JRDwvTkFNRT4KICAgICAgICAgICAgPERBVEFUWVBFPk5VTUJFUjwvREFUQVRZUEU+CiAgICAgICAgIDwvQ09MX0xJU1RfSVRFTT4KICAgICAgICAgPENPTF9MSVNUX0lURU0+CiAgICAgICAgICAgIDxOQU1FPkZVTExOQU1FPC9OQU1FPgogICAgICAgICAgICA8REFUQVRZUEU+VkFSQ0hBUjI8L0RBVEFUWVBFPgogICAgICAgICAgICA8TEVOR1RIPjMwPC9MRU5HVEg+CiAgICAgICAgICAgIDxDT0xMQVRFX05BTUU+VVNJTkdfTkxTX0NPTVA8L0NPTExBVEVfTkFNRT4KICAgICAgICAgPC9DT0xfTElTVF9JVEVNPgogICAgICAgICA8Q09MX0xJU1RfSVRFTT4KICAgICAgICAgICAgPE5BTUU+U0FMQVJZPC9OQU1FPgogICAgICAgICAgICA8REFUQVRZUEU+TlVNQkVSPC9EQVRBVFlQRT4KICAgICAgICAgPC9DT0xfTElTVF9JVEVNPgogICAgICA8L0NPTF9MSVNUPgogICAgICA8UFJJTUFSWV9LRVlfQ09OU1RSQUlOVF9MSVNUPgogICAgICAgICA8UFJJTUFSWV9LRVlfQ09OU1RSQUlOVF9MSVNUX0lURU0+CiAgICAgICAgICAgIDxDT0xfTElTVD4KICAgICAgICAgICAgICAgPENPTF9MSVNUX0lURU0+CiAgICAgICAgICAgICAgICAgIDxOQU1FPklEPC9OQU1FPgogICAgICAgICAgICAgICA8L0NPTF9MSVNUX0lURU0+CiAgICAgICAgICAgIDwvQ09MX0xJU1Q+CiAgICAgICAgICAgIDxVU0lOR19JTkRFWD4KICAgICAgICAgICAgICAgPElOREVYX0FUVFJJQlVURVM+CiAgICAgICAgICAgICAgICAgIDxQQ1RGUkVFPjEwPC9QQ1RGUkVFPgogICAgICAgICAgICAgICAgICA8SU5JVFJBTlM+MjwvSU5JVFJBTlM+CiAgICAgICAgICAgICAgICAgIDxNQVhUUkFOUz4yNTU8L01BWFRSQU5TPgogICAgICAgICAgICAgICAgICA8U1RPUkFHRT4KICAgICAgICAgICAgICAgICAgICAgPElOSVRJQUw+NjU1MzY8L0lOSVRJQUw+CiAgICAgICAgICAgICAgICAgICAgIDxORVhUPjEwNDg1NzY8L05FWFQ+CiAgICAgICAgICAgICAgICAgICAgIDxNSU5FWFRFTlRTPjE8L01JTkVYVEVOVFM+CiAgICAgICAgICAgICAgICAgICAgIDxNQVhFWFRFTlRTPjIxNDc0ODM2NDU8L01BWEVYVEVOVFM+CiAgICAgICAgICAgICAgICAgICAgIDxQQ1RJTkNSRUFTRT4wPC9QQ1RJTkNSRUFTRT4KICAgICAgICAgICAgICAgICAgICAgPEZSRUVMSVNUUz4xPC9GUkVFTElTVFM+CiAgICAgICAgICAgICAgICAgICAgIDxGUkVFTElTVF9HUk9VUFM+MTwvRlJFRUxJU1RfR1JPVVBTPgogICAgICAgICAgICAgICAgICAgICA8QlVGRkVSX1BPT0w+REVGQVVMVDwvQlVGRkVSX1BPT0w+CiAgICAgICAgICAgICAgICAgICAgIDxGTEFTSF9DQUNIRT5ERUZBVUxUPC9GTEFTSF9DQUNIRT4KICAgICAgICAgICAgICAgICAgICAgPENFTExfRkxBU0hfQ0FDSEU+REVGQVVMVDwvQ0VMTF9GTEFTSF9DQUNIRT4KICAgICAgICAgICAgICAgICAgPC9TVE9SQUdFPgogICAgICAgICAgICAgICAgICA8VEFCTEVTUEFDRT5VU0VSUzwvVEFCTEVTUEFDRT4KICAgICAgICAgICAgICAgICAgPExPR0dJTkc+WTwvTE9HR0lORz4KICAgICAgICAgICAgICAgPC9JTkRFWF9BVFRSSUJVVEVTPgogICAgICAgICAgICA8L1VTSU5HX0lOREVYPgogICAgICAgICA8L1BSSU1BUllfS0VZX0NPTlNUUkFJTlRfTElTVF9JVEVNPgogICAgICA8L1BSSU1BUllfS0VZX0NPTlNUUkFJTlRfTElTVD4KICAgICAgPERFRkFVTFRfQ09MTEFUSU9OPlVTSU5HX05MU19DT01QPC9ERUZBVUxUX0NPTExBVElPTj4KICAgICAgPFBIWVNJQ0FMX1BST1BFUlRJRVM+CiAgICAgICAgIDxIRUFQX1RBQkxFPgogICAgICAgICAgICA8U0VHTUVOVF9BVFRSSUJVVEVTPgogICAgICAgICAgICAgICA8U0VHTUVOVF9DUkVBVElPTl9JTU1FRElBVEUvPgogICAgICAgICAgICAgICA8UENURlJFRT4xMDwvUENURlJFRT4KICAgICAgICAgICAgICAgPFBDVFVTRUQ+NDA8L1BDVFVTRUQ+CiAgICAgICAgICAgICAgIDxJTklUUkFOUz4xPC9JTklUUkFOUz4KICAgICAgICAgICAgICAgPE1BWFRSQU5TPjI1NTwvTUFYVFJBTlM+CiAgICAgICAgICAgICAgIDxTVE9SQUdFPgogICAgICAgICAgICAgICAgICA8SU5JVElBTD42NTUzNjwvSU5JVElBTD4KICAgICAgICAgICAgICAgICAgPE5FWFQ+MTA0ODU3NjwvTkVYVD4KICAgICAgICAgICAgICAgICAgPE1JTkVYVEVOVFM+MTwvTUlORVhURU5UUz4KICAgICAgICAgICAgICAgICAgPE1BWEVYVEVOVFM+MjE0NzQ4MzY0NTwvTUFYRVhURU5UUz4KICAgICAgICAgICAgICAgICAgPFBDVElOQ1JFQVNFPjA8L1BDVElOQ1JFQVNFPgogICAgICAgICAgICAgICAgICA8RlJFRUxJU1RTPjE8L0ZSRUVMSVNUUz4KICAgICAgICAgICAgICAgICAgPEZSRUVMSVNUX0dST1VQUz4xPC9GUkVFTElTVF9HUk9VUFM+CiAgICAgICAgICAgICAgICAgIDxCVUZGRVJfUE9PTD5ERUZBVUxUPC9CVUZGRVJfUE9PTD4KICAgICAgICAgICAgICAgICAgPEZMQVNIX0NBQ0hFPkRFRkFVTFQ8L0ZMQVNIX0NBQ0hFPgogICAgICAgICAgICAgICAgICA8Q0VMTF9GTEFTSF9DQUNIRT5ERUZBVUxUPC9DRUxMX0ZMQVNIX0NBQ0hFPgogICAgICAgICAgICAgICA8L1NUT1JBR0U+CiAgICAgICAgICAgICAgIDxUQUJMRVNQQUNFPlVTRVJTPC9UQUJMRVNQQUNFPgogICAgICAgICAgICAgICA8TE9HR0lORz5ZPC9MT0dHSU5HPgogICAgICAgICAgICA8L1NFR01FTlRfQVRUUklCVVRFUz4KICAgICAgICAgICAgPENPTVBSRVNTPk48L0NPTVBSRVNTPgogICAgICAgICA8L0hFQVBfVEFCTEU+CiAgICAgIDwvUEhZU0lDQUxfUFJPUEVSVElFUz4KICAgPC9SRUxBVElPTkFMX1RBQkxFPgo8L1RBQkxFPg==}')));
 execute immediate insertlog using id,author,filename,action,sxml,dep returning into myrow;
end;
/
--;

INSERT INTO UATUSER.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('d432612f147b82ce2f5439f5cd874be79a7f0b4c', '(DEVUSER)-Generated', 't_salesrep_table.xml', SYSTIMESTAMP, 5, '8:4a7660116a76cb2cb42a005dbd21f624', 'createSxmlObject objectName=T_SALESREP, ownerName=DEVUSER', '', 'EXECUTED', NULL, NULL, '4.1.1', '8971692813');

-- Changeset p_payroll_procedure.xml::32744d1e42d4c81f89f8fcc4a3ce75ad58b8e82e::(DEVUSER)-Generated
CREATE OR REPLACE EDITIONABLE PROCEDURE "P_PAYROLL"
as
        v_salary        number;
        v_commision     number;
begin
        -- omit implementation detail
        null;
end;

-- Logging Oracle Extension actions to the Database.
 DECLARE
 id varchar2(200) := '32744d1e42d4c81f89f8fcc4a3ce75ad58b8e82e';
 rawAction clob;
 rawSxml clob;
 myrow varchar2(2000);
 action clob := '';
 sxml clob := '';
 dep varchar2(200) := '8971692813';
 author varchar2(200) := '(DEVUSER)-Generated';
 filename varchar2(200) := 'p_payroll_procedure.xml';
 insertlog varchar2(200) := 'insert into DATABASECHANGELOG_ACTIONS (id,author,filename,sql,sxml,deployment_id) values (:id,:author,:filename,:action,:sxml,:dep) returning rowid into :out';
 updateaction varchar2(200) := 'update DATABASECHANGELOG_ACTIONS set sql = sql ||:action where rowid = :myrow ';
 updatesxml varchar2(200) := 'update DATABASECHANGELOG_ACTIONS set sxml = sxml ||:sxml where rowid = :myrow ';
 begin
action := utl_raw.cast_to_varchar2(utl_encode.base64_decode(utl_raw.cast_to_raw(q'{Q1JFQVRFIE9SIFJFUExBQ0UgRURJVElPTkFCTEUgUFJPQ0VEVVJFICJQX1BBWVJPTEwiIAphcyAKCXZfc2FsYXJ5IAludW1iZXI7Cgl2X2NvbW1pc2lvbgludW1iZXI7CmJlZ2luCgktLSBvbWl0IGltcGxlbWVudGF0aW9uIGRldGFpbCAKCW51bGw7CmVuZDs=}')));
sxml := utl_raw.cast_to_varchar2(utl_encode.base64_decode(utl_raw.cast_to_raw(q'{Q1JFQVRFIE9SIFJFUExBQ0UgRURJVElPTkFCTEUgUFJPQ0VEVVJFICJVQVRVU0VSIi4iUF9QQVlST0xMIiAKYXMgCgl2X3NhbGFyeSAJbnVtYmVyOwpiZWdpbgoJLS0gb21pdCBpbXBsZW1lbnRhdGlvbiBkZXRhaWwgCgludWxsOwplbmQ7}')));
 execute immediate insertlog using id,author,filename,action,sxml,dep returning into myrow;
end;
/
--;

INSERT INTO UATUSER.DATABASECHANGELOG (ID, AUTHOR, FILENAME, DATEEXECUTED, ORDEREXECUTED, MD5SUM, DESCRIPTION, COMMENTS, EXECTYPE, CONTEXTS, LABELS, LIQUIBASE, DEPLOYMENT_ID) VALUES ('32744d1e42d4c81f89f8fcc4a3ce75ad58b8e82e', '(DEVUSER)-Generated', 'p_payroll_procedure.xml', SYSTIMESTAMP, 6, '8:6d688867850d752af6659cb885b3413e', 'createOracleProcedure objectName=P_PAYROLL, ownerName=DEVUSER', '', 'EXECUTED', NULL, NULL, '4.1.1', '8971692813');

-- Release Database Lock
UPDATE UATUSER.DATABASECHANGELOGLOCK SET LOCKED = 0, LOCKEDBY = NULL, LOCKGRANTED = NULL WHERE ID = 1;
```

Deployment the changes
```sql
SQL> lb update -changelog controller.xml

ScriptRunner Executing: t_salesrep_table.xml::d432612f147b82ce2f5439f5cd874be79a7f0b4c::(DEVUSER)-Generated -- DONE
ScriptRunner Executing: p_payroll_procedure.xml::32744d1e42d4c81f89f8fcc4a3ce75ad58b8e82e::(DEVUSER)-Generated -- DONE

######## ERROR SUMMARY ##################
Errors encountered:0
```

## Rollback
Assume bad happened and Rollback is a must, although Fix+Forward is another way to address the issue

Preview the rollback changes (count = 2, means Procedure change + alter table change, counted together as 2 changes)
```sql
SQL> lb rollbacksql -changelog controller.xml -count 2

ScriptRunner Logging: p_payroll_procedure.xml::32744d1e42d4c81f89f8fcc4a3ce75ad58b8e82e::(DEVUSER)-Generated -- DONE
ScriptRunner Logging: t_salesrep_table.xml::d432612f147b82ce2f5439f5cd874be79a7f0b4c::(DEVUSER)-Generated -- DONE

######## ERROR SUMMARY ##################
Errors encountered:0

-- *********************************************************************
-- Rollback 2 Change(s) Script
-- *********************************************************************
-- Change Log: controller.xml
-- Ran at: 4/21/21 10:25 AM
-- Against: UATUSER@jdbc:oracle:oci8:@pdb1
-- Liquibase version: 4.1.1
-- *********************************************************************

-- Rolling Back ChangeSet: p_payroll_procedure.xml::32744d1e42d4c81f89f8fcc4a3ce75ad58b8e82e::(DEVUSER)-Generated
CREATE OR REPLACE EDITIONABLE PROCEDURE "P_PAYROLL"
as
        v_salary        number;
begin
        -- omit implementation detail
        null;
end;

delete from DATABASECHANGELOG_actions where id = '32744d1e42d4c81f89f8fcc4a3ce75ad58b8e82e' and filename = 'p_payroll_procedure.xml' and author ='(DEVUSER)-Generated' and sequence = (select Max(sequence) from DATABASECHANGELOG_actions where id = '32744d1e42d4c81f89f8fcc4a3ce75ad58b8e82e' and filename = 'p_payroll_procedure.xml' and author ='(DEVUSER)-Generated');

-- Rolling Back ChangeSet: t_salesrep_table.xml::d432612f147b82ce2f5439f5cd874be79a7f0b4c::(DEVUSER)-Generated
ALTER TABLE "T_SALESREP" DROP ("COMMISSION");

delete from DATABASECHANGELOG_actions where id = 'd432612f147b82ce2f5439f5cd874be79a7f0b4c' and filename = 't_salesrep_table.xml' and author ='(DEVUSER)-Generated' and sequence = (select Max(sequence) from DATABASECHANGELOG_actions where id = 'd432612f147b82ce2f5439f5cd874be79a7f0b4c' and filename = 't_salesrep_table.xml' and author ='(DEVUSER)-Generated');
```

Perform actually rollback
```sql
SQL> lb rollback -changelog controller.xml -count 2

Rolling Back Changeset:object_grant0.xml::afc9430c6e5d0a1bfaa85ff2620f6ad147f600b0::(DEVUSER)-Generated

######## ERROR SUMMARY ##################
Errors encountered:0
```




