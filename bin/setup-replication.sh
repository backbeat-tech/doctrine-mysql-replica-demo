while ! mysqladmin ping -h primary -p$PRIMARY_PASSWORD --silent; do echo 'waiting for primary...' && sleep 1; done
while ! mysqladmin ping -h replica -p$REPLICA_PASSWORD --silent; do echo 'waiting for replica...' && sleep 1; done

mysql -h replica -u root -p$REPLICA_PASSWORD -AN -e 'stop slave; reset slave all';

LOG_POSITION=$(eval "mysql -h primary -u root -p$PRIMARY_PASSWORD -e 'show master status \G' | grep Position | sed -n -e 's/^.*: //p'")
LOG_FILE=$(eval "mysql -h primary -u root -p$PRIMARY_PASSWORD -e 'show master status \G'     | grep File     | sed -n -e 's/^.*: //p'")

mysql -h primary -u root -p$PRIMARY_PASSWORD -AN -D app -e "show tables"

mysql -h replica -u root -p$REPLICA_PASSWORD -AN -e "CHANGE MASTER TO master_host='primary', master_port=3306, \
        master_user='root', master_password='$PRIMARY_PASSWORD', master_log_file='$LOG_FILE', \
        master_log_pos=$LOG_POSITION;"

mysql -h replica -u root -p$REPLICA_PASSWORD -AN -e "start slave;"

mysql -h replica -u root -p$REPLICA_PASSWORD -e "show slave status \G"
