#!/usr/bin/env bash
# EXHUME DISGUISE - BXP Native Edition
source ./bxp_libcore.sh

if ! command -v iw >/dev/null 2>&1; then
    echo -e "${R}[-] 'iw' tidak ditemukan. Install: pkg install iw${N}"; exit 1
fi

read -p "  ${Y}Interface (contoh: wlan0): ${N}" IFACE
echo -e "${C}[*] Memindai gelombang radio (Passive Scan)...${N}"

iw dev "$IFACE" scan 2>/dev/null | awk '
/^BSS/ { bssid=$2 }
/SSID:/ { ssid=$0; sub(/.*SSID: /, "", ssid) }
/signal:/ { 
    rssi=$2; 
    dist = exp(log(10) * ((-40 - rssi) / 25));
    if (ssid == "") ssid = "<Hidden>";
    if (dist < 5) { color = "\033[0;31m"; label = "[DEKAT]"; }
    else if (dist < 15) { color = "\033[1;33m"; label = "[SEDANG]"; }
    else { color = "\033[0;32m"; label = "[JAUH]"; }
    printf "%s%s %-20s | %s dBm | ~%.1f meter\033[0m\n", color, label, ssid, rssi, dist;
}'
