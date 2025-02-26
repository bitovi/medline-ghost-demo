#!/bin/bash

masterimg="medline-ghost-demo-mysql-master-1"
slaveimg="medline-ghost-demo-mysql-slave-1"

# 1. add replication user on master
docker exec -it $masterimg  mysql -uroot -prootpassword -e "CREATE USER 'replicator'@'%' IDENTIFIED BY 'replicatorpassword'; GRANT REPLICATION SLAVE ON *.* TO 'replicator'@'%';" 2>&1>/dev/null

# 2. get File and Position values from master
masterfile=$(docker exec -it $masterimg mysql -uroot -prootpassword -e "SHOW MASTER STATUS\G" | awk '/File/ {print $2}' | tr -d '\n' | tr -d '\r')

masterposition=$(docker exec -it $masterimg mysql -uroot -prootpassword -e "SHOW MASTER STATUS\G" | awk '/Position/ {print $2}' | tr -d '\n' | tr -d '\r')


configcommand=$(echo "CHANGE MASTER TO MASTER_HOST='$masterimg', MASTER_USER='replicator', MASTER_PASSWORD='replicatorpassword', MASTER_LOG_FILE='$masterfile', MASTER_LOG_POS=$masterposition, GET_MASTER_PUBLIC_KEY=1;")


# 3. configure slave for replication, with user from 1.
docker exec -it $slaveimg mysql -uroot -prootpassword -e "$configcommand" 2>&1>/dev/null

# 4. start the slave
docker exec -it $slaveimg mysql -uroot -prootpassword -e "START SLAVE;" 2>&1>/dev/null

# 5. print slave replication status
docker exec -it $slaveimg mysql -uroot -prootpassword -e "SHOW SLAVE STATUS\G" | awk '/Slave_/ {print}'

