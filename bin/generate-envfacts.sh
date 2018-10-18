#!/usr/bin/env bash

# This script is executed by the Makefile before generating the configurations from container.ccf-defn.jsonnet
# Expecting environment variables upon entry:
# CCF_HOME
# CONTAINER_DEFN_HOME
# CONTAINER_NAME
# JSONNET_PATH
# DEST_PATH

if [ ! -d "$DEST_PATH" ]; then
    echo "A CCF container definition facts destination directory path is expected as DEST_PATH."
    exit 1
fi

CONTAINER_CONF_JSONNET_TMPL=${CONTAINER_CONF_JSONNET_TMPL:-$CCF_HOME/etc/container.facts.ccf-tmpl.jsonnet}
CONTAINER_FACTS_GENERATED_FILE=container.facts.json

jsonnet --ext-str CCF_HOME=$CCF_HOME \
		--ext-str GENERATED_ON="`date`" \
		--ext-str DOCKER_HOST_IP_ADDR=`/sbin/ifconfig eth0 | grep -i mask | awk '{print $$2}'| cut -f2 -d:` \
		--ext-str containerName=$CONTAINER_NAME \
		--ext-str containerDefnHome=$CONTAINER_DEFN_HOME \
		--ext-str currentUserName="`whoami`" \
		--ext-str currentUserId="`id -u`" \
		--ext-str currentUserGroupId="id -g" \
		--ext-str currentUserHome=$HOME \
		--output-file $DEST_PATH/$CONTAINER_FACTS_GENERATED_FILE \
		$CONTAINER_CONF_JSONNET_TMPL

echo "Generated $CONTAINER_FACTS_GENERATED_FILE from $CONTAINER_CONF_JSONNET_TMPL using JSONNET_PATH $JSONNET_PATH"
