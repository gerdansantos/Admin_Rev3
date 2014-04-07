ssh node3 service nagios stop
ssh node3 service hdp-gmetad stop
ssh node3 service hdp-gmond stop
service hdp-gmond stop
ssh node2 service hdp-gmond stop
ssh node4 service hdp-gmond stop

ssh node2 "su -l oozie -c '/usr/lib/oozie/bin/oozied.sh stop'"
ssh node2 "su -l hcat -c '/usr/lib/hcatalog/sbin/webhcat_server.sh stop'"
ssh node2 "ps aux | awk '{print \$1,\$2}' | grep hive | awk '{print \$2}' | xargs kill >/dev/null 2>&1"

/usr/lib/zookeeper/bin/zkServer.sh stop
ssh node2 "/usr/lib/zookeeper/bin/zkServer.sh stop"
ssh node3 "/usr/lib/zookeeper/bin/zkServer.sh stop"

su -l hbase -c "/usr/lib/hbase/bin/hbase-daemon.sh stop regionserver"
ssh node2 "su -l hbase -c '/usr/lib/hbase/bin/hbase-daemon.sh stop regionserver'"

ssh node3 "su -l hbase -c '/usr/lib/hbase/bin/hbase-daemon.sh stop regionserver'"
ssh node3 "su -l hbase -c '/usr/lib/hbase/bin/hbase-daemon.sh stop master'"

su - yarn -c  'export HADOOP_LIBEXEC_DIR=/usr/lib/hadoop/libexec && /usr/lib/hadoop-yarn/sbin/yarn-daemon.sh --config /etc/hadoop/conf stop nodemanager'
ssh node2 "su - yarn -c  'export HADOOP_LIBEXEC_DIR=/usr/lib/hadoop/libexec && /usr/lib/hadoop-yarn/sbin/yarn-daemon.sh --config /etc/hadoop/conf stop nodemanager'"
ssh node3 "su - yarn -c  'export HADOOP_LIBEXEC_DIR=/usr/lib/hadoop/libexec && /usr/lib/hadoop-yarn/sbin/yarn-daemon.sh --config /etc/hadoop/conf stop nodemanager'"
ssh node2 "su - mapred -c  'export HADOOP_LIBEXEC_DIR=/usr/lib/hadoop/libexec && /usr/lib/hadoop-mapreduce/sbin/mr-jobhistory-daemon.sh --config /etc/hadoop/conf stop historyserver'"
ssh node2 "su - yarn -c  'export HADOOP_LIBEXEC_DIR=/usr/lib/hadoop/libexec && /usr/lib/hadoop-yarn/sbin/yarn-daemon.sh --config /etc/hadoop/conf stop resourcemanager'"

su -l hdfs -c "/usr/lib/hadoop/sbin/hadoop-daemon.sh stop datanode"
ssh node2 "su -l hdfs -c '/usr/lib/hadoop/sbin/hadoop-daemon.sh stop datanode'"
ssh node3 "su -l hdfs -c '/usr/lib/hadoop/sbin/hadoop-daemon.sh stop datanode'"
ssh node2 "su -l hdfs -c '/usr/lib/hadoop/sbin/hadoop-daemon.sh stop secondarynamenode'"
su -l hdfs -c "/usr/lib/hadoop/sbin/hadoop-daemon.sh stop namenode"
