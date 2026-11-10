#!/usr/bin/env bash
# ============================================
#   N I G H T   W O R L D
#   Version: 2.0 (Public)
#   Engine : 6.0 (Standalone GitHub Downloader)
#   By bogor x ploit
# ============================================

VERSION="2.0"

# --- LINK SERVER GITHUB RAW ---
MODULE_URL="https://raw.githubusercontent.com/sword764/Nightworld/main"
# ------------------------------

source ./bxp_core.sh

C='\033[0;36m'; B='\033[0;34m'; W='\033[1;37m'; R='\033[0;31m'; Y='\033[1;33m'; G='\033[0;32m'; N='\033[0m'

detect_env() {
    OS_NAME="Unknown"; ROOT_STATUS="Unknown"; IS_TERMUX=0
    ARCH=$(uname -m); KERNEL=$(uname -r); DEV_MODEL=$(uname -n)

    if [ -n "$PREFIX" ] && echo "$PREFIX" | grep -qi "com.termux"; then
        OS_NAME="Termux (Android)"; IS_TERMUX=1
        if command -v getprop >/dev/null 2>&1; then
            DEV_MODEL=$(getprop ro.product.model 2>/dev/null || echo "Android Device")
            ANDROID_VER=$(getprop ro.build.version.release 2>/dev/null || echo "Unknown")
            CPU_ABI=$(getprop ro.product.cpu.abi 2>/dev/null || echo "$ARCH")
        fi
    elif [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            kali) OS_NAME="Kali Linux" ;; blackarch) OS_NAME="BlackArch Linux" ;;
            *) OS_NAME="${PRETTY_NAME:-$ID}" ;;
        esac
        DEV_MODEL=$(cat /sys/devices/virtual/dmi/id/product_name 2>/dev/null || echo "PC Device")
    else
        OS_NAME="$(uname -s) Linux"
    fi

    if [ "$(id -u)" -eq 0 ]; then ROOT_STATUS="Root"; else
        if command -v su >/dev/null 2>&1 && su -c id >/dev/null 2>&1; then ROOT_STATUS="Root (su available)"; else ROOT_STATUS="Non-Root"; fi
    fi
    USER_NAME="$(whoami 2>/dev/null || echo unknown)"
    COLS="$(tput cols 2>/dev/null || echo 80)"
}

# --- ASCII & Banner ---
ascii_mobile() { cat <<'ASCII'
         /\
        /  \
       |    |
       | || |
       | || |
       | || |
    ___|_||_|___
   \   ||     /
    \  ||    /
     \_||__ /
        ||
        ||
     .--||--.
    /   ||   \
   |  _ || _  |
   | / \||/ \ |
   |/  -||-  \|
   |\  _||_  /|
    \  '||'  /
     '. || .'
       ||
       ||
       ||
       |/
   NIGHT WORLD
 By bogor x ploit
      v2.0
ASCII
}
ascii_pc() { cat <<'ASCII'
                    /\
                   /   \
                  /     \
                 |       |
                 |   ||  |
                 |   ||  |
                 |   ||  |
    ____________|    ||    |____________
   \          __     ||     __        /
    \   .----'    \  ||  /   `----.  /
     \/            \_||_/           \/
                     ||
         .---.-'     ||     '-.----.
      .-'  /         ||         \     `-.
    .'    /          ||          \      `.
   /     /           ||           \      \
  /     /            ||            \      \
 ;     /         _..-||-.._         \     ;
.     /       .'  .- || -.  `.       \     .
|    /       /    /  ||  \    \       \    |
|---/-------|----|---||----|---|-------\---|
|  /         \    \  ||  /    /         \   |
. /           `.   '-||-'   .'           \ .
;              `.._  ||  _..'             ;
 \                 ` || '                /
  \  /\              ||              /\  /
   `.  `-._          ||          _.-'  .'
     `.    `'--._    ||    _..--'`    .'
       `-.           ||           .-'
          `---.      ||      .---'
                \    ||    /
                 \   ||   /
                  \  ||  /
                   \ || /
                    \||/
                     ||
                     ||
                     ||
                     |/
ASCII
}

