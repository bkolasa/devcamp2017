copy mpk_pos (rn,vehicleno,courseno,lineno,type,stopno,direction,delay,veh_lat,veh_lon,minsnapshottime)
from local './mpk_pos.csv' delimiter ',' skip 2 exceptions './exceptions.sql' direct
copy stops (stopno,name,lat,long)
from local './stops.csv' delimiter ',' skip 1 exceptions './exceptions-stops.sql' direct
