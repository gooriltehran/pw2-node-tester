<h1 align="center">PW2 Node Tester</h1>

 
<p align="center">
  <b>A lightweight, non-invasive node latency tester for Passwall2</b><br>
  <sub>Test subscription groups one at a time — right from the LuCI web interface.</sub>
</p>

 
<p align="center">
  <a href="https://openwrt.org/"><img src="https://img.shields.io/badge/platform-ImmortalWrt%20%7C%20OpenWrt-blue.svg" alt="Platform"></a>
  <a href="https://github.com/Openwrt-Passwall/openwrt-passwall2"><img src="https://img.shields.io/badge/Passwall2-25.x%20%7C%2026.x-green.svg" alt="Passwall2"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-orange.svg" alt="License"></a>
  <a href="#"><img src="https://img.shields.io/badge/shell-POSIX%20sh-lightgrey.svg" alt="Shell"></a>
  <a href="#"><img src="https://img.shields.io/badge/dependencies-none-success.svg" alt="Dependencies"></a>
</p>
 
 
📖 Overview
 
PW2 Node Tester is a small add-on for Passwall2 that lets you test the latency of every node in a subscription group — directly from the LuCI web interface.
 
Instead of testing all nodes at once (which can take a very long time), it lets you test one group at a time, shows you the live progress, and saves the results so you can see which nodes are fastest.💡 It works by injecting a small Test button into the existing Node Subscribe page. It does not modify any Passwall2 file, UCI config, or node data. Install it, use it, and uninstall it whenever you want — your configuration stays untouched. 
 
✨ Features
Feature Description
🎯 Per-group testing A small Test button appears next to every subscription in the Node Subscribe page.
📊 Live progress See how many nodes have been tested, how many are left, and how long it's taking.
💾 Persistent results Saved to disk — they survive a reboot.
🔒 Non-invasive Never touches Passwall2 files, UCI config, or your nodes.
🧩 Dynamic groups Automatically detects every group. Add or remove subscriptions, and the list updates itself.
🪶 Lightweight Tests one node at a time with a short timeout. Minimal CPU and RAM usage.
🛑 Stop button Cancel a running test at any time.
🗑️ Easy uninstall A single command removes everything cleanly.

 
 
📦 Requirements
Component Version
ImmortalWrt / OpenWrt 23.05 or newer
Passwall2 25.x / 26.x
Shell POSIX sh (BusyBox)
Dependencies None

 
 
🚀 Installation
 
Run this single command over SSH on your router:
wget -O /tmp/pw2nt-install.sh https://raw.githubusercontent.com/gooriltehran/pw2-node-tester/main/install.sh && sh /tmp/pw2nt-install.sh
 
Then open the LuCI web interface and refresh the page (Ctrl+F5). 
 
🎮 Usage
1. Go to Services → Passwall 2 → Node Subscribe.
2. A small Test button appears next to each subscription.
3. Click it to start testing that group only.
4. Watch the live progress.
5. When the test finishes, a ranked list of nodes appears.
6. Click Stop at any time to cancel. 
 
🗑 Uninstall
 
Run this single command:
wget -O /tmp/pw2nt-uninstall.sh https://raw.githubusercontent.com/gooriltehran/pw2-node-tester/main/uninstall.sh && sh /tmp/pw2nt-uninstall.sh
‌This removes only the files added by this project. Passwall2, its UCI config, and all your nodes remain untouched. 
 
🔒 Safety
• ✅ Never edits Passwall2 files.
• ✅ Never touches /etc/config/passwall2.
• ✅ Never modifies node data, UUIDs, or subscription URLs.
• ✅ Never restarts Passwall2 or any network service.
• ✅ Only reads UCI to enumerate groups and calls Passwall2's official test.sh. 
 
📂 File Locations
Path Purpose
/etc/pw2nt/ Persistent storage (results, state, logs)
/usr/libexec/pw2nt/ Worker and API scripts
/usr/lib/lua/luci/controller/pw2nt.lua LuCI controller
/www/luci-static/resources/pw2nt/ Frontend JavaScript

 
 
🤝 Contributing
 
Pull requests are welcome. For major changes, please open an issue first. 
 
📄 License
 
Released under the MIT License. 