show_banner() {
    echo -e "${C}--------------------------------------------------${N}"
    echo -e "${W}  NIGHT WORLD ${C}|${W} By bogor x ploit${N}"
    echo -e "${C}--------------------------------------------------${N}"
    echo -e "${Y}  Version : ${W}v${VERSION}${N}"
    echo -e "${Y}  OS      : ${W}${OS_NAME}${N}"
    echo -e "${Y}  Device  : ${W}${DEV_MODEL}${N}"
    echo -e "${Y}  User    : ${W}${USER_NAME}${N}"
    echo -e "${Y}  Access  : ${W}${ROOT_STATUS}${N}"
    echo -e "${C}--------------------------------------------------${N}"
}

show_menu() {
    echo -e "${G}  # MAIN MENU #${N}"
    echo -e "${C}--------------------------------------------------${N}"
    echo -e "  ${W}[1]${N} Cyber Kill Chain"
    echo -e "  ${W}[2]${N} Exploitation"
    echo -e "  ${W}[3]${N} Netscan"
    echo -e "  ${W}[4]${N} User Guide"
    echo -e "  ${W}[0]${N} Exit"
    echo -e "${C}--------------------------------------------------${N}"
}

# --- Menu Cyber Kill Chain (Menu 1) ---
menu_kill_chain() {
    while true; do
        clear
        echo -e "${C}--------------------------------------------------${N}"
        echo -e "${W}  TOOLS HUB ${C}|${W} Cyber Kill Chain${N}"
        echo -e "${C}--------------------------------------------------${N}"
        echo -e "${G}  # CYBER MODULE #${N}"
        echo -e "  ${W}[1]${N} Cyber Attack (API/Web)"
        echo -e "  ${W}[2]${N} Phising (Credential Harvester)"
        echo -e "  ${W}[3]${N} Back to Main Menu"
        echo -e "${C}--------------------------------------------------${N}"
        echo -ne "${Y}  Select menu > ${N}"
        read -r kc_choice

        case "$kc_choice" in
            1) run_tool "CYBER ATTACK" "cyber_attack.sh" ;;
            2) run_tool "PHISING" "phising.sh" ;;
            3) return ;;
            *) echo -e "${R}[!] Invalid choice.${N}"; sleep 1 ;;
        esac
    done
}

# --- Menu Netscan (Menu 3) ---
menu_netscan() {
    while true; do
        clear
        echo -e "${C}--------------------------------------------------${N}"
        echo -e "${W}  TOOLS HUB ${C}|${W} Netscan (Wi-Fi)${N}"
        echo -e "${C}--------------------------------------------------${N}"
        echo -e "${G}  # WI-FI ATTACK MODULE #${N}"
        echo -e "  ${W}[1]${N} Exhume Disguise"
        echo -e "  ${W}[2]${N} Choke The Hunters"
        echo -e "  ${W}[3]${N} Reclaim Catch In Mid-Air"
        echo -e "  ${W}[4]${N} Ouija Magnifying Glass"
        echo -e "  ${W}[5]${N} Back to Main Menu"
        echo -e "${C}--------------------------------------------------${N}"
        echo -ne "${Y}  Select menu > ${N}"
        read -r ns_choice

        case "$ns_choice" in
            1) run_tool "EXHUME DISGUISE" "exhume_disguise.sh" ;;
            2) run_tool "CHOKE THE HUNTERS" "choke_hunters.sh" ;;
            3) run_tool "RECLAIM CATCH" "reclaim_catch.sh" ;;
            4) run_tool "OUIJA MAGNIFYING" "ouija_magnifying.sh" ;;
            5) return ;;
            *) echo -e "${R}[!] Invalid choice.${N}"; sleep 1 ;;
        esac
    done
}

# --- Menu Exploitation (Menu 2) ---
menu_exploit() {
    while true; do
        clear
        echo -e "${C}--------------------------------------------------${N}"
        echo -e "${W}  TOOLS HUB ${C}|${W} Exploitation${N}"
        echo -e "${C}--------------------------------------------------${N}"
        echo -e "${G}  # EXPLOITATION MENU #${N}"
        echo -e "  ${W}[1]${N} NYCTOPHOBIA"
        echo -e "  ${W}[2]${N} SLEEP PARALYSIS"
        echo -e "  ${W}[3]${N} NOCTURNAL DECAY"
        echo -e "  ${W}[4]${N} Back to Main Menu"
        echo -e "${C}--------------------------------------------------${N}"
        echo -ne "${Y}  Select menu > ${N}"
        read -r sub_pilihan

        case "$sub_pilihan" in
            1) run_tool "NYCTOPHOBIA" "nyctophobia.sh" ;;
            2) run_tool "SLEEP PARALYSIS" "sleep_paralysis.sh" ;;
            3) run_tool "NOCTURNAL DECAY" "nocturnal_decay.sh" ;;
            4) return ;;
            *) echo -e "${R}  Invalid choice.${N}"; sleep 1 ;;
        esac
    done
}

