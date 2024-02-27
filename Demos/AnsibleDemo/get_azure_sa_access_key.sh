#!/bin/bash

#Put account name as first param

#demoprojm2024sa

key=$(az storage account keys list --account-name $1 --query [0].value)
echo $key