#!/bin/bash
########################################################
# Cron-triggered Oracle space reclaim script
########################################################
export ORACLE_SID=$1
export ORACLE_HOME=/u01/app/oracle/product/12.1.0/db1

su - oracle -c "export ORACLE_SID=${ORACLE_SID} && ${ORACLE_HOME}/bin/rman target / << EOF 
                run {
                crosscheck backup;
                crosscheck archivelog all;
                delete noprompt expired backup;
                delete noprompt obsolete;
                delete noprompt expired archivelog all;
                delete noprompt force archivelog all completed before 'sysdate-3';
                crosscheck backup;
                crosscheck archivelog all;
                }
EOF"