#!/bin/bash
########################################################
# This script will force remove all the archive log that created a day ago.
# Example for IBC database
# /opt/igx/scripts/rm_archivelog_oracle.sh 'IBCDEVDB' '/u01/app/oracle/product/12.1.0/db1'
# Example for IGXDB database
# /opt/igx/scripts/rm_archivelog_oracle.sh 'IGXDB' '/u01/app/oracle/product/11.2.0/db_1'
########################################################
export ORACLE_SID=$1
export ORACLE_HOME=$2

su - oracle -c "export ORACLE_SID=${ORACLE_SID} && ${ORACLE_HOME}/bin/rman target / << EOF 
                run {
                delete noprompt force archivelog all completed before 'sysdate -1';
                crosscheck archivelog all;
                }
EOF"