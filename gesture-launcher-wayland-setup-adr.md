#  ADR: Gesture, Launcher, and Wayland Migration Setup

##  Status Accepted
---
#  Context
We faced multiple usability and productivity issues on Ubuntu 24.04 (X11 session):
##  Problems

### 1. Touchpad & Gesture Issues (X11)

* No native **3-finger gestures**
* No workspace switching via gestures
* No smooth pinch zoom
* Trackpad gestures partially broken or simulated

### 2. Browser Zoom Issues

* Two-finger pinch mapped to `Ctrl + Scroll`
* Triggered browser zoom UI (undesired)
* No smooth/native zoom experience

### 3. Launcher Limitations

* Needed a **single unified launcher**:

  * Search apps
  * Search files
  * Switch windows
  * Run commands
* Existing tools (like Ulauncher) were:

  * Slow
  * Not fully indexed
  * Required multiple extensions

### 4. Clipboard Tool Issues

* Clipboard manager caused:

  * Shortcut conflicts
  * Instability
* Decided to avoid multi-tool complexity

### 5. GNOME Shortcut Misconfiguration

* Using `gsettings set` incorrectly:

  * Overwrote all existing shortcuts
  * Caused loss of custom bindings

---

#  Decision

We decided to:

##  1. Switch from X11 → Wayland

### Reason:

* Native gesture support
* Better touchpad handling
* Modern display protocol
* Required for smooth UX

---

#  How to Check Current Session

```bash
echo $XDG_SESSION_TYPE
```

### Output:

* `x11` → Legacy session
* `wayland` → Modern session

---

#  Check Wayland Availability

```bash
ls /usr/share/wayland-sessions/
```

---

#  Enable Wayland

```bash
cat /etc/gdm3/custom.conf
```

### Fix configuration:

```ini
[daemon]
#WaylandEnable=false
```

>  Do NOT use `WaylandEnable=true`

---

#  Apply Changes

```bash
reboot
```

---

#  Login Step

At login screen:

* Click ⚙️ icon
* Select **Ubuntu (Wayland)**

---

#  Launcher Decision

##  Selected: Albert

### Why Albert?

* Single unified system
* Fast (C++ backend)
* Built-in:

  * App search
  * File indexing
  * Window switching
  * Command execution
* No need for multiple tools

---

#  Install Albert

```bash
sudo apt install albert
```

---

#  Set Global Shortcut (Wayland Fix)

> Wayland does NOT allow apps to register global shortcuts

### Correct method:

```bash
gnome-control-center keyboard
```

Add:

* Name: `Albert`
* Command:

```bash
albert toggle
```

* Shortcut:

```
Super + Space
```

---

#  Disable Conflicting GNOME Shortcuts

```bash
gsettings set org.gnome.desktop.wm.keybindings switch-input-source "[]"
gsettings set org.gnome.desktop.wm.keybindings switch-input-source-backward "[]"
```

---

#  Critical Mistake (Shortcut Loss)

##  Problem

This command:

```bash
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "[...]"
```

 Overwrites ALL shortcuts

---

##  Fix (Restore Shortcuts)

```bash
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings "[
'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/albert/',
'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom-flashless0/',
'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom-flashless1/',
'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/',
'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/',
'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/',
'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom3/',
'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom4/',
'/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5/'
]"
```

---

#  Backup & Restore (IMPORTANT)

## Backup:

```bash
dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > shortcuts-backup.txt
```

## Restore:

```bash
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < shortcuts-backup.txt
```

---

#  File Indexing Behavior (Albert)

##  Limitation

* Not real-time indexing
* Requires manual rebuild

---

##  Manual Reindex

Inside Albert settings → Files → Rebuild Index

---

##  Automated Reindex (Cron Job)

```bash
crontab -e
```

### Example:

```bash
*/30 * * * * albert
```

### Explanation:

| Value   | Meaning              |
| ------- | -------------------- |
| */30    | Every 30 minutes     |
| * * * * | Every hour/day/month |

> Cron does NOT support seconds → minimum is 1 minute

---

# ⚡ Touchpad Optimization

## Install tools:

```bash
sudo apt install libinput-tools
```

---

## Config:

```bash
sudo nano /etc/X11/xorg.conf.d/90-touchpad.conf
```

---

#  Final Workflow

### Press:

```
Super + Space
```

### Then type:

| Input         | Result        |
| ------------- | ------------- |
| `brave`       | Open app      |
| `idea.sh`     | Find file     |
| `chrome`      | Switch window |
| `> npm start` | Run command   |
| `45*67`       | Calculate     |

---

#  Lessons Learned

* Wayland is essential for modern UX
* GNOME settings must be handled carefully
* `gsettings set` = overwrite, not append
* Always backup before modifying system configs
* One powerful tool > multiple small tools

---

#  Future Improvements

* Integrate AI into launcher
* Custom command workflows
* Gesture-based automation
* Faster indexing system

---

#  Conclusion

Switching to Wayland + using Albert provided:

* Better gestures
* Faster workflow
* Unified search experience
* Cleaner system design

---
