if [[ "$DOCKER" != "true" ]];then
        rm -rf /etc/supervisor/conf.d/docker.conf
fi
supervisord
