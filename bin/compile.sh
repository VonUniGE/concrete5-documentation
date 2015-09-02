#!/usr/bin/env bash

pushd . > /dev/null
SCRIPT_PATH="${BASH_SOURCE[0]}";
while([ -h "${SCRIPT_PATH}" ]) do
    cd "`dirname "${SCRIPT_PATH}"`"
    SCRIPT_PATH="$(readlink "`basename "${SCRIPT_PATH}"`")";
done
cd "`dirname "${SCRIPT_PATH}"`" > /dev/null
SCRIPT_DIR=`pwd`
ROOT_DIR=`dirname "${SCRIPT_DIR}"`

TZ=UTC
export TZ

CLASSPATH=$CLASSPATH:$ROOT_DIR/lib/saxon/saxon.jar:$ROOT_DIR/lib/docbook-xsl/extensions/saxon65.jar:$ROOT_DIR/lib/xslthl/xslthl.jar
export CLASSPATH

ruby ../lib/compile.rb

popd  > /dev/null
