# VNC Linux Desktop for GitHub Codespaces

A full Linux desktop environment (XFCE) accessible through your browser via noVNC, with Chromium and Firefox pre-installed.

## 🚀 Quick Start

1. Click **"Code" → "Codespaces" → "Create codespace on main"**
2. Wait for the container to build (first time takes ~3-5 minutes)
3. When the **port 6080** notification pops up, click **"Open in Browser"**
4. Enter the VNC password: `vncpassword`
5. You now have a full Linux desktop in your browser!

## 🔗 Access

| Method | Port | URL |
|--------|------|-----|
| noVNC (Browser) | 6080 | Auto-opens or check the **Ports** tab |
| VNC Client | 5901 | `localhost:5901` (if port-forwarded locally) |

**Password:** `vncpassword`

## 🌐 Browsers

### Chromium
- Desktop shortcut on the desktop
- Or run in terminal: `chromium-browser --no-sandbox --disable-dev-shm-usage`

### Firefox
- Desktop shortcut on the desktop
- Or run in terminal: `firefox`

## ⚙️ Configuration

Edit environment variables in the `Dockerfile`:

| Variable | Default | Description |
|----------|---------|-------------|
| `VNC_RESOLUTION` | `1920x1080` | Screen resolution |
| `VNC_PW` | `vncpassword` | VNC password |
| `VNC_PORT` | `5901` | VNC server port |
| `NOVNC_PORT` | `6080` | noVNC web client port |

## 🛠 Troubleshooting

### Desktop not loading?
```bash
# Restart everything
bash ~/.startup.sh
