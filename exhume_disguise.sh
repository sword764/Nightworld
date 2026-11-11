#!/usr/bin/env bash
# ============================================
#   EXHUME DISGUISE - Hidden SSID Scanner
#   Night World Module v1.0
# ============================================

if [ -f "./bxp_libcore.sh" ]; then
    source ./bxp_libcore.sh
else
    echo -e "\033[0;31m[!] Core library not found!\033[0m"
    exit 1
fi

TOOL_NAME="EXHUME DISGUISE"

main_menu() {
    clear
    bxp_ascii_title "$TOOL_NAME"
    
    echo -e "${C}  ==================================================${N}"
    echo -e "  ${Y}OS      : ${W}${OS_NAME:-Unknown}${N}"
    echo -e "  ${Y}Device  : ${W}${DEV_MODEL:-Unknown}${N}"
    echo -e "  ${Y}Access  : ${W}${ROOT_STATUS:-Unknown}${N}"
    echo -e "${C}  ==================================================${N}"
    echo ""

    echo -e "  ${G}[1]${N} Scan Hidden SSID (Native Termux)"
    echo -e "  ${G}[2]${N} Sniff Probe Requests (Requires Root)"
    echo -e "  ${R}[0]${N} Back to Main Menu"
    echo ""
    echo -e "${C}  --------------------------------------------------${N}"
    echo ""
    echo -ne "  ${Y}Select option > ${N}"
    read -r opt

    case "$opt" in
        1) scan_hidden ;;
        2) sniff_probe ;;
        0) exit 0 ;;
        *) echo -e "  ${R}[!] Invalid option.${N}"; sleep 1; main_menu ;;
    esac
}

scan_hidden() {
    clear
    bxp_ascii_title "$TOOL_NAME"
    echo -e "  ${G}[*] Initializing Wi-Fi scanner...${N}"
    sleep 1
    
    if command -v termux-wifi-scaninfo >/dev/null 2>&1; then
        echo -e "  ${G}[*] Scanning for networks...${N}"
        sleep 2
        
        echo -e "\n  ${W}--- SCAN RESULTS ---${N}"
        echo -e "  ${G}[+] Active networks found. Checking for hidden SSIDs...${N}"
        echo -e "  ${Y}[!] Note: Real-time parsing requires JSON parsing tool (jq).${N}"
        echo -e "  ${C}[*] (Placeholder for actual SSID output)${N}"
        echo -e "  ${C}[*] Hidden networks usually show blank SSID or <unknown>.${N}"
    else
        echo -e "\n  ${R}[!] termux-api is not installed.${N}"
        echo -e "  ${Y}[*] Run: pkg install termux-api${N}"
    fi
    
    echo ""
    read -p "  Press Enter to return..."
    main_menu
}

sniff_probe() {
    clear
    bxp_ascii_title "$TOOL_NAME"
    echo -e "  ${G}[*] Checking monitor mode capability...${N}"
    sleep 1
    
    if [ "$ROOT_STATUS" = "Root" ] || [ "$ROOT_STATUS" = "Root (su available)" ]; then
        if command -v iw >/dev/null 2>&1; then
            echo -e "  ${G}[+] Root access granted. Monitor mode available.${N}"
            echo -e "  ${Y}[*] (Placeholder: Start probe request sniffer here)${N}"
        else
            echo -e "  ${R}[!] 'iw' package not found.${N}"
        fi
    else
        echo -e "  ${R}[!] Monitor mode requires root privileges.${N}"
        echo -e "  ${Y}[*] Current access: ${ROOT_STATUS}${N}"
    fi
    
    echo ""
    read -p "  Press Enter to return..."
    main_menu
}

main_menu
