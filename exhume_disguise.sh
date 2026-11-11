#!/usr/bin/env bash
# ============================================
#   EXHUME DISGUISE - Hidden SSID Scanner
#   Fixed Parser & Better UI
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

    echo -e "  ${G}[1]${N} Scan Wi-Fi Networks"
    echo -e "  ${R}[0]${N} Back to Main Menu"
    echo ""
    echo -e "${C}  --------------------------------------------------${N}"
    echo ""
    echo -ne "  ${Y}Select option > ${N}"
    read -r opt

    case "$opt" in
        1) scan_hidden ;;
        0) exit 0 ;;
        *) echo -e "  ${R}[!] Invalid option.${N}"; sleep 1; main_menu ;;
    esac
}

scan_hidden() {
    clear
    bxp_ascii_title "$TOOL_NAME"
    echo -e "  ${G}[*] Initializing Wi-Fi scanner...${N}"
    sleep 1
    
    # REAL CHECK: termux-api & jq
    if ! command -v termux-wifi-scaninfo >/dev/null 2>&1; then
        echo -e "\n  ${R}[!] termux-api is NOT installed.${N}"
        echo -e "  ${Y}[*] Run: pkg install termux-api${N}"
        echo -e "  ${Y}[*] Make sure Termux:API app is installed from F-Droid.${N}"
        read -p "  Press Enter to return..."
        main_menu
    fi

    if ! command -v jq >/dev/null 2>&1; then
        echo -e "\n  ${R}[!] 'jq' is NOT installed.${N}"
        echo -e "  ${Y}[*] Run: pkg install jq${N}"
        read -p "  Press Enter to return..."
        main_menu
    fi

    echo -e "  ${G}[*] Scanning nearby networks (Real-time)...${N}"
    RAW_SCAN=$(termux-wifi-scaninfo 2>/dev/null)
    
    # Validasi jika kosong atau bukan JSON
    if [ -z "$RAW_SCAN" ] || [ "$RAW_SCAN" = "[]" ] || [ "$RAW_SCAN" = "{}" ]; then
        echo -e "\n  ${R}[!] No networks found, or Wi-Fi is turned off.${N}"
        echo -e "  ${Y}[*] Make sure Location (GPS) is ON and permission granted.${N}"
        read -p "  Press Enter to return..."
        main_menu
    fi

    echo -e "  ${G}[+] Scan complete. Parsing results...${N}"
    sleep 1
    echo ""
    echo -e "  ${W}--- SCAN RESULTS ---${N}"
    echo -e "  ${C}--------------------------------------------------------${N}"
    printf "  \033[1;37m%-20s | %-18s | %-6s\033[0m\n" "SSID" "BSSID" "SIGNAL"
    echo -e "  ${C}--------------------------------------------------------${N}"

    # FIXED PARSER: Deteksi format Array ([]) atau Object ({})
    echo "$RAW_SCAN" | jq -r '
        (if type == "array" then .[] else . end) | 
        "\(if .SSID == null or .SSID == "" then "<Hidden SSID>" else .SSID end)\t| \(.BSSID)\t| \(.RSSI // .level // "N/A")"
    ' 2>/dev/null | while IFS= read -r line; do
        SSID=$(echo "$line" | cut -f1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        REST=$(echo "$line" | cut -f2-)
        
        if [ "$SSID" = "<Hidden SSID>" ]; then
            printf "  \033[0;31m%-20s\033[0m | %s\n" "$SSID" "$REST"
        else
            printf "  \033[0;32m%-20s\033[0m | %s\n" "$SSID" "$REST"
        fi
    done

    echo -e "  ${C}--------------------------------------------------------${N}"
    echo ""
    read -p "  Press Enter to return..."
    main_menu
}

main_menu
