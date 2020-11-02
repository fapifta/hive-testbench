create database if not exists ${DB} managedlocation "${DBLOCATION}";
use ${DB};

drop table if exists warehouse;

create table warehouse
stored as ${FILE}
as select * from ${SOURCE}.warehouse;
