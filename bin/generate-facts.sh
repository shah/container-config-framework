#!/usr/bin/env bash

# This script is executed by the Makefile before generating the configurations from container.ccf-defn.jsonnet
# Expecting environment variables upon entry:
# CCF_HOME
# CCF_FACTS_FILES
# CONTAINER_DEFN_HOME
# CONTAINER_NAME
# JSONNET_PATH
# DEST_PATH

if [ ! -d "$DEST_PATH" ]; then
    echo "A CCF container definition facts destination directory path is expected as DEST_PATH."
    exit 1
fi

osqueryFactsSingleRow() {
	osqueryi --json "$2" | jq '.[0]' > $DEST_PATH/$1.ccf-facts.json
}

osqueryFactsMultipleRows() {
	osqueryi --json "$2" > $DEST_PATH/$1.ccf-facts.json
}

shellEvalFacts() {
	destFile=$DEST_PATH/$1.ccf-facts.json
	touch $destFile
	existingValues=$(<$destFile)
	if [  -z "$existingValues" ]; then
		existingValues="{}"
	fi
	textValue=`eval $3`;	
	echo $existingValues | jq --arg key "$2" --arg value "$textValue" '. + {($key) : $value}' > $destFile
}

generateFacts() {
	echo "Generating facts from $1 into $DEST_PATH using JSONNET_PATH $JSONNET_PATH"
	jsonnet $1 | jq -r '.osQueries.singleRow[] | "osqueryFactsSingleRow \(.name) \"\(.query)\""' | source /dev/stdin
	jsonnet $1 | jq -r '.osQueries.multipleRows[] | "osqueryFactsMultipleRows \(.name) \"\(.query)\""' | source /dev/stdin
	jsonnet $1 | jq -r '.shellEvals[] | "shellEvalFacts \(.name) \(.key) \"\(.evalAsTextValue)\""' | source /dev/stdin
}

IFS=';' read -ra FF <<< "$CCF_FACTS_FILES"
for i in "${FF[@]}"; do
	if [-f $i]; then 
		generateFacts "$i"
	else
		echo "Skipping facts file $1 from CCF_FACTS_FILES, does not exist."
	fi
done

CONTEXT_FACTS_JSONNET_TMPL=${CONTEXT_FACTS_JSONNET_TMPL:-$CCF_HOME/etc/context.ccf-facts.ccf-tmpl.jsonnet}
CONTEXT_FACTS_GENERATED_FILE=${CONTEXT_FACTS_GENERATED_FILE:-context.ccf-facts.json}

jsonnet --ext-str CCF_HOME=$CCF_HOME \
		--ext-str GENERATED_ON="`date`" \
		--ext-str JSONNET_PATH=$JSONNET_PATH \
		--ext-str containerName=$CONTAINER_NAME \
		--ext-str containerDefnHome=$CONTAINER_DEFN_HOME \
		--ext-str currentUserName="`whoami`" \
		--ext-str currentUserId="`id -u`" \
		--ext-str currentUserGroupId="id -g" \
		--ext-str currentUserHome=$HOME \
		--output-file $DEST_PATH/$CONTEXT_FACTS_GENERATED_FILE \
		$CONTEXT_FACTS_JSONNET_TMPL

echo "Generated $CONTEXT_FACTS_GENERATED_FILE from $CONTEXT_FACTS_JSONNET_TMPL"
