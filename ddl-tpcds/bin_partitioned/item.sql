create database if not exists ${DB} managedlocation "${DBLOCATION}";
use ${DB};

drop table if exists item;

create table item
stored as ${FILE}
as select * from ${SOURCE}.item
CLUSTER BY i_item_sk
;
