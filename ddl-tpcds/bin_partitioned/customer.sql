create database if not exists ${DB} location "${DBLOCATION}";
use ${DB};

drop table if exists customer;

create table customer
stored as ${FILE}
as select * from ${SOURCE}.customer
CLUSTER BY c_customer_sk
;
