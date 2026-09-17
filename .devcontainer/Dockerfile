FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV LANG=en_US.UTF-8
ENV VNC_RESOLUTION=1920x1080
ENV VNC_PW=vncpassword

# Install base packages & desktop environment
RUN apt-get update && apt-get install -y \
    locales \
    sudo \
    wget \
    curl \
    git \
    net-tools \
    dbus-x11 \
    x11-utils \
    xfce4 \
    xfce4-terminal \
    xfce4-goodies \
    mousepad \
    software-properties-common \
    tigervnc-standalone-server \
    tigervnc-common \
    novnc \
    websockify \
    fonts-liberation \
    fonts-noto-color-emoji \
    && locale-gen en_US.UTF-8 \
    && apt-get clean

# Install Native Firefox (non-snap)
RUN add-apt-repository -y ppa:mozillateam/ppa \
    && echo 'Package: *\nPin: release o=LP-PPA-mozillateam\nPin-Priority: 1001' > /etc/apt/preferences.d/mozilla-firefox \
    && apt-get update \
    && apt-get install -y --allow-downgrades firefox \
    && apt-get clean

# Install Google Chrome (non-snap alternative to Chromium)
RUN wget -q https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
    && apt-get install -y ./google-chrome-stable_current_amd64.deb \
    && rm google-chrome-stable_current_amd64.deb \
    && apt-get clean

# Fix noVNC index page
RUN ln -sf /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# Create non-root user
RUN useradd -m -s /bin/bash -G sudo vncuser \
    && echo "vncuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/vncuser

USER vncuser
WORKDIR /home/vncuser

# Set up default VNC password
RUN mkdir -p /home/vncuser/.vnc \
    && echo "${VNC_PW}" | vncpasswd -f > /home/vncuser/.vnc/passwd \
    && chmod 600 /home/vncuser/.vnc/passwd

# Desktop shortcuts
RUN mkdir -p /home/vncuser/Desktop

RUN echo '[Desktop Entry]\nVersion=1.0\nType=Application\nName=Google Chrome\nExec=google-chrome-stable --no-sandbox --disable-dev-shm-usage\nIcon=google-chrome\nTerminal=false\nCategories=Network;WebBrowser;' > /home/vncuser/Desktop/chrome.desktop \
    && chmod +x /home/vncuser/Desktop/chrome.desktop

RUN echo '[Desktop Entry]\nVersion=1.0\nType=Application\nName=Firefox\nExec=firefox\nIcon=firefox\nTerminal=false\nCategories=Network;WebBrowser;' > /home/vncuser/Desktop/firefox.desktop \
    && chmod +x /home/vncuser/Desktop/firefox.desktop

EXPOSE 5901 6080
