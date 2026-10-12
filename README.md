<h1 align="center">PW2 Node Tester</h1>

 
<p align="center">
  <b>Node latency tester for Passwall2 on ImmortalWrt / OpenWrt</b><br>
  <sub>Test subscription groups individually, directly from the LuCI web interface.</sub>
</p>

 
<p align="center">
  <a href="https://openwrt.org/"><img src="https://img.shields.io/badge/Platform-ImmortalWrt%20%7C%20OpenWrt-blue?style=flat-square" alt="Platform"></a>
  <a href="https://github.com/Openwrt-Passwall/openwrt-passwall2"><img src="https://img.shields.io/badge/Passwall2-25.x%20%7C%2026.x-green?style=flat-square" alt="Passwall2"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/License-MIT-orange?style=flat-square" alt="License"></a>
  <a href="#"><img src="https://img.shields.io/badge/Shell-POSIX%20sh-lightgrey?style=flat-square" alt="Shell"></a>
  <a href="#"><img src="https://img.shields.io/badge/Dependencies-None-success?style=flat-square" alt="Dependencies"></a>
</p>

 
<p align="center">
  <a href="#-فارسی"><b>فارسی</b></a> &nbsp;·&nbsp;
  <a href="#-english"><b>English</b></a>
</p>
 
 
<a id="-فارسی"></a>
 
فارسی
 
<div dir="rtl" align="right">

 
درباره
 
Passwall2 Node Tester یک افزونه‌ی سبک برای Passwall2 است که به شما امکان می‌دهد تأخیر (latency) تمام نودهای یک گروه سابسکرایب را مستقیماً از رابط وب LuCI اندازه‌گیری کنید.
 
به‌جای آزمایش هم‌زمان تمام نودها — که ممکن است دقایق طولانی به طول بیانجامد — این افزونه امکان می‌دهد هر گروه را به‌صورت مستقل تست کنید، پیشرفت زنده را مشاهده کنید، و نتیجه را ذخیره کنید تا سریع‌ترین نودها را بشناسید.
 
این افزونه یک دکمه‌ی کوچک «تست» به صفحه‌ی Node Subscribe اضافه می‌کند و به هیچ فایلی از Passwall2، تنظیمات UCI، یا داده‌ی نودها دست نمی‌زند.
 
امکانات
• تست گروه‌به‌گروه — یک دکمه‌ی «تست» کنار هر سابسکرایب در صفحه‌ی Node Subscribe ظاهر می‌شود.
• پیشرفت زنده — تعداد نودهای تست‌شده، نودهای باقی‌مانده و زمان سپری‌شده را در لحظه ببینید.
• نتایج ماندگار — نتایج روی دیسک ذخیره می‌شوند و پس از ریبوت از بین نمی‌روند.
• غیرمخرب — هیچ‌گاه به فایل‌های Passwall2، تنظیمات UCI، یا نودها دست نمی‌زند.
• گروه‌های پویا — گروه‌ها به‌طور خودکار از UCI خوانده می‌شوند. با افزودن یا حذف سابسکرایب، فهرست بدون نیاز به تنظیم مجدد به‌روزرسانی می‌شود.
• مصرف کم — هر بار تنها یک نود با یک timeout کوتاه تست می‌شود. مصرف CPU و RAM در حداقل است.
• دکمه‌ی توقف — در هر لحظه می‌توانید تست در حال اجرا را لغو کنید.
• حذف ساده — با یک دستور، تمام فایل‌های افزونه حذف می‌شوند. 
پیش‌نیازها
کامپوننت نسخه
ImmortalWrt یا OpenWrt ۲۳.۰۵ یا بالاتر
Passwall2 ۲۵.x یا ۲۶.x
Shell POSIX sh (BusyBox)
وابستگی ندارد

 
نصب
 
دستور زیر را در SSH روتر اجرا کنید:

wget -O /tmp/pw2nt-install.sh https://raw.githubusercontent.com/gooriltehran/pw2-node-tester/main/install.sh && sh /tmp/pw2nt-install.sh
 
پس از نصب، وارد LuCI شوید و صفحه را با فشردن Ctrl+F5 بازخوانی کنید.
 
استفاده
 
۱. به مسیر Services ← Passwall 2 ← Node Subscribe بروید.
۲. کنار هر سابسکرایب یک دکمه‌ی «تست» ظاهر می‌شود.
۳. روی آن کلیک کنید تا فقط همان گروه تست شود.
۴. پیشرفت زنده را مشاهده کنید.
۵. با پایان تست، فهرست رتبه‌بندی‌شده‌ی نودها نمایش داده می‌شود.
۶. در هر لحظه می‌توانید دکمه‌ی «توقف» را بزنید.
 
