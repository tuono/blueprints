#!/bin/bash
#
# Copyright (C) 2019 Tuono, Inc.
# All Rights Reserved
#

# called by the integration test with one argument:
# $1 is the path to the asset file from "confab apply"
#
# the environment will have "yq" available to run

set -e

# By default, assume the TESTLIB_DIR is the same as the source
TESTLIB_DIR=${TESTLIB_DIR:=$(dirname $(dirname "${BASH_SOURCE[0]}"))}
source ${TESTLIB_DIR}/validate_testlib.sh

validation_start ${0#$CONFAB_DATA}

ipaddr=$(cat $1 | yq r - 'compute.nic.example-external.ips[0].public.ip')
user=adminuser

remote_cmd_raw ${user} ${ipaddr} "sudo apt-get update"
echo "SSH successful and Internet communication verified."
echo ""

test_curl http://${ipaddr} $CURLE_SUCCESS
echo "NGINX is running - userdata was successful."
echo ""

echo "VALIDATION SUCCESSFUL"
echo ""
