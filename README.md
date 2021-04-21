## Oracle Database CI/CD Pipelines with SQLCL/Liquibase

### How to prepare the envronment
```sql
-- set up
 drop user devuser cascade;
 drop user uatuser cascade;

create user devuser identified by devuser;
alter user devuser quota unlimited on users;
grant dba to devuser;

create user uatuser identified by uatuser;
alter user uatuser quota unlimited on users;
grant dba to uatuser;	
```

### Deployment Flow
![alt text](https://github.com/luodonghua/db_cicd_pipelines/blob/main/deployment%20flow.png?raw=true "Deployment Flow")

### Automation and Integration
We can put following lines into a shell script and integrate with Jenkins.

```sh
cd /u01/db_cicd_pipelines/v3
sql uatuser/uatuser@pdb1 <<EOD
lb update -changelog controller.xml
EOD
```

### Verified Envronment

* Oracle DB: 19.10.0.0.0
* SQLcl: Release 20.4

```sql
SQL> lb version
Liquibase version:   4.1.1
Extension Version:   20.4.2.0
```
