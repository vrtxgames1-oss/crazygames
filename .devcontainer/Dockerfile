FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8
ENV VNC_RESOLUTION=1920x1080
ENV VNC_PW=vncpassword
ENV VNC_PORT=5901
ENV NOVNC_PORT=6080
ENV DISPLAY=:1

# Install base dependencies
RUN apt-get update && apt-get install -y \
    locales \
    sudo \
    wget \
    curl \
    git \
    net-tools \
    xz-utils \
    dbus-x11 \
    x11-utils \
    x11-xserver-utils \
    xdg-utils \
    && locale-gen en_US.UTF-8 \
    && apt-get clean

# Install desktop environment (XFCE - lightweight)
RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-terminal \
    xfce4-goodies \
    mousepad \
    thunar \
    && apt-get clean

# Install VNC server and noVNC
RUN apt-get update && apt-get install -y \
    tigervnc-standalone-server \
    tigervnc-common \
    tigervnc-tools \
    novnc \
    websockify \
    && apt-get clean

# Install Chromium
RUN apt-get update && apt-get install -y \
    chromium-browser \
    && apt-get clean

# Install Firefox
RUN apt-get update && apt-get install -y \
    firefox \
    && apt-get clean

# Install additional useful packages
RUN apt-get update && apt-get install -y \
    fonts-liberation \
    fonts-noto-color-emoji \
    fonts-dejavu-core \
    fonts-freefont-ttf \
    libgtk-3-0 \
    libnss3 \
    libxss1 \
    libasound2 \
    libgbm1 \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create non-root user
RUN useradd -m -s /bin/bash -G sudo vncuser \
    && echo "vncuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/vncuser

# Switch to user
USER vncuser
WORKDIR /home/vncuser

# Set up VNC password
RUN mkdir -p /home/vncuser/.vnc \
    && echo "${VNC_PW}" | vncpasswd -f > /home/vncuser/.vnc/passwd \
    && chmod 600 /home/vncuser/.vnc/passwd

# VNC xstartup
RUN echo '#!/bin/bash\n\
unset SESSION_MANAGER\n\
unset DBUS_SESSION_BUS_ADDRESS\n\
export DISPLAY=:1\n\
exec startxfce4 &' > /home/vncuser/.vnc/xstartup \
    && chmod +x /home/vncuser/.vnc/xstartup

# Copy startup script
COPY --chown=vncuser:vncuser startup.sh /home/vncuser/.startup.sh
RUN chmod +x /home/vncuser/.startup.sh

# Create desktop shortcuts for browsers
RUN mkdir -p /home/vncuser/Desktop

RUN echo '[Desktop Entry]\n\
Version=1.0\n\
Type=Application\n\
Name=Chromium\n\
Exec=chromium-browser --no-sandbox --disable-gpu --disable-dev-shm-usage\n\
Icon=chromium-browser\n\
Terminal=false\n\
Categories=Network;WebBrowser;' > /home/vncuser/Desktop/chromium.desktop \
    && chmod +x /home/vncuser/Desktop/chromium.desktop

RUN echo '[Desktop Entry]\n\
Version=1.0\n\
Type=Application\n\
Name=Firefox\n\
Exec=firefox\n\
Icon=firefox\n\
Terminal=false\n\
Categories=Network;WebBrowser;' > /home/vncuser/Desktop/firefox.desktop \
    && chmod +x /home/vncuser/Desktop/firefox.desktop

# Trust desktop files (XFCE)
RUN mkdir -p /home/vncuser/.config/xfce4 \
    && mkdir -p /home/vncuser/.local/share/applications

EXPOSE 5901 6080