حذف
 
دستور زیر را در SSH روتر اجرا کنید:

wget -O /tmp/pw2nt-uninstall.sh https://raw.githubusercontent.com/gooriltehran/pw2-node-tester/main/uninstall.sh && sh /tmp/pw2nt-uninstall.sh
 
فقط فایل‌هایی که این افزونه اضافه کرده است حذف می‌شوند. Passwall2، تنظیمات UCI، و تمام نودها دست‌نخورده باقی می‌مانند.
 
امنیت
• فایل‌های Passwall2 را ویرایش نمی‌کند.
• به /etc/config/passwall2 دست نمی‌زند.
• داده‌ی نودها، UUID، یا آدرس سابسکرایب را تغییر نمی‌دهد.
• Passwall2 یا سرویس شبکه را ری‌استارت نمی‌کند.
• تنها UCI را می‌خواند و test.sh رسمی Passwall2 را فراخوانی می‌کند. 
محل فایل‌ها
مسیر کاربرد
/etc/pw2nt/ ذخیره‌گاه ماندگار (نتایج، وضعیت، لاگ)
/usr/libexec/pw2nt/ اسکریپت‌های worker و API
/usr/lib/lua/luci/controller/pw2nt.lua کنترلر LuCI
/www/luci-static/resources/pw2nt/ فایل‌های JavaScript فرانت‌اند

 
</div>
 
 
<a id="-english"></a>
 
English
 
About
 
PW2 Node Tester is a lightweight add-on for Passwall2 that lets you measure the latency of every node inside a subscription group, directly from the LuCI web interface.
 
Instead of testing all nodes at once — which can take a long time — this add-on lets you test each group independently, watch live progress, and keep the results so you can identify the fastest nodes.
 
It adds a small Test button to the Node Subscribe page and does not modify any Passwall2 file, UCI configuration, or node data.
 
Features
• Per-group testing — a small Test button appears next to every subscription on the Node Subscribe page.
• Live progress — see how many nodes have been tested, how many remain, and how much time has elapsed.
• Persistent results — saved to disk, so they survive a reboot.
• Non-invasive — never touches Passwall2 files, UCI configuration, or your nodes.
• Dynamic groups — groups are read automatically from UCI. Adding or removing subscriptions updates the list without any manual step.
• Low resource usage — tests one node at a time with a short timeout. Minimal CPU and RAM overhead.
• Stop button — cancel a running test at any moment.
• Simple uninstall — a single command removes every file added by this add-on. 
Requirements
Component Version
ImmortalWrt or OpenWrt 23.05 or newer
Passwall2 25.x or 26.x
Shell POSIX sh (BusyBox)
Dependencies None

 
Installation
 
Run the following command over SSH on your router:

wget -O /tmp/pw2nt-install.sh https://raw.githubusercontent.com/gooriltehran/pw2-node-tester/main/install.sh && sh /tmp/pw2nt-install.sh
 
Then open LuCI and refresh the page with Ctrl+F5.
 
Usage
1. Go to Services → Passwall 2 → Node Subscribe.
2. A small Test button appears next to each subscription.
3. Click it to test only that group.
4. Watch the live progress.
5. When the test finishes, a ranked list of nodes is displayed.
6. Click Stop at any moment to cancel. 
Uninstall
 
Run the following command over SSH on your router:

wget -O /tmp/pw2nt-uninstall.sh https://raw.githubusercontent.com/gooriltehran/pw2-node-tester/main/uninstall.sh && sh /tmp/pw2nt-uninstall.sh
 
Only the files added by this add-on are removed. Passwall2, its UCI configuration, and all of your nodes remain untouched.
 
Safety
• Does not edit any Passwall2 file.
• Does not touch /etc/config/passwall2.
• Does not modify node data, UUIDs, or subscription URLs.
• Does not restart Passwall2 or any network service.
• Only reads UCI to enumerate groups and calls Passwall2's official test.sh. 
File Locations
Path Purpose
/etc/pw2nt/ Persistent storage (results, state, logs)
/usr/libexec/pw2nt/ Worker and API scripts
/usr/lib/lua/luci/controller/pw2nt.lua LuCI controller
/www/luci-static/resources/pw2nt/ Frontend JavaScript files

 
 
Contributing
 
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change. 
 
License
 
Released under the MIT License. 
