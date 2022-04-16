#!/bin/bash

IS_WGET_EXIST=$(which wget)
IS_JAVA_EXIST=$(which java)
if [[ -z $IS_WGET_EXIST ]]; then
	sudo apt-get install wget
fi
if [[ -z $IS_JAVA_EXIST ]]; then
	echo "Java was not installed, please install Java 11"
else
 	IS_JAVA_11_EXIST=$(javac -version | awk '{print $2}' | grep 11)
	if [[ -z $IS_JAVA_11_EXIST ]]; then
		echo "please change default java version to java 11"
	fi
fi

FOLDER_TO_INSTALL="$1"
[[ -z $FOLDER_TO_INSTALL ]] && echo "Please specify folder to install gerrit" ||
(
	~/findAndKillPort.sh 29418
	~/findAndKillPort.sh 8080
	sudo adduser gerrit
	sudo rm -rf $FOLDER_TO_INSTALL
	mkdir $FOLDER_TO_INSTALL
	sudo chown gerrit:gerrit $FOLDER_TO_INSTALL 


	GERRIT_VERSION="gerrit-3.5.1.war"
	IS_GERRIT_EXIST_IN_CURRENT_FOLDER=$(find . -type f -name $GERRIT_VERSION)

	if [[ -z $IS_GERRIT_EXIST_IN_CURRENT_FOLDER ]]; then
		wget https://gerrit-releases.storage.googleapis.com/$GERRIT_VERSION
	fi
	sudo java -jar $GERRIT_VERSION init --dev -d $FOLDER_TO_INSTALL
	# sudo cp /dev/null gerrit.config
	# cat <<-EOF | sudo tee -a $FOLDER_TO_INSTALL/etc/gerrit.config
	# 	[gerrit]
	# 		basePath = git
	# 		canonicalWebUrl = http://localhost:8080/
	# 		serverId = 44575dfc-6f40-4f44-8493-b32a5b51d35d
	# 	[container]
	# 		javaOptions = "-Dflogger.backend_factory=com.google.common.flogger.backend.log4j.Log4jBackendFactory#getInstance"
	# 		javaOptions = "-Dflogger.logging_context=com.google.gerrit.server.logging.LoggingContext#getInstance"
	# 		user = $USER
	# 		javaHome = /usr/lib/jvm/java-11-openjdk-amd64
	# 	[index]
	# 		type = lucene
	# 	[auth]
	# 		type = DEVELOPMENT_BECOME_ANY_ACCOUNT
	# 		userNameCaseInsensitive = true
	# 	[receive]
	# 		enableSignedPush = false
	# 	[sendemail]
	# 		smtpServer = localhost
	# 	[sshd]
	# 		listenAddress = *:29418
	# 	[httpd]
	# 		listenUrl = http://localhost:8080/
	# 	[cache]
	# 		directory = cache
	# 	[plugins]
	# 		allowRemoteAdmin = true
	# EOF

	#add ssh for admin user
	ssh-keygen -m PEM -f ~/.ssh/ssh-gerrit -q -N ""
	sudo cp ~/.ssh/ssh-gerrit* /var/lib/jenkins/.ssh
)
