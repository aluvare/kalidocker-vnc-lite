FROM kalilinux/kali:amd64

RUN DEBIAN_FRONTEND=noninteractive apt update
RUN DEBIAN_FRONTEND=noninteractive apt -y install kali-desktop-xfce
RUN DEBIAN_FRONTEND=noninteractive apt -y install xfce4 
RUN DEBIAN_FRONTEND=noninteractive apt -y install tigervnc-standalone-server
RUN DEBIAN_FRONTEND=noninteractive apt -y install docker.io
RUN DEBIAN_FRONTEND=noninteractive apt -y install supervisor
RUN DEBIAN_FRONTEND=noninteractive apt -y install kali-desktop-core
RUN DEBIAN_FRONTEND=noninteractive apt -y install kali-linux-default

RUN mkdir -p /scripts
ADD supervisor.conf.d/ /etc/supervisor/conf.d/
ADD launcher.sh /scripts/launcher.sh

ENTRYPOINT bash /scripts/launcher.sh
