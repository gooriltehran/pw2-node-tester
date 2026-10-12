#!/bin/sh
# PW2 Node Tester - Non-invasive node latency tester for Passwall2
# https://github.com/gooriltehran/pw2-node-tester

set -eu

[ "$(id -u)" = 0 ] || { echo 'Run as root.'; exit 1; }
[ -f /etc/config/passwall2 ] || { echo 'Passwall2 not found.'; exit 1; }
[ -x /usr/share/passwall2/test.sh ] || { echo 'Passwall2 test.sh not found.'; exit 1; }

STORE=/etc/pw2nt
BIN=/usr/libexec/pw2nt
CTRL=/usr/lib/lua/luci/controller
STATIC=/www/luci-static/resources/pw2nt

mkdir -p "$STORE" "$BIN" "$CTRL" "$STATIC"
chmod 700 "$STORE"

# ═══════════════════════════════════════════════════════════════
# 1) worker.sh - Core testing logic
# ═══════════════════════════════════════════════════════════════
cat > "$BIN/worker.sh" <<'WORKER_EOF'
#!/bin/sh
set -u
STORE=/etc/pw2nt
STATE="$STORE/state"
RESULTS="$STORE/results.json"
LOCK="$STORE/lock"
STOP="$STORE/stop"
LOG="$STORE/worker.log"
TEST_SH=/usr/share/passwall2/test.sh
TIMEOUT=3
EXCLUDE_GROUPS="IR Block"

log() { echo "[$(date +%H:%M:%S)] $*" >> "$LOG" 2>/dev/null; }

list_groups() {
    {
        uci -q show passwall2 | while IFS= read -r line; do
            case "$line" in
                *'=subscribe_list')
                    sec=${line#passwall2.}; sec=${sec%=subscribe_list}
                    rem=$(uci -q get "passwall2.$sec.remark" 2>/dev/null || echo "")
                    [ -n "$rem" ] && echo "$rem"
                    ;;
            esac
        done
        uci -q show passwall2 | while IFS= read -r line; do
            case "$line" in
                *".group='"*)
                    g=${line#*group=\'}
                    g=${g%\'}
                    [ -n "$g" ] && echo "$g"
                    ;;
            esac
        done
    } | sort -u | while read -r g; do
        skip=0
        for ex in $EXCLUDE_GROUPS; do
            [ "$g" = "$ex" ] && skip=1
        done
        [ "$skip" = 0 ] && echo "$g"
    done
}

nodes_of() {
    group="$1"
    uci -q show passwall2 | while IFS= read -r line; do
        case "$line" in
            *"=nodes") sec=${line#passwall2.}; sec=${sec%=nodes}
                case "$sec" in *[!A-Za-z0-9_@\[\]-]*|'') continue;; esac
                g=$(uci -q get "passwall2.$sec.group" 2>/dev/null || true)
                [ "$g" = "$group" ] || continue
                printf '%s\n' "$sec"
                ;;
        esac
    done
}

