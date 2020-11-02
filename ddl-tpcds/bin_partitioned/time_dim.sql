create database if not exists ${DB} managedlocation "${DBLOCATION}";
use ${DB};

drop table if exists time_dim;

create table time_dim
stored as ${FILE}
as select * from ${SOURCE}.time_dim;
