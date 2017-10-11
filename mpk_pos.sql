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
