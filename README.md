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

 
<p align="center">
  <a href="#-فارسی"><b>🇮🇷 فارسی</b></a> &nbsp;•&nbsp;
  <a href="#-english"><b>🇬🇧 English</b></a>
</p>
 
 
<a id="-فارسی"></a>
 
🇮🇷 فارسی
 
<div dir="rtl" align="right">

 
📖 درباره
 
PW2 Node Tester یه افزونه کوچیک برای Passwall2 هست که بهت اجازه می‌ده latency همه‌ی نودهای یه گروه سابسکرایب رو مستقیم از رابط وب LuCI تست کنی.
 
به‌جای اینکه همه‌ی نودها رو یه‌جا تست کنه (که ممکنه خیلی طول بکشه)، می‌ذاره هر گروه رو جداگانه تست کنی، پیشرفت زنده رو ببینی، و نتیجه رو ذخیره می‌کنه تا بفهمی کدوم نودها سریع‌ترن.💡 این افزونه یه دکمه کوچیک تست رو به صفحه Node Subscribe اضافه می‌کنه. به هیچ فایل Passwall2، کانفیگ UCI، یا داده نودها دست نمی‌زنه. نصبش کن، استفاده کن، هر وقت خواستی حذفش کن — تنظیماتت دست‌نخورده می‌مونه. 
✨ امکانات
امکان توضیح
🎯 تست هر گروه جداگانه یه دکمه کوچیک «تست» کنار هر سابسکرایب توی صفحه Node Subscribe ظاهر می‌شه.
📊 پیشرفت زنده ببین چند نود تست شده، چند تا مونده، و چقدر طول کشیده.
💾 نتایج ماندگار روی دیسک ذخیره می‌شه — با ریبوت پاک نمی‌شه.
🔒 غیرمخرب هیچ‌وقت به فایل‌های Passwall2، کانفیگ UCI، یا نودها دست نمی‌زنه.
🧩 گروه‌های داینامیک خودکار همه گروه‌ها رو تشخیص می‌ده. ساب اضافه یا پاک کنی، لیست خودش آپدیت می‌شه.
🪶 سبک هر بار یه نود رو با timeout کوتاه تست می‌کنه. کم‌ترین فشار به CPU و RAM.
🛑 دکمه توقف هر لحظه می‌تونی تست در حال اجرا رو لغو کنی.
🗑️ حذف آسان با یه دستور، همه چیز تمیز پاک می‌شه.

 
📦 پیش‌نیازها
کامپوننت نسخه
ImmortalWrt / OpenWrt 23.05 یا بالاتر
Passwall2 25.x / 26.x
Shell POSIX sh (BusyBox)
وابستگی هیچ

 
🚀 نصب
 
این دستور رو توی SSH روتر اجرا کن:
 
</div>
wget -O /tmp/pw2nt-install.sh https://raw.githubusercontent.com/gooriltehran/pw2-node-tester/main/install.sh && sh /tmp/pw2nt-install.sh
 
<div dir="rtl" align="right">

 
بعد از نصب، برو توی LuCI و صفحه رو رفرش کن (Ctrl+F5).
 
🎮 استفاده
 
۱. برو به Services → Passwall 2 → Node Subscribe.
۲. کنار هر سابسکرایب یه دکمه کوچیک تست ظاهر می‌شه.
۳. روش کلیک کن تا فقط همون گروه تست بشه.
۴. پیشرفت زنده رو ببین.
۵. وقتی تست تموم شد، لیست رتبه‌بندی‌شده نودها ظاهر می‌شه.
۶. هر لحظه خواستی، دکمه توقف رو بزن.
 
🗑 حذف
 
این دستور رو اجرا کن:
 
</div>
wget -O /tmp/pw2nt-uninstall.sh https://raw.githubusercontent.com/gooriltehran/pw2-node-tester/main/uninstall.sh && sh /tmp/pw2nt-uninstall.sh
 
<div dir="rtl" align="right">
فقط همون فایل‌هایی که این پروژه اضافه کرده حذف می‌شن. Passwall2، کانفیگ UCI و همه نودها دست‌نخورده باقی می‌مونن. 
🔒 امنیت
• ✅ هیچ‌وقت فایل‌های Passwall2 رو ویرایش نمی‌کنه.
• ✅ هیچ‌وقت به /etc/config/passwall2 دست نمی‌زنه.
• ✅ هیچ‌وقت داده نودها، UUID یا URL سابسکرایب رو تغییر نمی‌ده.
• ✅ هیچ‌وقت Passwall2 یا سرویس شبکه رو ری‌استارت نمی‌کنه.
• ✅ فقط UCI رو می‌خونه تا گروه‌ها رو بشماره و test.sh رسمی Passwall2 رو صدا می‌زنه. 
📂 محل فایل‌ها
مسیر کاربرد
/etc/pw2nt/ ذخیره‌گاه ماندگار (نتایج، وضعیت، لاگ)
/usr/libexec/pw2nt/ اسکریپت‌های worker و API
/usr/lib/lua/luci/controller/pw2nt.lua کنترلر LuCI
/www/luci-static/resources/pw2nt/ فایل‌های JavaScript فرانت‌اند

 
</div>
 
 
<a id="-english"></a>
 
🇬🇧 English
 
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
