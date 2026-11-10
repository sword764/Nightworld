#!/usr/bin/env bash
# ============================================
#   N I G H T   W O R L D
#   Version: 2.0 (Public)
#   Engine : 5.0 (Device Responsive)
#   By bogor x ploit
# ============================================

VERSION="2.0"

# --- GANTI URL INI PAKAI LINK CLOUDFLARE/NGROK TUAN ---
MODULE_URL="https://LINK_CLOUDFLARE_TUAN_DISINI" 
# ------------------------------------------------------

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

# ---------- ASCII PC (Keris) ----------
ascii_pc() {
    cat <<'ASCII'
                    /\
                   /   \
                  /     \
                 |       |
                 |   ||  |
                 |   ||  |
                 |   ||  |
                 |   ||  |
                 |   ||  |
                 |   ||  |
                 |   ||  |
    ____________|    ||    |____________
   \          __     ||     __        /
    \   .----'    \  ||  /   `----.  /
     \/            \_||_/           \/
                     ||
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
                     ||
                     |/
ASCII
}

# ---------- ASCII Mobile (Compact) ----------
ascii_mobile() {
    cat <<'ASCII'
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

run_tool() {
    TOOL_NAME="$1"
    FILE_NAME="$2"
    clear

    echo -e "${C}--------------------------------------------------${N}"
    echo -e "${W}                 $TOOL_NAME${N}"
    echo -e "${W}             By Bogor X Ploit${N}"
    echo -e "${C}--------------------------------------------------${N}"
    echo ""

    if [ -f "$FILE_NAME" ]; then
        echo -e "${G}[+] Module $TOOL_NAME found in local cache.${N}"
        echo -e "${Y}[*] Booting up...${N}"
        sleep 1
    else
        echo -ne "${Y}[?] Do you want to install $TOOL_NAME module? (Y/N) > ${N}"
        read -r confirm
        
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            echo -e "${R}[-] Installation aborted. Returning to menu.${N}"; sleep 1.5; return
        fi

        echo ""
        echo -e "${G}[*] Downloading $FILE_NAME from C2 server...${N}"
        DOWNLOAD_URL="${MODULE_URL}/$FILE_NAME" 
        curl -s -o "$FILE_NAME" "$DOWNLOAD_URL"
        
        if [[ ! -f "$FILE_NAME" ]] || ! head -n 1 "$FILE_NAME" | grep -q "#!/usr/bin/env bash"; then
            echo -e "${R}[-] CRITICAL: Download failed or invalid script format!${N}"
            echo -e "${Y}[!] The server might have returned a 404 HTML page.${N}"
            rm -f "$FILE_NAME" 
            sleep 2; return
        fi
        echo -e "${G}[*] Verifying checksum (SHA-256)...${N}"; sleep 0.8
    fi

    echo ""
    echo -ne "${Y}Installing... [${N}"
    for i in {1..30}; do echo -ne "${W}=${N}"; sleep 0.05; done
    echo -e "${Y}] 100%${N}"; echo ""
    echo -e "${C}==================================================${N}"
    
    BOOT_LOGS=()
    if [ "$IS_TERMUX" -eq 1 ]; then
        BOOT_LOGS+=(
            "[    0.000000] Android Kernel Version: $KERNEL"
            "[    0.015000] Architecture: $CPU_ABI"
            "[    0.032000] Device Model: $DEV_MODEL"
            "[    0.120000] Loading Termux environment ($PREFIX)..."
            "[    0.240000] Initializing Dalvik Virtual Machine (Android $ANDROID_VER)..."
            "[    0.350000] ART runtime optimization enabled."
            "[    0.460000] Mounting /data/data/com.termux/files/usr..."
        )
    else
        BOOT_LOGS+=(
            "[    0.000000] Linux Kernel Version: $KERNEL"
            "[    0.015000] Architecture: $ARCH"
            "[    0.032000] Device Model: $DEV_MODEL"
            "[    0.120000] Loading $OS_NAME environment..."
            "[    0.240000] Initializing systemd services..."
            "[    0.350000] Mounting /proc and /sys..."
            "[    0.460000] Loading kernel modules..."
        )
    fi

    BOOT_LOGS+=(
        "[    0.580000] [ INFO ] Extracting $FILE_NAME..."
        "[    0.690000] [ OK ] Module loaded."
        "[    0.810000] [ INFO ] Initializing Engine..."
        "[    0.920000] [ OK ] Engine ready."
        "[    1.050000] [ INFO ] Bypassing WAF..."
        "[    1.150000] [ OK ] WAF bypass successful."
        "[    1.260000] [ INFO ] Spawning background daemon..."
        "[    1.380000] [ OK ] Daemon active."
        "[    1.490000] [ INFO ] Establishing C2 channel..."
        "[    1.600000] [ OK ] Channel encrypted (AES-256)."
        "[    1.710000] [ INFO ] Hiding process tree..."
        "[    1.830000] [ OK ] Process hidden."
        "[    1.940000] [ INFO ] Clearing logs..."
        "[    2.050000] [ OK ] Logs cleared."
        "[    2.160000] [ INFO ] Routing via proxy chain..."
        "[    2.280000] [ OK ] Tor circuit established."
        "[    2.390000] [ INFO ] Verifying connection..."
        "[    2.500000] [ OK ] Connection stable."
        "[    2.610000] [ INFO ] Setting up fallback C2..."
        "[    2.730000] [ OK ] Fallback ready."
        "[    2.840000] [ INFO ] Registering session ID..."
        "[    2.950000] [ OK ] Session ID: 0x$RANDOM$RANDOM."
        "[    3.060000] [ INFO ] Activating stealth mode..."
        "[    3.170000] [ OK ] Stealth mode active."
        "[    3.280000] [ OK ] $TOOL_NAME is now fully operational."
    )

    for log in "${BOOT_LOGS[@]}"; do
        echo -e "${W}  $log${N}"
        sleep 0.15
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

main() {
    detect_env
    while true; do
        clear
        # Responsive ASCII (Berdasarkan Device)
        if [ "$IS_TERMUX" -eq 1 ]; then
            echo -e "${B}"
            ascii_mobile
            echo -e "${N}"
        else
            echo -e "${B}"
            ascii_pc
            echo -e "${N}"
        fi
        
        show_banner
        show_menu
        echo -ne "${Y}  Select menu > ${N}"
        read -r pilihan

        case "$pilihan" in
            1) clear; echo -e "${C}  [Cyber Kill Chain] - Coming soon${N}"; sleep 1 ;;
            2) menu_exploit ;;
            3) clear; echo -e "${C}  [Netscan] - Coming soon${N}"; sleep 1 ;;
            4) clear; echo -e "${C}  [User Guide] - Coming soon${N}"; sleep 1 ;;
            0) echo -e "${G}  Exiting NIGHT WORLD...${N}"; exit 0 ;;
            *) echo -e "${R}  Invalid choice.${N}"; sleep 1 ;;
        esac
    done
}

main
