#!/bin/bash

masterimg="medline-ghost-demo-mysql-master-1"
slaveimg="medline-ghost-demo-mysql-slave-1"

# docker exec -it $masterimg  mysql -uroot -prootpassword -e "CREATE USER 'replicator'@'%' IDENTIFIED BY 'replicatorpassword'; GRANT REPLICATION SLAVE ON *.* TO 'replicator'@'%';"

# docker exec -it $masterimg mysql -uroot -prootpassword -e "SHOW MASTER STATUS\G"

masterfile=$(docker exec -it $masterimg mysql -uroot -prootpassword -e "SHOW MASTER STATUS\G" | awk '/File/ {print $2}')

masterposition=$(docker exec -it $masterimg mysql -uroot -prootpassword -e "SHOW MASTER STATUS\G" | awk '/Position/ {print $2}')

docker exec -it $slaveimg mysql -uroot -prootpassword -e "CHANGE MASTER TO MASTER_HOST='$masterimg', MASTER_USER='replicator', MASTER_PASSWORD='replicatorpassword', MASTER_LOG_FILE='$masterfile', MASTER_LOG_POS=$masterposition;" 2>&1>/dev/null

docker exec -it $slaveimg mysql -uroot -prootpassword -e "START SLAVE;" 2>&1>/dev/null

docker exec -it $slaveimg mysql -uroot -prootpassword -e "SHOW SLAVE STATUS\G" | awk '/Slave_/ {print}'

