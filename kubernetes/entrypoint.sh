#!/bin/bash

# Sets script to fail if any command fails.
set -e

custom_properties() {
        if [ -f /jobs/kettle.properties ] ; then
                cp /jobs/kettle.properties $KETTLE_HOME
        fi
# Header
echo '=========================================================================='
echo 'Spoon (pdi) docker image with Db2 + Postgres support '
echo 'Version 2.0 04/05/2021 cristian@molaro.be'
echo 'docker pull cmolaro/spoon:v2.0 '
echo '--------------------------------------------------------------------------'
cat $KETTLE_HOME/Data\ Integration.app/Contents/Info.plist | grep Hitachi  | cut -d ">" -f2 | cut -d "<" -f1
#java -cp $KETTLE_HOME/lib/db2jcc.jar com.ibm.db2.jcc.DB2Jcc -version
#java -cp $KETTLE_HOME/lib/postgresql-42.2.5.jar org.postgresql.util.PGJDBCMain | grep "JDBC Driver"
#java -version 2>&1 | tr -d '\"'
date
echo '=========================================================================='
}

run_pan() {
        custom_properties
        echo ./pan.sh -file $@
        pan.sh -file /jobs/$@
}

run_kitchen() {
        custom_properties
        echo ./kitchen.sh -file $@
        kitchen.sh -file /jobs/$@
}

print_usage() {
        custom_properties
echo "
Options:
  runj filename         Run job file
  runt filename         Run transformation file

Example:
  docker run --rm -v $(pwd):/jobs cmolaro/spoon:v2.0 runt sample/dummy.ktr

See more at https://hub.docker.com/r/cmolaro/spoon
"
}

case "$1" in
    help)
        print_usage
        ;;
    runt)
        shift 1
        run_pan "$@"
        ;;
    runj)
        shift 1
        run_kitchen "$@"
        ;;
    *)
        print_usage
        ;;
esac