test_group() {
    group="$1"
    
    if [ -f "$LOCK" ]; then
        pid=$(cat "$LOCK" 2>/dev/null || echo "")
        if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
            log "already running (pid $pid)"
            return 3
        fi
        rm -f "$LOCK"
    fi
    echo $$ > "$LOCK"
    rm -f "$STOP"
    trap 'rm -f "$LOCK" "$TMP"' EXIT INT TERM

    nodes=$(nodes_of "$group")
    total=$(printf '%s\n' "$nodes" | grep -c . || echo 0)
    
    if [ "$total" = 0 ]; then
        log "group=$group has no nodes"
        printf 'done\t%s\t%s\t0\t0\t%s\n' "$group" "$group" "$(date +%s)" > "$STATE"
        return 0
    fi
    
    log "start group=$group total=$total"
    printf 'running\t%s\t%s\t0\t%s\t%s\n' "$group" "$group" "$total" "$(date +%s)" > "$STATE"

    TMP="$STORE/.tmp.$$"
    : > "$TMP"
    printf '{\n  "group":"%s","total":%s,"started":%s,\n  "results":[' \
        "$group" "$total" "$(date +%s)" >> "$TMP"

    done=0
    first=1
    
    for id in $nodes; do
        [ -n "$id" ] || continue
        
        if [ -f "$STOP" ]; then
            log "stopped by user at $done/$total"
            break
        fi
        
        out=$(timeout "$TIMEOUT" "$TEST_SH" url_test_node "$id" 2>/dev/null | tail -n1 || echo "TIMEOUT")
        
        code=${out%%:*}
        elapsed=${out#*:}
        case "$code" in
            200|204) ok=1 ;;
            *) ok=0; elapsed=null ;;
        esac
        case "$elapsed" in
            ''|*[!0-9.]*) elapsed=null; ok=0 ;;
        esac
        [ "$ok" = 1 ] || elapsed=null

        remark=$(uci -q get "passwall2.$id.remarks" 2>/dev/null || echo "$id")
        idj=$(printf '%s' "$id" | sed 's/\\/\\\\/g; s/"/\\"/g')
        rj=$(printf '%s' "$remark" | tr '\t\r\n' '   ' | cut -c1-80 | sed 's/\\/\\\\/g; s/"/\\"/g')

        [ "$first" = 1 ] || printf ',' >> "$TMP"
        first=0
        if [ "$ok" = 1 ]; then
            printf '\n    {"id":"%s","name":"%s","ok":true,"seconds":%s}' \
                "$idj" "$rj" "$elapsed" >> "$TMP"
        else
            printf '\n    {"id":"%s","name":"%s","ok":false,"seconds":null}' \
                "$idj" "$rj" >> "$TMP"
        fi
        
        done=$((done + 1))
        printf 'running\t%s\t%s\t%s\t%s\t%s\n' "$group" "$group" "$done" "$total" "$(date +%s)" > "$STATE"
    done

    printf '\n  ]\n}\n' >> "$TMP"
    mv "$TMP" "$RESULTS"
    
    if [ -f "$STOP" ]; then
        printf 'stopped\t%s\t%s\t%s\t%s\t%s\n' "$group" "$group" "$done" "$total" "$(date +%s)" > "$STATE"
        log "stopped group=$group at $done/$total"
    else
        printf 'done\t%s\t%s\t%s\t%s\t%s\n' "$group" "$group" "$total" "$total" "$(date +%s)" > "$STATE"
        log "done group=$group total=$total"
    fi
    rm -f "$STOP"
}

case "${1:-}" in
    test)   test_group "${2:-}" ;;
    groups) list_groups ;;
    stop)   touch "$STORE/stop"; echo 'stopped' ;;
    *) echo "usage: $0 test GROUP | groups | stop" >&2; exit 2 ;;
esac
WORKER_EOF
chmod 755 "$BIN/worker.sh"

# ═══════════════════════════════════════════════════════════════
# 2) api.sh - JSON API for LuCI
# ═══════════════════════════════════════════════════════════════
cat > "$BIN/api.sh" <<'API_EOF'
#!/bin/sh
set -u
STORE=/etc/pw2nt

json_escape() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

case "${1:-}" in
    groups)
        printf '['
        first=1
        /usr/libexec/pw2nt/worker.sh groups | while read -r g; do
            [ -n "$g" ] || continue
            n=$(uci show passwall2 | grep -c "\.group='$g'" || echo 0)
            [ "$first" = 1 ] || printf ','
            first=0
            ge=$(json_escape "$g")
            printf '{"group":"%s","count":%s}' "$ge" "$n"
        done
        printf ']\n'
        ;;
    status)
        if [ -f "$STORE/state" ]; then
            IFS="$(printf '\t')" read -r st grp rem dn tot ts < "$STORE/state" || true
            printf '{"state":"%s","group":"%s","done":%s,"total":%s,"elapsed":%s}\n' \
                "${st:-idle}" "${grp:-}" "${dn:-0}" "${tot:-0}" \
                "$([ -n "${ts:-}" ] && echo $(( $(date +%s) - ts )) || echo 0)"
        else
            printf '{"state":"idle","group":"","done":0,"total":0,"elapsed":0}\n'
        fi
        ;;
    results)
        if [ -f "$STORE/results.json" ]; then
            cat "$STORE/results.json"
        else
            printf '{"group":"","total":0,"results":[]}\n'
        fi
        ;;
    stop)
        /usr/libexec/pw2nt/worker.sh stop
        ;;
    *) echo '{"error":"bad cmd"}' >&2; exit 2 ;;
