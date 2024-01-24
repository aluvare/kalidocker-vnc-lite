FROM kalilinux/kali-last-release AS kali-builder
RUN DEBIAN_FRONTEND=noninteractive apt update
RUN DEBIAN_FRONTEND=noninteractive apt -y install golang-go make git

ARG wg_go_tag=0.0.20220316
ARG wg_tools_tag=v1.0.20210914

RUN git clone https://git.zx2c4.com/wireguard-go && \
    cd wireguard-go && \
    git checkout $wg_go_tag && \
    make && \
    make install

ENV WITH_WGQUICK=yes
RUN git clone https://git.zx2c4.com/wireguard-tools && \
    cd wireguard-tools && \
    git checkout $wg_tools_tag && \
    cd src && \
    make && \
    make install

FROM kalilinux/kali-last-release AS kali

RUN DEBIAN_FRONTEND=noninteractive apt update
RUN DEBIAN_FRONTEND=noninteractive apt -y install kali-desktop-xfce sudo
RUN DEBIAN_FRONTEND=noninteractive apt -y install xfce4 
RUN DEBIAN_FRONTEND=noninteractive apt -y install tigervnc-standalone-server
RUN DEBIAN_FRONTEND=noninteractive apt -y install docker.io
RUN DEBIAN_FRONTEND=noninteractive apt -y install supervisor jq curl
RUN DEBIAN_FRONTEND=noninteractive apt -y install firefox-esr zsh vim netcat-traditional dbus-x11
COPY --from=kali-builder /usr/bin/wireguard-go /usr/bin/wg* /usr/bin/

FROM kali AS final

RUN adduser --disabled-password --gecos '' kali
RUN usermod -a -G sudo,docker kali

RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

RUN chsh -s /bin/bash

RUN mkdir -p /scripts /etc/wireguard
ADD supervisor.conf.d/ /etc/supervisor/conf.d/
ADD launcher.sh /scripts/launcher.sh
RUN touch /root/.ICEauthority && chown kali.kali /root/.ICEauthority
RUN sed -i "s/.*\"cpugraph\".*//g" /etc/xdg/xfce4/panel/default.xml && \
	sed -i "s/.*\"power-manager-plugin\".*//g" /etc/xdg/xfce4/panel/default.xml 

WORKDIR /home/kali

ENV SHELL=/bin/bash

RUN sed -i "s/allowed_users*/allowed_users = anybody/g" /etc/X11/Xwrapper.config
HEALTHCHECK --interval=30s --timeout=5s CMD nc -vz 127.0.0.1 5900

ENTRYPOINT bash /scripts/launcher.sh
