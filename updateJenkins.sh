#!/bin/bash

JENKINS_PORT="$1"
JENKINS_USERNAME="$2"
JENKINS_TOKEN="$3"

JENKINS_CLI_PATH=$HOME/jenkins-cli.jar
JENKINS_URL="http://localhost:$JENKINS_PORT/"

DOWNLOAD_URL="http://localhost:$JENKINS_PORT/jnlpJars/jenkins-cli.jar"
DOES_WE_HAVE_JENKINS_CLI_JAR=$(ls ~/ | grep jenkins-cli.jar)  #default install in user folder path
if [[ -z $DOES_WE_HAVE_JENKINS_CLI_JAR ]]; then
    wget -O $JENKINS_CLI_PATH $DOWNLOAD_URL
fi

JENKINS_COMMAND_WITH_AUTH="java -jar $JENKINS_CLI_PATH -s $JENKINS_URL -auth $JENKINS_USERNAME:$JENKINS_TOKEN"

UPDATE_LIST=$($JENKINS_COMMAND_WITH_AUTH list-plugins | grep -e ')$' | awk '{ print $1 }' ); 
if [ ! -z "${UPDATE_LIST}" ]; then 
    echo Updating Jenkins Plugins: ${UPDATE_LIST}; 
    $JENKINS_COMMAND_WITH_AUTH install-plugin ${UPDATE_LIST};
    $JENKINS_COMMAND_WITH_AUTH safe-restart;
    echo "Update Successfully"
fi
