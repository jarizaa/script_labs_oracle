#!/bin/bash
echo "---------------------------------------"
echo Modificacion 12.1 a 19.3
echo "-----------------------------------------"
 
cd /home/oracle/labs 
find . -name "*.sql" >> pp_labs 
sed -i -r "s%/12.1.0/%/19.3.0/%g" `cat pp_labs` 
rm -f pp_labs 

echo "---------------------------------------"
echo Modificacion Application_Tracing TRCESERV
echo "---------------------------------------"

cd /home/oracle/labs/solutions/Application_Tracing
find . -name "*.sql" >> pp
sed -i -r "s%connect trace/trace%connect trace/trace@TRACESERV --%g" `cat pp`
sed -i -r "s%--@TRACESERV% %g" `cat pp`
rm -f pp


echo "---------------------------------------"
echo Modificacion Explain_Plan fichero ep_not_exists.sql
echo "---------------------------------------"

echo 'SELECT last_name, job_id, salary, department_name
FROM employees, departments
WHERE departments.department_id = employees.department_id
and not exists
(select * from jobs where employees.salary between min_salary
and max_salary); ' > /home/oracle/labs/solutions/Explain_Plan/ep_not_exists.sql

echo "---------------------------------------"
echo Creacion de directorios Demo/ y sh/
echo "---------------------------------------"

mkdir -p  /u01/app/oracle/product/19.3.0/dbhome_1/demo/schema/sales_history
mkdir -p  /home/oracle/labs/solutions/SQL_Access_Advisor/sh

echo "---------------------------------------"
echo Creacion de Tablespace example en orclpdb
echo "---------------------------------------"

create tablespace example datafile '/u01/app/oracle/oradata/ORCL/orclpdb/example1.dbf' size 1024m extent management local uniform size 10m;

echo "---------------------------------------"
echo Modificacion Access_Paths/ap_cleanup.sql
echo "---------------------------------------"

echo  '
set echo on
@sh_main sh example temp oracle_4U /u01/app/oracle/product/19.3.0/dbhome_1/demo/schema/sales_history/ /home/oracle/ v3 2>/dev/null
exit; ' > /home/oracle/labs/solutions/Access_Paths/ap_cleanup.sql

echo "---------------------------------------"
echo Modificacion Access_Paths/ap_cleanup.sh
echo "---------------------------------------"

echo '
#!/bin/bash

cd /home/oracle/labs/solutions/SQL_Access_Advisor/sh

cp * $ORACLE_HOME/demo/schema/sales_history

sed -i "s%CONNECT sys/\&pass_sys AS SYSDBA%CONNECT sys/\&pass_sys@orclpdb AS SYSDBA%g" sh_main.sql

find /u01/app/oracle/product/19.3.0/dbhome_1/demo/schema/sales_history -name "*.sql" >> pp

sed -i -r "s%CONNECT sh/\&pass%CONNECT sh/\&pass@orclpdb%g" `cat pp`
sed -i -r "s%CONNECT sh/\&pass@orclpdb@orclpdb%CONNECT sh/\&pass@orclpdb%g" `cat pp`
sed -i -r "s%sh/\&sh_pass%sh/\&sh_pass@orclpdb%g" `cat pp`
#rm -f pp

sqlplus sys/oracle_4U@orclpdb as sysdba @/home/oracle/labs/solutions/Access_Paths/ap_cleanup.sql' > /home/oracle/labs/solutions/Access_Paths/ap_cleanup.sh

echo "---------------------------------------"
echo Modificacion Automatic_Gather_Stats/ags_cleanup.sh
echo "---------------------------------------"

echo '
#!/bin/bash

cd /home/oracle/labs/solutions/Automatic_Gather_Stats

sqlplus sys/oracle_4U as sysdba @ags_cleanup.sql
' > /home/oracle/labs/solutions/Automatic_Gather_Stats/ags_cleanup.sh

echo "---------------------------------------"
echo Modificacion sys/oracle@orclpdb -- jfv/jfv@orclpdb -- 
echo "---------------------------------------"

find /home/oracle/labs/solutions/System_Stats -name "*.sql" >> pp
sed -i -r "s%connect / as sysdba%connect sys/oracle_4U@orclpdb as sysdba%g" `cat pp`
sed -i -r "s%connect jfv/jfv%connect jfv/jfv@orclpdb%g" `cat pp`
sed -i -r "s%connect jfv/jfv@orclpdb@orclpdb%connect jfv/jfv@orclpdb%g" `cat pp`
rm -f pp

echo "---------------------------------------"
echo Modificacion cs/cs@orclpdb
echo "---------------------------------------"

find /home/oracle/labs/solutions/Cursor_Sharing -name "*.sql" >> pp
sed -i -r "s%connect cs/cs%connect cs/cs@orclpdb%g" `cat pp`
sed -i -r "s%connect cs/cs@orclpdb@orclpdb%connect cs/cs@orclpdb%g" `cat pp`
rm -f pp

clear
echo "---------------------------------------"
echo FINALIZADO
echo "---------------------------------------"