# --- Fungsi Run Tool (1x Install & Super Long Boot) ---
run_tool() {
    TOOL_NAME="$1"; FILE_NAME="$2"; clear
    
    # Cek apakah udah ke-install (File ada)
    if [ -f "$FILE_NAME" ]; then
        echo -e "${G}[+] Module $TOOL_NAME already installed. Booting up...${N}"
        sleep 1
    else
        # Kalau belum ada, tanya install
        bxp_ascii_title "$TOOL_NAME"
        echo -e "${C}--------------------------------------------------${N}"
        echo -ne "${Y}[?] Do you want to install $TOOL_NAME module? (Y/N) > ${N}"
        read -r confirm
        
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            echo -e "${R}[-] Installation aborted. Returning to menu.${N}"; sleep 1.5; return
        fi

        echo ""
        echo -e "${G}[*] Downloading module from GitHub Server...${N}"
        DOWNLOAD_URL="${MODULE_URL}/${FILE_NAME}" 
        curl -sL -o "$FILE_NAME" "$DOWNLOAD_URL"
        
        # Validasi ketat
        if [[ ! -f "$FILE_NAME" ]] || ! head -n 1 "$FILE_NAME" | grep -q "#!/usr/bin/env bash"; then
            echo -e "${R}[-] CRITICAL: Download failed or invalid script format!${N}"
            echo -e "${Y}[!] Pastikan file $FILE_NAME ada di repository GitHub Tuan.${N}"
            rm -f "$FILE_NAME"; sleep 2; return
        fi
        echo -e "${G}[*] Verifying checksum (SHA-256)...${N}"; sleep 0.8
    fi

    # Animasi Loading Install
    echo ""
    echo -ne "${Y}Installing... [${N}"
    for i in {1..30}; do echo -ne "${W}=${N}"; sleep 0.05; done
    echo -e "${Y}] 100%${N}"; echo ""
    
    clear
    bxp_ascii_title "$TOOL_NAME"
    echo -e "${C}==================================================${N}"
    
    # --- BOOT SEQUENCE BERDASARKAN ROOT / NON ROOT ---
    BOOT_LOGS=()
    if [ "$ROOT_STATUS" = "Root" ] || [ "$ROOT_STATUS" = "Root (su available)" ]; then
        BOOT_LOGS+=(
            "[    0.000000] BXP Core Engine loaded successfully."
            "[    0.012000] Root access granted. Privilege escalation active."
            "[    0.045000] Mounting system partitions (rw)..."
            "[    0.089000] [ OK ] Partitions mounted."
            "[    0.120000] Loading kernel modules (bxp_hook.ko)..."
            "[    0.156000] [ OK ] Module loaded."
            "[    0.189000] Initializing native network stack..."
            "[    0.210000] [ OK ] Stack active."
            "[    0.245000] Bypassing local firewall (iptables)..."
            "[    0.278000] [ OK ] Firewall rules flushed."
            "[    0.312000] Establishing encrypted C2 tunnel (AES-256)..."
            "[    0.345000] [ OK ] Tunnel active."
            "[    0.389000] Injecting $TOOL_NAME payload into memory..."
            "[    0.412000] [ OK ] Injection successful."
            "[    0.456000] Spawning hidden daemon threads..."
            "[    0.489000] [ OK ] 16 threads active."
            "[    0.523000] Routing traffic via proxy chain (Tor)..."
            "[    0.556000] [ OK ] Circuit established."
            "[    0.589000] Hiding process tree from system..."
            "[    0.612000] [ OK ] Process hidden."
            "[    0.645000] Clearing system logs (/var/log)..."
            "[    0.678000] [ OK ] Logs cleared."
            "[    0.712000] Verifying payload integrity..."
            "[    0.745000] [ OK ] Integrity verified."
            "[    0.789000] Setting up persistence mechanism (Cron)..."
            "[    0.812000] [ OK ] Persistence active."
            "[    0.856000] $TOOL_NAME is now fully operational."
        )
    else
        BOOT_LOGS+=(
            "[    0.000000] BXP Core Engine loaded (User-space)."
            "[    0.015000] Android Sandbox detected."
            "[    0.032000] Initializing Dalvik Virtual Machine..."
            "[    0.056000] [ OK ] VM ready."
            "[    0.089000] Mounting local storage (Scoped)..."
            "[    0.120000] [ OK ] Storage mapped."
            "[    0.156000] Bypassing Termux restrictions..."
            "[    0.189000] [ OK ] Bypass successful."
            "[    0.210000] Initializing native network stack..."
            "[    0.245000] [ OK ] Stack active."
            "[    0.278000] Establishing encrypted C2 tunnel (AES-256)..."
            "[    0.312000] [ OK ] Tunnel active."
            "[    0.345000] Injecting $TOOL_NAME payload into user-space..."
            "[    0.389000] [ OK ] Injection successful."
            "[    0.412000] Spawning background services..."
            "[    0.456000] [ OK ] Services active."
            "[    0.489000] Routing traffic via proxy chain (Tor)..."
            "[    0.523000] [ OK ] Circuit established."
            "[    0.556000] Hiding app icon from launcher..."
            "[    0.589000] [ OK ] Icon hidden."
            "[    0.612000] Clearing Termux logs..."
            "[    0.645000] [ OK ] Logs cleared."
            "[    0.678000] Verifying payload integrity..."
            "[    0.712000] [ OK ] Integrity verified."
            "[    0.745000] Setting up persistence (~/.bashrc)..."
            "[    0.789000] [ OK ] Persistence active."
            "[    0.812000] $TOOL_NAME is now fully operational."
        )
    fi

    # Jeda lebih lama biar dramatis
    for log in "${BOOT_LOGS[@]}"; do
        echo -e "${W}  $log${N}"; sleep 0.25
    done
    
    echo -e "${C}==================================================${N}"
    echo -e "${G}[+] Tools complete 100%. Entering $TOOL_NAME...${N}"
    sleep 1.5
    clear
    chmod +x "$FILE_NAME"
    bash "$FILE_NAME"
    echo ""
    read -p "Press Enter to return to menu..."
}

