#!/usr/bin/env bash
# RECLAIM CATCH - BXP Native Edition
source ./bxp_libcore.sh

bxp_boot_sequence "RECLAIM CATCH" "dd grep hexdump"

read -p "  ${Y}Interface (contoh: wlan0): ${N}" IFACE
OUT_FILE="handshake_bxp_$(date +%s).pcap"

echo -e "${C}[*] Menunggu Handshake (EAPOL)... (CTRL+C Stop)${N}"

# PCAP Global Header murni pakai printf hex
printf '\xd4\xc3\xb2\xa1\x02\x00\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\x00\x00\x01\x00\x00\x00' > "$OUT_FILE"

# Loop baca raw socket murni
while true; do
    # Baca 65535 byte dari raw interface (butuh root)
    dd if="/dev/$IFACE" bs=65535 count=1 2>/dev/null | grep -a -q $'\x88\x8e' && {
        echo -e "${G}[+] EAPOL Tertangkap!${N}"
        # Append paket ke pcap (murni)
        dd if="/dev/$IFACE" bs=65535 count=1 >> "$OUT_FILE" 2>/dev/null
    }
    sleep 0.1
done
