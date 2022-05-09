#!/bin/sh

# Author : Tracy A. McCormick
# WVU Libraries
# Date : 03/11/2022
# Purpose : This script is used to export mfcs development database 
echo "Backing Up MFCS Dev Database"
docker exec -t mfcs_db pg_dumpall -U postgres > ./scripts/postgres-db-dump/mfcs-ruby_`date +%d-%m-%Y"_"%H_%M_%S`.sql
# docker exec -t mfcs_db pg_dump -U postgres --blobs > ./postgres-db-dump/mfcs-ruby_`date +%d-%m-%Y"_"%H_%M_%S`.dump mfcs_dev