#!/bin/bash
#
# Copyright (C) 2020 Tuono, Inc.
# All Rights Reserved
#
# called by the integration test with one argument:
# $1 is the path to the asset file from "confab apply"
#
# the environment will have "nc" and "yq" available to run
#

set -e

# By default, assume the TESTLIB_DIR up a level from this
TESTLIB_DIR=${TESTLIB_DIR:=$(dirname $(dirname "${BASH_SOURCE[0]}"))}
source ${TESTLIB_DIR}/validate_testlib.sh

validation_start ${0#$CONFAB_DATA}

ipaddr=$(cat $1 | yq r - 'compute.nic.example-external.ips[0].public.ip')

echo "example: ${ipaddr}"
echo ""

# check if the RDP service on tcp/3389 is reachable
test_nc_tcp_port ${ipaddr} 3389 "ms-wbt-server" 1
echo "RDP service on tcp/3389 is reachable at ${ipaddr}."
echo ""

# check if http is accessible
test_curl http://${ipaddr} $CURLE_SUCCESS
echo "IIS is running - userdata was successful."
echo ""

echo "VALIDATION SUCCESSFUL"
echo ""
