#!/bin/bash


java -jar /var/lib/jenkins/jenkins-cli.jar -s http://localhost:8888/ -auth skqist225:11bb763c31708e04ca2b543ecbadcaf37a delete-node $1
