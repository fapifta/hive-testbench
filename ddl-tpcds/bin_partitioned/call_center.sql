create database if not exists ${DB} LOCATION "${DBLOCATION}";
use ${DB};

drop table if exists call_center;

create table call_center
stored as ${FILE}
as select * from ${SOURCE}.call_center;
