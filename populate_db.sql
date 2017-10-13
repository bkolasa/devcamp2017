create table mpk_pos (
rn bigint,
vehicleno varchar(20),
courseno varchar(20),
lineno varchar(20),
type varchar(1),
stopno varchar(20),
direction varchar(20),
delay bigint,
veh_lat numeric,
veh_lon numeric,
minsnapshottime timestamp
) order by minsnapshottime;

create table stops (
stop_id varchar(20),
stopno varchar(20),
name varchar(200),
lat numeric,
long numeric
) order by stopno;

copy mpk_pos (rn,vehicleno,courseno,lineno,type,stopno,direction,delay,veh_lat,veh_lon,minsnapshottime)
from local './mpk_pos.csv' delimiter ',' skip 2 exceptions './exceptions.sql' direct;

copy stops (stop_id,stopno,name,lat,long)
from local './stops.csv' delimiter ',' skip 1 exceptions './exceptions-stops.sql' direct;
