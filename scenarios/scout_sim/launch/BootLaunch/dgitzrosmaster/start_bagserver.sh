#!/bin/bash
sudo docker rm --force $(sudo docker ps -a -q)
sleep 5
sudo docker run -d \
    --name bagdb-postgres \
    --net bagdb \
    -v /var/lib/bagdb-postgres:/var/lib/postgresql/data \
    -e POSTGRES_PASSWORD=letmein \
    -e POSTGRES_USER=bag_database \
    -e POSTGRES_DB=bag_database \
    mdillon/postgis:latest

sudo docker run -d \
    -p 8080:8080 \
    -v /media/robot/ICARUS/BAGStorage:/bags \
    --name bagdb \
    --net bagdb \
    -e DB_DRIVER=org.postgresql.Driver \
    -e DB_PASS=letmein \
    -e DB_URL="jdbc:postgresql://bagdb-postgres/bag_database" \
    -e DB_USER=bag_database \
    -e METADATA_TOPICS="/metadata" \
    -e VEHICLE_NAME_TOPICS="/vehicle_name" \
    -e GPS_TOPICS="/localization/gps, /gps, /imu/fix" \
    swrirobotics/bag-database:latest
