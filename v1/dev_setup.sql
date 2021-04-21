create table t_salesrep (
	id 			number primary key,
	fullname	varchar2(30),
	salary 		number);

grant select on t_salesrep to hr;

create or replace procedure p_payroll
as 
	v_salary 	number;
begin
	-- omit implementation detail 
	null;
end;
/
