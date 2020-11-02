create database if not exists ${DB} managedlocation "${DBLOCATION}";
use ${DB};

drop table if exists promotion;

create table promotion
stored as ${FILE}
as select * from ${SOURCE}.promotion;
