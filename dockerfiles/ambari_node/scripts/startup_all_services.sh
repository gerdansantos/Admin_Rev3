su -l hdfs -c "/usr/lib/hadoop/sbin/hadoop-daemon.sh start namenode"
ssh node2 "su -l hdfs -c '/usr/lib/hadoop/sbin/hadoop-daemon.sh start secondarynamenode'"
su -l hdfs -c "/usr/lib/hadoop/sbin/hadoop-daemon.sh start datanode"
ssh node2 "su -l hdfs -c '/usr/lib/hadoop/sbin/hadoop-daemon.sh start datanode'"
ssh node3 "su -l hdfs -c '/usr/lib/hadoop/sbin/hadoop-daemon.sh start datanode'"

ssh node2 "su - yarn -c  'export HADOOP_LIBEXEC_DIR=/usr/lib/hadoop/libexec && /usr/lib/hadoop-yarn/sbin/yarn-daemon.sh --config /etc/hadoop/conf start resourcemanager'"
ssh node2 "su - mapred -c  'export HADOOP_LIBEXEC_DIR=/usr/lib/hadoop/libexec && /usr/lib/hadoop-mapreduce/sbin/mr-jobhistory-daemon.sh --config /etc/hadoop/conf start historyserver'"
su - yarn -c  'export HADOOP_LIBEXEC_DIR=/usr/lib/hadoop/libexec && /usr/lib/hadoop-yarn/sbin/yarn-daemon.sh --config /etc/hadoop/conf start nodemanager'
ssh node2 "su - yarn -c  'export HADOOP_LIBEXEC_DIR=/usr/lib/hadoop/libexec && /usr/lib/hadoop-yarn/sbin/yarn-daemon.sh --config /etc/hadoop/conf start nodemanager'"
ssh node3 "su - yarn -c  'export HADOOP_LIBEXEC_DIR=/usr/lib/hadoop/libexec && /usr/lib/hadoop-yarn/sbin/yarn-daemon.sh --config /etc/hadoop/conf start nodemanager'"

/usr/lib/zookeeper/bin/zkServer.sh start
ssh node2 "/usr/lib/zookeeper/bin/zkServer.sh start"
ssh node3 "/usr/lib/zookeeper/bin/zkServer.sh start"

ssh node3 "su -l hbase -c '/usr/lib/hbase/bin/hbase-daemon.sh start master'"
su -l hbase -c "/usr/lib/hbase/bin/hbase-daemon.sh start regionserver"
ssh node2 "su -l hbase -c '/usr/lib/hbase/bin/hbase-daemon.sh start regionserver'"
ssh node3 "su -l hbase -c '/usr/lib/hbase/bin/hbase-daemon.sh start regionserver'"

ssh node2 "su - hive -c  'env HADOOP_HOME=/usr JAVA_HOME=/usr/jdk64/jdk1.6.0_31 /tmp/startMetastore.sh /var/log/hive/hive.out /var/log/hive/hive.log /var/run/hive/hive.pid /etc/hive/conf.server'"
ssh node2 "su - hive -c  'env JAVA_HOME=/usr/jdk64/jdk1.6.0_31 /tmp/startHiveserver2.sh /var/log/hive/hive-server2.out  /var/log/hive/hive-server2.log /var/run/hive/hive-server.pid /etc/hive/conf.server'"
ssh node2 "su -l hcat -c '/usr/lib/hcatalog/sbin/webhcat_server.sh start'"
ssh node2 "su -l oozie -c '/usr/lib/oozie/bin/oozied.sh start'"

ssh node3 service hdp-gmetad start
service hdp-gmond start
ssh node2 service hdp-gmond start
ssh node3 service hdp-gmond start
ssh node4 service hdp-gmond start

ssh node3 service nagios start
