#!/bin/sh
#TITLE:SCMSDB_check.sh
DBUSER="root"
DBPASS="PASSWORD"
MYSQL="/usr/local/mysql/bin"
IPADDR="IPADDR"
RESULT="tmp.$$"

##################### set html #####################
echo "<html>"
echo "<head></head>"
echo "<body>"
echo "<br>"
echo " Slave01 상태 모니터링"
echo "<table border='1' width='100%;'>"
#echo "<table border='1' width='800px;'>"
echo "<tbody>"
##################### set html #####################

##################### set table #####################
echo "<tr style='background: deepskyblue;'>"
echo "<th width='170px;'>날짜</th>"
echo "<th width='170px;'>DB 서버명</th>"
echo "<th width='170px;'>Replication 상태</th>"
echo "<th width='170px;'>Slave_IO_Running</th>"
echo "<th width='170px;'>Slave_SQL_Running</th>"
echo "<th>Last_IO_Error</th>"
echo "<th>Last_SQL_Error</th>"
echo "</tr>"
##################### end table #####################

#for IPADDR in 10.10.10.{12..15}
#do
mysql -h "${IPADDR}" -u "${DBUSER}" -p"${DBPASS}" -e "SHOW SLAVE STATUS \G" > $RESULT

Slave_IO_Running=$(awk '/Slave_IO_Running:/ {print $2}' "$RESULT")
Slave_SQL_Running=$(awk '/Slave_SQL_Running:/ {print $2}' "$RESULT")
Last_IO_Error=$(awk '/Last_IO_Error:/ {print $2}' "$RESULT")
Last_SQL_Error=$(awk '/Last_SQL_Error:/ {print $2}' "$RESULT")

date_str=$(date '+%Y/%m/%d %H:%M:%S')

##################### loop start #####################



if [ "$Slave_IO_Running" = "Yes" -a "$Slave_SQL_Running" = "Yes" ]; then
        echo "<tr style='background: white; text-align: center;'>"
                echo "<td> $date_str </td>"
                echo "<td> $IPADDR </td>"
                echo "<td style='background-color: mediumaquamarine;'> STATUS OK </td>"
                echo "<td> $Slave_IO_Running </td>"
                echo "<td> $Slave_SQL_Running </td>"
                echo "<td> $Last_IO_Error </td>"
                echo "<td> $Last_SQL_Error </td>"
        echo "</tr>"

else

        echo "<tr style='background: crimson; text-align: center;' >"
                echo "<td> $date_str </td>"
                echo "<td> $IPADDR </td>"
                echo "<td style='background-color: crimson;'> STATUS Failed!!!! </td>"
                echo "<td> $Slave_IO_Running </td>"
                echo "<td> $Slave_SQL_Running </td>"
                echo "<td> $Last_IO_Error </td>"
                echo "<td> $Last_SQL_Error </td>"
        echo "</tr>"
echo "http://10.10.10.10/db_check.html" | mail -s "$IPADDR DB 서버의 Replication이 실패했습니다. 긴급 점검하세요." abc@abc.co.kr

fi

##################### loop end #####################
#done

##################### end html #####################
echo "</tbody>"
echo "</table>"
echo "</body>"
echo "</html>"
##################### end html #####################
rm -f "$RESULT"
