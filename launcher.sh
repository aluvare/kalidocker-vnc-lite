if [[ "$DOCKER" != "true" ]];then
        rm -rf /etc/supervisor/conf.d/docker.conf
fi
if [[ "$PRECOMMAND" != "" ]];then
	echo $PRECOMMAND | base64 -d | bash
fi
bash -c 'sleep 10 && sed -i "s/.*\"cpugraph\".*//g" /home/kali/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml && sed -i "s/.*\"power-manager-plugin\".*//g" /home/kali/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml && supervisorctl restart xfce4' &
supervisord
