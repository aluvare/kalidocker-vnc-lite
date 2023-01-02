if [[ "$DOCKER" != "true" ]];then
        rm -rf /etc/supervisor/conf.d/docker.conf
fi
if [[ "${PRE_COMMAND}" != "" ]];then
	echo ${PRE_COMMAND} | base64 -d | bash
fi
supervisord
