#!/bin/sh
# PW2 Node Tester - Uninstaller
# https://github.com/gooriltehran/pw2-node-tester

set -u

if [ "$(id -u)" != "0" ]; then
    echo "Run as root."
    exit 1
fi

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo " Removing PW2 Node Tester"
echo "═══════════════════════════════════════════════════════════════"
echo ""

if [ -f /etc/pw2nt/lock ]; then
    PID=$(cat /etc/pw2nt/lock 2>/dev/null || echo "")
    if [ -n "$PID" ] && kill -0 "$PID" 2>/dev/null; then
        echo "Stopping worker (PID $PID)..."
        kill "$PID" 2>/dev/null || true
        sleep 1
        kill -9 "$PID" 2>/dev/null || true
    fi
fi

FILES_REMOVED=0
DIRS_REMOVED=0

for f in /usr/lib/lua/luci/controller/pw2nt.lua \
         /usr/lib/lua/luci/controller/pw2nt_inject.lua; do
    if [ -f "$f" ]; then
        rm -f "$f" && echo "  Removed: $f"
        FILES_REMOVED=$((FILES_REMOVED + 1))
    else
        echo "  Not found: $f"
    fi
done

for d in /usr/libexec/pw2nt \
         /etc/pw2nt \
         /www/luci-static/resources/pw2nt; do
    if [ -d "$d" ]; then
        rm -rf "$d" && echo "  Removed: $d/"
        DIRS_REMOVED=$((DIRS_REMOVED + 1))
    else
        echo "  Not found: $d/"
    fi
done

echo ""
echo "Clearing LuCI cache..."
rm -f /tmp/luci-indexcache 2>/dev/null || true
rm -rf /tmp/luci-modulecache/* 2>/dev/null || true

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo " Uninstall complete"
echo "═══════════════════════════════════════════════════════════════"
echo "   Files removed: $FILES_REMOVED"
echo "   Directories removed: $DIRS_REMOVED"
echo ""
echo " Passwall 2 and your configuration are untouched."
echo " Refresh your browser (Ctrl+F5) to apply changes."
echo "═══════════════════════════════════════════════════════════════"
