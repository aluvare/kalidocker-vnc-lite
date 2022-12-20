FROM kalilinux/kali-last-release:amd64 AS kali-amd64

RUN DEBIAN_FRONTEND=noninteractive apt update
RUN DEBIAN_FRONTEND=noninteractive apt -y install kali-desktop-xfce sudo
RUN DEBIAN_FRONTEND=noninteractive apt -y install xfce4 
RUN DEBIAN_FRONTEND=noninteractive apt -y install tigervnc-standalone-server
RUN DEBIAN_FRONTEND=noninteractive apt -y install docker.io
RUN DEBIAN_FRONTEND=noninteractive apt -y install supervisor jq curl
RUN DEBIAN_FRONTEND=noninteractive apt -y install firefox-esr zsh vim netcat-traditional

FROM kalilinux/kali-last-release:arm64 AS kali-arm64

RUN DEBIAN_FRONTEND=noninteractive apt update
RUN DEBIAN_FRONTEND=noninteractive apt -y install kali-desktop-xfce sudo
RUN DEBIAN_FRONTEND=noninteractive apt -y install xfce4 
RUN DEBIAN_FRONTEND=noninteractive apt -y install tigervnc-standalone-server
RUN DEBIAN_FRONTEND=noninteractive apt -y install docker.io
RUN DEBIAN_FRONTEND=noninteractive apt -y install supervisor jq curl
RUN DEBIAN_FRONTEND=noninteractive apt -y install firefox-esr zsh vim netcat-traditional

FROM kali-${TARGETARCH} AS final

RUN adduser --disabled-password --gecos '' kali
RUN usermod -a -G sudo,docker kali

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN chsh -s /bin/bash

RUN mkdir -p /scripts
ADD supervisor.conf.d/ /etc/supervisor/conf.d/
ADD launcher.sh /scripts/launcher.sh
RUN touch /root/.ICEauthority && chown kali.kali /root/.ICEauthority

WORKDIR /home/kali

ENV HOME=/home/kali \
	SHELL=/bin/bash

RUN sed -i "s/allowed_users*/allowed_users = anybody/g" /etc/X11/Xwrapper.config
HEALTHCHECK --interval=30s --timeout=5s CMD nc -vz 127.0.0.1 5900

USER kali
ENTRYPOINT sudo bash /scripts/launcher.sh
