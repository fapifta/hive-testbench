#!/bin/bash


function usage() {
	echo "Usage: tcpds-cleanup.sh scale_factor [temp_dir]"
	exit 1
}

function runcommand {
	if [ "X$DEBUG_SCRIPT" != "X" ]; then
		$1
	else
		$1 2>/dev/null
	fi  
}


if [ "X$1" = "X" ]
then
	usage
fi

if [ "X$2" != "X" ]
then
	DIR=$2
else
	DIR=/tmp/tpcds-generate
fi

SCALE=$1

if [ "X$FORMAT" = "X" ]; then
	FORMAT=orc
fi

if [ "X$DEBUG_SCRIPT" != "X" ]; then
	set -x
fi

if [ "X$FSSPEC" != "X" ]; then
	FSSPEC="_${FSSPEC}"
else
	FSSPEC="_hdfs"
fi

DIMS="date_dim time_dim item customer customer_demographics household_demographics customer_address store promotion warehouse ship_mode reason income_band call_center web_page catalog_page web_site"
FACTS="store_sales store_returns web_sales web_returns catalog_sales catalog_returns inventory"

HIVE="beeline -n hive -u 'jdbc:hive2://localhost:2181/;serviceDiscoveryMode=zooKeeper;zooKeeperNamespace=hiveserver2?tez.queue.name=default'"

for table in ${DIMS}
do
	echo "Dropping table ${table} from tpcds_bin_partitioned${FSSPEC}_${FORMAT}_${SCALE}"
	runcommand "$HIVE -f tpcds-cleanup/drop.sql --hivevar DB1=tpcds_bin_partitioned${FSSPEC}_${FORMAT}_${SCALE} --hivevar DB2=tpcds_text${FSSPEC}_${SCALE} --hivevar TABLE=${table}"
done

for table in ${FACTS}
do
	echo "Dropping table ${table} from tpcds_bin_partitioned${FSSPEC}_${FORMAT}_${SCALE}"
	runcommand "$HIVE -f tpcds-cleanup/drop.sql --hivevar DB1=tpcds_bin_partitioned${FSSPEC}_${FORMAT}_${SCALE} --hivevar DB2=tpcds_text${FSSPEC}_${SCALE} --hivevar TABLE=${table}"
done

echo "Dropping databases"
runcommand "$HIVE -f tpcds-cleanup/db_drop.sql --hivevar DB=tpcds_bin_partitioned${FSSPEC}_${FORMAT}_${SCALE}"
runcommand "$HIVE -f tpcds-cleanup/db_drop.sql --hivevar DB=tpcds_text${FSSPEC}_${SCALE}"

echo "Removing data folders from filesystem"
#hdfs dfs -rm -R -skipTrash o3fs://hive.warehouse.vc0101.halxg.cloudera.com:9862/tpcds_temp
#hdfs dfs -rm -R -skipTrash o3fs://hive.warehouse.vc0101.halxg.cloudera.com:9862/data
#hdfs dfs -mkdir o3fs://hive.warehouse.vc0101.halxg.cloudera.com:9862/tpcds_temp
#hdfs dfs -chown hive:hive o3fs://hive.warehouse.vc0101.halxg.cloudera.com:9862/tpcds_temp
#hdfs dfs -chmod 775 o3fs://hive.warehouse.vc0101.halxg.cloudera.com:9862/tpcds_temp
#hdfs dfs -mkdir o3fs://hive.warehouse.vc0101.halxg.cloudera.com:9862/data
#hdfs dfs -chown hive:hive o3fs://hive.warehouse.vc0101.halxg.cloudera.com:9862/data
#hdfs dfs -chmod 775 o3fs://hive.warehouse.vc0101.halxg.cloudera.com:9862/data

