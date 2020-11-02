create database if not exists ${DB} managedlocation "${DBLOCATION}";
use ${DB};

drop table if exists reason;

create table reason
stored as ${FILE}
as select * from ${SOURCE}.reason;