esac
API_EOF
chmod 755 "$BIN/api.sh"

# ═══════════════════════════════════════════════════════════════
# 3) LuCI Controller
# ═══════════════════════════════════════════════════════════════
cat > "$CTRL/pw2nt.lua" <<'LUA_EOF'
module("luci.controller.pw2nt", package.seeall)
local http = require "luci.http"
local sys  = require "luci.sys"

function index()
    entry({"admin","services","passwall2","node_subscribe","pw2nt_test"},
          call("run_test")).leaf = true
    entry({"admin","services","passwall2","node_subscribe","pw2nt_status"},
          call("get_status")).leaf = true
    entry({"admin","services","passwall2","node_subscribe","pw2nt_results"},
          call("get_results")).leaf = true
    entry({"admin","services","passwall2","node_subscribe","pw2nt_groups"},
          call("get_groups")).leaf = true
    entry({"admin","services","passwall2","node_subscribe","pw2nt_stop"},
          call("do_stop")).leaf = true
end

local function json_out(s)
    http.prepare_content("application/json")
    http.write(s or "{}")
end

function run_test()
    local group = http.formvalue("group") or ""
    if not group:match("^[%w_%-%. ]+$") or #group > 64 then
        http.status(400, "Bad Request")
        return json_out('{"ok":false,"error":"invalid group"}')
    end
    local g = group:gsub("'", "")
    local cmd = string.format(
        "( /usr/libexec/pw2nt/worker.sh test '%s' >/dev/null 2>&1 & ) ; echo ok",
        g)
    sys.call(cmd)
    json_out('{"ok":true}')
end

function get_status()
    json_out(sys.exec("/usr/libexec/pw2nt/api.sh status 2>/dev/null") or "{}")
end
function get_results()
    json_out(sys.exec("/usr/libexec/pw2nt/api.sh results 2>/dev/null") or "{}")
end
function get_groups()
    json_out(sys.exec("/usr/libexec/pw2nt/api.sh groups 2>/dev/null") or "[]")
end
function do_stop()
    sys.call("/usr/libexec/pw2nt/api.sh stop >/dev/null 2>&1")
    json_out('{"ok":true}')
end
LUA_EOF

