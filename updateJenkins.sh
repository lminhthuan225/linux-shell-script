#!/bin/bash


JENKINS_CLI_PATH=$HOME/jenkins-cli.jar

UPDATE_LIST=$( java -jar $JENKINS_CLI_PATH -s http://127.0.0.1:8080/ list-plugins | grep -e ')$' | awk '{ print $1 }' ); 
if [ ! -z "${UPDATE_LIST}" ]; then 
    echo Updating Jenkins Plugins: ${UPDATE_LIST}; 
    java -jar $JENKINS_CLI_PATH -s http://127.0.0.1:8080/ install-plugin ${UPDATE_LIST};
    java -jar $JENKINS_CLI_PATH -s http://127.0.0.1:8080/ safe-restart;
fi
