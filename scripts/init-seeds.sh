
#!/bin/bash

masterimg="medline-ghost-demo-mysql-master-1"
slaveimg="medline-ghost-demo-mysql-slave-1"

docker exec -it $masterimg  mysql -uroot -prootpassword mydb -e "source /etc/mysql/user-create-and-seed.sql" -v --show-warnings