# ═══════════════════════════════════════════════════════════════
# 4) JS injection for Node Subscribe page
# ═══════════════════════════════════════════════════════════════
cat > "$STATIC/inject.js" <<'JS_EOF'
(function(){
  'use strict';
  if(window.__pw2nt) return;
  window.__pw2nt = true;

  var BASE = '/cgi-bin/luci/admin/services/passwall2/node_subscribe/';
  var API = {
    groups:  BASE + 'pw2nt_groups',
    test:    BASE + 'pw2nt_test',
    status:  BASE + 'pw2nt_status',
    results: BASE + 'pw2nt_results',
    stop:    BASE + 'pw2nt_stop'
  };
  var timers = {};

  function esc(s){return String(s==null?'':s).replace(/[&<>"']/g,function(c){
    return {'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'}[c];});}

  function xhrGet(url, cb){
    var x = new XMLHttpRequest();
    x.open('GET', url, true);
    x.setRequestHeader('X-Requested-With','XMLHttpRequest');
    x.onreadystatechange = function(){
      if(x.readyState===4){ var d=null; try{ d=JSON.parse(x.responseText); }catch(e){} cb(d); }
    };
    x.send();
  }
  function xhrPost(url, body, cb){
    var x = new XMLHttpRequest();
    x.open('POST', url, true);
    x.setRequestHeader('Content-Type','application/x-www-form-urlencoded');
    x.setRequestHeader('X-Requested-With','XMLHttpRequest');
    x.onreadystatechange = function(){
      if(x.readyState===4){ var d=null; try{ d=JSON.parse(x.responseText); }catch(e){} cb(d); }
    };
    x.send(body);
  }

  function makeBtn(label, cls){
    var b = document.createElement('button');
    b.className = 'cbi-button cbi-button-' + (cls||'action');
    b.textContent = label;
    b.style.cssText = 'margin-left:8px;padding:3px 14px;font-size:12px;vertical-align:middle;';
    return b;
  }

  function ensurePanel(row){
    var panel = row.querySelector('.pw2nt-panel');
    if(panel) return panel;
    panel = document.createElement('div');
    panel.className = 'pw2nt-panel';
    panel.style.cssText = 'margin:8px 0 0 0;padding:10px 12px;' +
      'background:#f0f4f8;border-left:3px solid #2196F3;border-radius:4px;' +
      'font-size:12px;line-height:1.6;';
    var parent = row.parentNode;
    var next = row.nextSibling;
    parent.insertBefore(panel, next);
    return panel;
  }

  function renderRunning(panel, group, done, total, elapsed){
    var pct = total > 0 ? Math.round(done*100/total) : 0;
    var bar = '';
    for(var i=0;i<20;i++){ bar += (i < Math.round(pct/5)) ? '▓' : '░'; }
    panel.innerHTML =
      '<div style="display:flex;justify-content:space-between;align-items:center;">' +
        '<span><b>' + esc(group) + '</b> — Testing ' +
          '<b>' + done + '/' + total + '</b> ' +
          '<span style="color:#666;">(' + elapsed + 's)</span></span>' +
        '<button class="cbi-button cbi-button-reset pw2nt-stop" ' +
          'style="padding:2px 10px;font-size:11px;">Stop</button>' +
      '</div>' +
      '<div style="font-family:monospace;color:#2196F3;margin-top:4px;">' + bar + ' ' + pct + '%</div>';
    var stopBtn = panel.querySelector('.pw2nt-stop');
    if(stopBtn){
      stopBtn.onclick = function(ev){
        ev.preventDefault();
        stopBtn.disabled = true;
        stopBtn.textContent = '...';
        xhrPost(API.stop, '', function(){});
      };
    }
  }

  function renderResults(panel, group, data){
    if(!data || !data.results){
      panel.innerHTML = '<b>' + esc(group) + '</b> — No results.';
      return;
    }
    var ok = data.results.filter(function(r){return r.ok;})
                          .sort(function(a,b){return a.seconds - b.seconds;});
    var failed = data.results.length - ok.length;
    
    var html = '<div style="margin-bottom:6px;">' +
      '<b>' + esc(group) + '</b> — Total: ' + data.total +
      ' | <span style="color:#2e7d32;">OK: ' + ok.length + '</span>' +
      (failed ? ' | <span style="color:#c62828;">Failed: ' + failed + '</span>' : '') +
      ' <a href="#" class="pw2nt-clear" style="float:right;font-size:11px;color:#888;">Close</a>' +
      '</div>';
    
    if(ok.length){
      html += '<table style="width:100%;font-size:11px;border-collapse:collapse;">';
      html += '<thead><tr style="background:#e3f2fd;">' +
        '<th style="padding:3px;text-align:left;">#</th>' +
        '<th style="padding:3px;text-align:left;">Name</th>' +
        '<th style="padding:3px;text-align:left;">Seconds</th></tr></thead><tbody>';
      ok.slice(0, 30).forEach(function(r, i){
        var color = i < 3 ? 'background:#e8f5e9;' : '';
        html += '<tr style="'+color+'border-bottom:1px solid #eee;">' +
          '<td style="padding:3px;">' + (i+1) + '</td>' +
          '<td style="padding:3px;">' + esc(r.name) + '</td>' +
          '<td style="padding:3px;">' + Number(r.seconds).toFixed(3) + '</td></tr>';
      });
      html += '</tbody></table>';
    } else {
      html += '<div style="color:#c62828;">No nodes responded.</div>';
    }
    
    panel.innerHTML = html;
    var clear = panel.querySelector('.pw2nt-clear');
    if(clear) clear.onclick = function(ev){ ev.preventDefault(); panel.remove(); };
  }

  function pollGroup(group, panel){
    if(timers[group]) clearTimeout(timers[group]);
    xhrGet(API.status, function(d){
      if(!d) { timers[group] = setTimeout(function(){pollGroup(group,panel);},1500); return; }
      
      if(d.state === 'running' && d.group === group){
        renderRunning(panel, group, d.done, d.total, d.elapsed);
        timers[group] = setTimeout(function(){pollGroup(group,panel);}, 1000);
      } else if(d.state === 'running' && d.group !== group){
        panel.innerHTML = '<em style="color:#888;">Waiting... (group ' + esc(d.group) + ' is testing)</em>';
        timers[group] = setTimeout(function(){pollGroup(group,panel);}, 2000);
      } else {
        delete timers[group];
        xhrGet(API.results, function(r){ renderResults(panel, group, r); });
      }
    });
  }

  function startTest(group, btn, row){
    var existing = row.nextElementSibling;
    if(existing && existing.classList.contains('pw2nt-panel')){ existing.remove(); }
    var panel = ensurePanel(row);
    panel.innerHTML = '<em>Starting...</em>';
    
    xhrPost(API.test, 'group=' + encodeURIComponent(group), function(resp){
      if(!resp || !resp.ok){
        panel.innerHTML = '<span style="color:#c62828;">Error: ' + esc((resp && resp.error) || 'Failed') + '</span>';
        return;
      }
      btn.disabled = true;
      btn.textContent = 'Testing...';
      pollGroup(group, panel);
      var checkDone = setInterval(function(){
        xhrGet(API.status, function(d){
          if(d && d.state !== 'running' && d.group === group){
            clearInterval(checkDone);
            btn.disabled = false;
            btn.textContent = 'Test again';
          }
        });
      }, 2000);
    });
  }

  function inject(){
    xhrGet(API.groups, function(groups){
      if(!groups || !groups.length) return;
      var rows = document.querySelectorAll('.cbi-section-table-row');
      rows.forEach(function(row){
        if(row.querySelector('.pw2nt-btn')) return;
        if(row.querySelector('.pw2nt-panel')) return;
        var text = (row.textContent || '').trim();
        var matched = null;
        for(var i=0;i<groups.length;i++){
          if(text.indexOf(groups[i].group) !== -1){ matched = groups[i]; break; }
        }
        if(!matched) return;
        var btn = makeBtn('Test (' + matched.count + ')');
        btn.classList.add('pw2nt-btn');
        btn.onclick = function(ev){ ev.preventDefault(); ev.stopPropagation(); startTest(matched.group, btn, row); };
        var target = row.querySelector('.cbi-value-title') || row.querySelector('td:first-child') || row;
        target.appendChild(btn);
      });
    });
  }

  var mo = new MutationObserver(function(){
    if(mo._t) clearTimeout(mo._t);
    mo._t = setTimeout(inject, 400);
  });
  mo.observe(document.body, {childList:true, subtree:true});
  [500, 1500, 3000, 5000].forEach(function(t){ setTimeout(inject, t); });
})();
JS_EOF

# ═══════════════════════════════════════════════════════════════
# 5) JS Injector Controller
# ═══════════════════════════════════════════════════════════════
cat > "$CTRL/pw2nt_inject.lua" <<'INJ_EOF'
module("luci.controller.pw2nt_inject", package.seeall)

function index()
    entry({"admin","services","passwall2","node_subscribe","pw2nt_inject.js"},
          call("serve")).leaf = true
end

function serve()
    local http = require "luci.http"
    http.prepare_content("application/javascript")
    http.write([[
(function(){
  if(window.__pw2nt_loader) return;
  window.__pw2nt_loader = true;
  var s = document.createElement('script');
  s.src = '/luci-static/resources/pw2nt/inject.js?v=' + Date.now();
  document.head.appendChild(s);
})();
]])
end
INJ_EOF

rm -f /tmp/luci-indexcache 2>/dev/null || true

echo ''
echo '═══════════════════════════════════════════════════════════════'
echo ' PW2 Node Tester installed'
echo '═══════════════════════════════════════════════════════════════'
echo ''
echo ' Open LuCI → Services → Passwall 2 → Node Subscribe'
echo ''
echo '═══════════════════════════════════════════════════════════════'
