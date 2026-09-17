#!/bin/bash
set -e

echo "============================================"
echo "  Starting VNC Desktop Environment"
echo "============================================"

# Environment variables
export DISPLAY=:1
export VNC_PORT=${VNC_PORT:-5901}
export NOVNC_PORT=${NOVNC_PORT:-6080}
export VNC_RESOLUTION=${VNC_RESOLUTION:-1920x1080}
export VNC_PW=${VNC_PW:-vncpassword}

# Kill any existing VNC sessions
vncserver -kill :1 2>/dev/null || true
sleep 1

# Remove stale lock files
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 2>/dev/null || true

# Ensure VNC password is set
mkdir -p ~/.vnc
echo "${VNC_PW}" | vncpasswd -f > ~/.vnc/passwd
chmod 600 ~/.vnc/passwd

# Write xstartup
cat > ~/.vnc/xstartup << 'XSTARTUP'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
export DISPLAY=:1

# Start DBus
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval $(dbus-launch --sh-syntax)
fi

# Start XFCE desktop
exec startxfce4 &
XSTARTUP
chmod +x ~/.vnc/xstartup

# Start VNC server
echo "Starting VNC server on port ${VNC_PORT}..."
vncserver :1 \
    -geometry ${VNC_RESOLUTION} \
    -depth 24 \
    -localhost no \
    -SecurityTypes VncAuth \
    -fg &

VNC_PID=$!
sleep 2

# Determine noVNC path
NOVNC_PATH=""
if [ -d "/usr/share/novnc" ]; then
    NOVNC_PATH="/usr/share/novnc"
elif [ -d "/usr/share/noVNC" ]; then
    NOVNC_PATH="/usr/share/noVNC"
fi

if [ -z "$NOVNC_PATH" ]; then
    echo "ERROR: noVNC not found!"
    exit 1
fi

# Fix noVNC index page
if [ ! -f "${NOVNC_PATH}/index.html" ]; then
    if [ -f "${NOVNC_PATH}/vnc.html" ]; then
        ln -sf "${NOVNC_PATH}/vnc.html" "${NOVNC_PATH}/index.html"
    elif [ -f "${NOVNC_PATH}/vnc_lite.html" ]; then
        ln -sf "${NOVNC_PATH}/vnc_lite.html" "${NOVNC_PATH}/index.html"
    fi
fi

# Start noVNC (websocket proxy)
echo "Starting noVNC on port ${NOVNC_PORT}..."
websockify \
    --web ${NOVNC_PATH} \
    ${NOVNC_PORT} \
    localhost:${VNC_PORT} &

NOVNC_PID=$!
sleep 2

echo "============================================"
echo "  VNC Desktop is ready!"
echo "============================================"
echo ""
echo "  noVNC (browser): http://localhost:${NOVNC_PORT}/vnc.html?autoconnect=true"
echo "  VNC direct:      localhost:${VNC_PORT}"
echo "  VNC Password:    ${VNC_PW}"
echo ""
echo "  Installed Browsers:"
echo "    - Chromium  (use --no-sandbox flag)"
echo "    - Firefox"
echo ""
echo "============================================"

# Keep running
wait $VNC_PID
