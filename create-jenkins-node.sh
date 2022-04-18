#!/bin/bash

ALL_ARGS=$@

for arg in $ALL_ARGS; do
  shift
  case $arg in
    "--server-url") set -- "$@" "-s" ;;
    "--node-name") set -- "$@" "-n" ;;
    "--ssh-port") set -- "$@" "-p" ;;
    "--credential-id") set -- "$@" "-c" ;;
    "--token") set -- "$@" "-t" ;;
    "--user") set -- "$@" "-u" ;;
    "--"*) echo "usage $arg: command not found"
            exit 1;
    ;;
    *) set -- "$@" "$arg";;
  esac
done

JENKINS_SERVER_URL="http://localhost:8888/"
NODE_NAME="agent"
CREDENTIAL_ID="jenkins-agent-using-gerrit-ssh"
EXECUTORS=1
REMOTE_ROOT_DIR='/home/jenkins'
JENKINS_API_TOKEN=""
USERID=skqist225

# Parse short options
while getopts "s:n:p:c:t:u:" opt; do
  case "$opt" in
        s) JENKINS_SERVER_URL="$OPTARG";;
        n) NODE_NAME="$OPTARG";;
        p) SSH_PORT="$OPTARG";;
        c) CREDENTIAL_ID="$OPTARG";;
        t) JENKINS_API_TOKEN="$OPTARG";;
        u) USERID="$OPTARG";;
  esac
done

LABELS="$NODE_NAME docker"

echo "$JENKINS_SERVER_URL"
echo "$NODE_NAME"
echo "$CREDENTIAL_ID"
echo "$JENKINS_API_TOKEN"
echo "$USERID"
echo "$LABELS"

cat <<EOF | java -jar /var/lib/jenkins/jenkins-cli.jar -s $JENKINS_SERVER_URL -auth $USERID:$JENKINS_API_TOKEN create-node $NODE_NAME
<slave>
  <name>${NODE_NAME}</name>
  <description></description>
  <remoteFS>${REMOTE_ROOT_DIR}</remoteFS>
  <numExecutors>${EXECUTORS}</numExecutors>
  <mode>EXCLUSIVE</mode>
  <retentionStrategy class="hudson.slaves.RetentionStrategy$Always"/>
  <launcher class="hudson.plugins.sshslaves.SSHLauncher" plugin="ssh-slaves@1.5">
    <host>localhost</host>
    <port>${SSH_PORT}</port>
    <credentialsId>${CREDENTIAL_ID}</credentialsId>
    <javaPath>/opt/java/openjdk/bin/java</javaPath>
    <launchTimeoutSeconds>60</launchTimeoutSeconds>
    <maxNumRetries>10</maxNumRetries>
    <retryWaitTime>15</retryWaitTime>
    <sshHostKeyVerificationStrategy class="hudson.plugins.sshslaves.verifiers.NonVerifyingKeyVerificationStrategy"/>
  </launcher>
  <label>${LABELS}</label>
  <nodeProperties/>
  <userId>${USERID}</userId>
</slave>
EOF
