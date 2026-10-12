PW2 Node Tester
 
https://openwrt.org/
https://github.com/Openwrt-Passwall/openwrt-passwall2
LICENSE
Shell
DependenciesA lightweight, non-invasive node latency tester for Passwall2 on ImmortalWrt / OpenWrt.
Adds a small Test button next to each subscription in the Node Subscribe page.
Tests one group at a time, shows live progress, and saves results persistently. 
 
📖 About
 
PW2 Node Tester is a small add-on for Passwall2 that lets you test the latency of every node in a subscription group — directly from the LuCI web interface.
 
Instead of testing all nodes at once (which can take a long time), it lets you test one group at a time, shows you the live progress, and saves the results so you can see which nodes are fastest.
 
It works by injecting a small Test button into the existing Node Subscribe page. It does not modify any Passwall2 file, UCI config, or node data. Install it, use it, and uninstall it whenever you want — your configuration stays untouched.
 
✨ Features
• 🎯 Per-group testing — a small Test button appears next to every subscription in the Node Subscribe page.
• 📊 Live progress — see how many nodes have been tested, how many are left, and how long it's taking.
• 💾 Persistent results — saved to disk, so they survive a reboot.
• 🔒 Non-invasive — never touches Passwall2 files, UCI config, or your nodes.
• 🧩 Dynamic groups — automatically detects every group. Add or remove subscriptions, and the list updates itself.
• 🪶 Lightweight — tests one node at a time with a short timeout. Minimal CPU and RAM usage.
• 🛑 Stop button — cancel a running test at any time.
• 🗑️ Easy uninstall — a single command removes everything cleanly. 
📦 Requirements
Component Version
ImmortalWrt / OpenWrt 23.05 or newer
Passwall2 25.x / 26.x
Shell POSIX sh (BusyBox)
Dependencies None

 
🚀 Installation
 
Run this single command over SSH on your router:
sh
‘’’
wget -O /tmp/pw2nt-install.sh https://raw.githubusercontent.com/gooriltehran/pw2-node-tester/main/install.sh && sh /tmp/pw2nt-install.sh
‘’’
 
After installation, open the LuCI web interface and refresh the page (Ctrl+F5).
 
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
 
This removes only the files added by this project. Passwall2, its UCI config, and all your nodes remain untouched.
 
🔒 Safety
• ✅ Never edits Passwall2 files.
• ✅ Never touches /etc/config/passwall2.
• ✅ Never modifies node data, UUIDs, or subscription URLs.
• ✅ Never restarts Passwall2 or any network service.
• ✅ Only reads UCI to enumerate groups and calls Passwall2's official test.sh. 
📄 License
 
MIT 
