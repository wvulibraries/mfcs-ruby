#!/bin/sh

# Author : Tracy A. McCormick
# WVU Libraries
# Date : 03/11/2022
# Purpose : This script is used to import mfcs development database 
# Run script from the scripts folder on host machine
echo "Restoring MFCS Dev Database"
file=$(ls -t ./postgres-db-dump/*.sql | head -1)
cat $file | docker exec -i db psql -U postgres
