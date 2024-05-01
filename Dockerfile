FROM debian:bullseye-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    wine \
    qemu-kvm \
    fonts-wqy-zenhei \
    xz-utils \
    dbus-x11 \
    curl \
    firefox-esr \
    gnome-system-monitor \
    mate-system-monitor \
    git \
    xfce4 \
    xfce4-terminal \
    tightvncserver \
    wget \
    novnc \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /noVNC

RUN echo '8ifGp%Vtc7@^p*rHVPv%NT' | vncpasswd -f > $HOME/.vnc/passwd \
    && echo '/bin/env  MOZ_FAKE_NO_SANDBOX=1  dbus-launch xfce4-session' > $HOME/.vnc/xstartup \
    && chmod 600 $HOME/.vnc/passwd \
    && chmod 755 $HOME/.vnc/xstartup

COPY entrypoint.sh /
RUN chmod 755 /entrypoint.sh

EXPOSE 8900
HEALTHCHECK CMD wget --quiet --tries=1 --spider http://localhost:8900 || exit 1

USER 1000
ENTRYPOINT ["/entrypoint.sh"]