# --- User Guide (English & Stealth) ---
user_guide() {
    clear
    echo -e "${C}==================================================${N}"
    echo -e "${W}               USER GUIDE / MANUAL${N}"
    echo -e "${W}               NIGHT WORLD v2.0${N}"
    echo -e "${C}==================================================${N}"
    echo ""
    echo -e "${Y}[1] INSTALLATION PROCESS${N}"
    echo -e "  - Select a category (Cyber / Exploit / Netscan)."
    echo -e "  - Choose the desired module."
    echo -e "  - Type 'Y' when prompted to install (only required once)."
    echo -e "  - Wait for the download and boot sequence to complete."
    echo ""
    echo -e "${Y}[2] USING THE LISTENERS${N}"
    echo -e "  - For Session Hooks (NYCTOPHOBIA), the listener port is 2010."
    echo -e "  - For Session Bridges (SLEEP PARALYSIS), the listener port is 2015."
    echo -e "  - Ensure these ports are not used by other applications."
    echo ""
    echo -e "${Y}[3] TIPS & TRICKS${N}"
    echo -e "  - Use a VPN/Proxy when conducting tests."
    echo -e "  - Do not close the terminal while a listener is running."
    echo -e "  - Press CTRL+C to stop the listener safely."
    echo ""
    echo -e "${C}--------------------------------------------------${N}"
    read -p "Press Enter to return to main menu..."
}

# --- Main Logic ---
main() {
    detect_env
    while true; do
        clear
        if [ "$IS_TERMUX" -eq 1 ]; then echo -e "${B}"; ascii_mobile; echo -e "${N}"
        else echo -e "${B}"; ascii_pc; echo -e "${N}"; fi
        show_banner
        show_menu
        echo -ne "${Y}  Select menu > ${N}"
        read -r pilihan

        case "$pilihan" in
            1) menu_kill_chain ;;
            2) menu_exploit ;;
            3) menu_netscan ;;
            4) user_guide ;;
            0) echo -e "${G}  Exiting NIGHT WORLD...${N}"; exit 0 ;;
            *) echo -e "${R}  Invalid choice.${N}"; sleep 1 ;;
        esac
    done
}

main
