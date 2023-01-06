if [[ "$DOCKER" != "true" ]];then
        rm -rf /etc/supervisor/conf.d/docker.conf
fi
if [[ "$PRECOMMAND" != "" ]];then
	echo $PRECOMMAND | base64 -d | bash
fi
supervisord
