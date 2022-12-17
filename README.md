# kalidocker-vnc-lite

kalidocker-vnc-lite is a Docker image to provide a VNC interface to access Kali XFCE desktop environment.

## Quick Start

Run the docker container and access with port using VNC `5900`

```shell
docker run -it -p 5900:5900 ghcr.io/aluvare/kalidocker-vnc-lite/kalidocker-vnc-lite
```

## Using web access

Run this docker-compose file and access using a browser to the port 8080

```
version: "2.3"
services:
  kali:
    image: ghcr.io/aluvare/kalidocker-vnc-lite/kalidocker-vnc-lite
    restart: always
    healthcheck:
      interval: 10s
      retries: 12
      test: nc -vz 127.0.0.1 5900
  novnc:
    image: ghcr.io/aluvare/easy-novnc/easy-novnc
    restart: always
    depends_on:
      - kali
    command: --addr :8080 --host kali --port 5900 --basic-ui --no-url-password --novnc-params "resize=remote"
    ports:
      - "8080:8080"
```

## Using docker inside the desktop

First of all, you need to install `https://github.com/nestybox/sysbox` in the docker host.
 
After that, you need to add this line to the kali docker-compose config:

```
    runtime: sysbox-runc
    environment:
      - "DOCKER=true"
```
