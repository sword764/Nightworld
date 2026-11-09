#!/usr/bin/env bash
# ============================================
#   N I G H T   W O R L D
#   By bogor x ploit
#   v2.0
# ============================================

VERSION="2.0"

# ---------- Warna ----------
C='\033[0;36m'   # cyan
B='\033[0;34m'   # blue
W='\033[1;37m'   # white
R='\033[0;31m'   # red
Y='\033[1;33m'   # yellow
G='\033[0;32m'   # green
N='\033[0m'      # reset

# ---------- Deteksi Environment ----------
detect_env() {
    OS_NAME="Unknown"
    ROOT_STATUS="Unknown"

    if [ -n "$PREFIX" ] && echo "$PREFIX" | grep -qi "com.termux"; then
        OS_NAME="Termux"
    elif [ -f /etc/os-release ]; then
        . /etc/os-release
        case "$ID" in
            kali)      OS_NAME="Kali Linux" ;;
            blackarch) OS_NAME="BlackArch Linux" ;;
            parrot)    OS_NAME="Parrot OS" ;;
            arch)      OS_NAME="Arch Linux" ;;
            ubuntu)    OS_NAME="Ubuntu Linux" ;;
            debian)    OS_NAME="Debian Linux" ;;
            *)         OS_NAME="${PRETTY_NAME:-$ID}" ;;
        esac
    elif [ "$(uname -o 2>/dev/null)" = "Android" ]; then
        OS_NAME="Android"
    else
        OS_NAME="$(uname -s) Linux"
    fi

    if [ "$(id -u)" -eq 0 ]; then
        ROOT_STATUS="Root"
    else
        if command -v su >/dev/null 2>&1 && su -c id >/dev/null 2>&1; then
            ROOT_STATUS="Root (su available)"
        else
            ROOT_STATUS="Non-Root"
        fi
    fi

    USER_NAME="$(whoami 2>/dev/null || echo unknown)"
    COLS="$(tput cols 2>/dev/null || echo 80)"
}

# ---------- ASCII PC (lebar) ----------
ascii_pc() {
    cat <<'EOF'
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
EOF
}

# ---------- ASCII Mobile (compact) ----------
ascii_mobile() {
    cat <<'EOF'
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
EOF
}

# ---------- Banner Info ----------
show_banner() {
    echo -e "${C}--------------------------------------------------${N}"
    echo -e "${W}  NIGHT WORLD ${C}|${W} By bogor x ploit${N}"
    echo -e "${C}--------------------------------------------------${N}"
    echo -e "${Y}  Version : ${W}v${VERSION}${N}"
    echo -e "${Y}  OS      : ${W}${OS_NAME}${N}"
    echo -e "${Y}  User    : ${W}${USER_NAME}${N}"
    echo -e "${Y}  Access  : ${W}${ROOT_STATUS}${N}"
    echo -e "${C}--------------------------------------------------${N}"
}

# ---------- Pilih ASCII ----------
show_ascii() {
    if [ "$COLS" -ge 60 ]; then
        echo -e "${B}"
        ascii_pc
        echo -e "${N}"
    else
        echo -e "${B}"
        ascii_mobile
        echo -e "${N}"
    fi
}

# ---------- Menu ----------
show_menu() {
    echo -e "${G}  [ MENU UTAMA ]${N}"
    echo -e "${C}--------------------------------------------------${N}"
    echo -e "  ${W}[1]${N} Cyber Kill Chain"
    echo -e "  ${W}[2]${N} Exploitation"
    echo -e "  ${W}[3]${N} Netscan"
    echo -e "  ${W}[4]${N} Directions for use"
    echo -e "  ${W}[0]${N} Exit"
    echo -e "${C}--------------------------------------------------${N}"
}

# ---------- Main ----------
main() {
    detect_env
    clear
    show_ascii
    show_banner
    show_menu
    echo -ne "${Y}  Pilih menu > ${N}"
    read -r pilihan

    case "$pilihan" in
        1) echo -e "${C}  [Cyber Kill Chain] — coming soon${N}"; sleep 1 ;;
        2) echo -e "${C}  [Exploitation] — coming soon${N}"; sleep 1 ;;
        3) echo -e "${C}  [Netscan] — coming soon${N}"; sleep 1 ;;
        4) echo -e "${C}  [Directions for use] — coming soon${N}"; sleep 1 ;;
        0) echo -e "${G}  Exit in NIGHT WORLD...${N}"; exit 0 ;;
        *) echo -e "${R}  Command invalid.${N}"; sleep 1 ;;
    esac
    echo ""
    main
}

main
