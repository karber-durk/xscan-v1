#!/bin/bash

# Author: #Kasper
# Date: 9/10/2024
# If You Have any commecnt You can get me in Telegram: @User0xz19


# Colors and Fonts using tput
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
ORANGE=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BLACK=$(tput setaf 0)

REDBG=$(tput setab 1)
GREENBG=$(tput setab 2)
ORANGEBG=$(tput setab 3)
BLUEBG=$(tput setab 4)
MAGENTABG=$(tput setab 5)
CYANBG=$(tput setab 6)
WHITEBG=$(tput setab 7)
BLACKBG=$(tput setab 0)

BOLD=$(tput bold)
RESET=$(tput sgr0)
tab="$(printf '\t')"

# Handle program interrupt
trap 'printf "\033[1;5;40m\b\b${BLUE}[${RED}!${BLUE}] ${RED}Program Interrupted ${BLUE}[${RED}!${BLUE}]${RESET}\n"' SIGINT 2>/dev/null

# Help Menu
help_menu() {
    cat <<- EOF
${BOLD}${tab}$(printf '\u3010') ${GREEN}xscan v1 Network and Port Scanner ${WHITE}${BOLD}$(printf '\u3011')${RESET}
${WHITE}Usage: xscan [Options] [Target]
${GREEN}OPTIONS:
${MAGENTA} -h   --help     ${WHITE} Display Help Menu
${MAGENTA} -H   --Host     ${WHITE} Specify the Host or IP address
${MAGENTA} -p   --port     ${WHITE} Specify the port range (e.g., 80, 1-100)
${MAGENTA} -sT  --Tcp-scan ${WHITE} Scan using three-way handshake (TCP)
${MAGENTA} -sU  --Udp-scan ${WHITE} Scan using one-way handshake (UDP)
${MAGENTA} -sV  --service  ${WHITE} Version Detection
${MAGENTA} -v   --version  ${WHITE} Output Version Information

EOF
}

# Check root privileges
check_root() {
    if [[ "$(id -u)" != "0" ]]; then
        printf "${GREEN}[${RED}!${GREEN}]${RED} This scan requires root privileges\n"
        exit 1
    fi
}

# Validate host
valid_host() {
    valid_host_regex="^(http://|https://|www\.)?[a-zA-Z0-9]+(\.[a-zA-Z]{2,})+$|localhost"
    valid_ip_regex="^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$"

    if [[ $host =~ $valid_host_regex ]]; then
        next="0"
    elif [[ $host =~ $valid_ip_regex ]]; then
        IFS='.' read -r -a range <<< "$host"
        if (( ${range[0]} >= 0 && ${range[0]} <= 255 &&
              ${range[1]} >= 0 && ${range[1]} <= 255 &&
              ${range[2]} >= 0 && ${range[2]} <= 255 &&
              ${range[3]} >= 0 && ${range[3]} <= 255 )); then
            next="0"
        else
            printf "${GREEN}[${RED}!${GREEN}]${RED} Invalid IP range\n"
            exit 1
        fi
    else
        printf "${GREEN}[${RED}!${GREEN}]${RED} Please specify a valid hostname or IP address\n"
        exit 1
    fi
}

# Ping the host to check if it's up
is_up() {
    check_root
    if [[ $next == "0" ]]; then
        python .bin/ping "$host"
    fi
}

# Perform scanning
scan() {
    # Set file to socket_tcp by default
    local file="socket_tcp"

    # If UDP mode is selected, change to socket_udp
    if [[ $udp_mode == true && ! $tcp_mode ]]; then
        file="socket_udp"
    fi

    # Check if both host and port are valid
    if [[ $next == "0" ]]; then
        if [[ $port =~ ^[0-9]+(-[0-9]+)?$ ]]; then
            if [[ $port =~ - ]]; then
                start=$(echo "$port" | cut -d"-" -f1)
                end=$(echo "$port" | cut -d"-" -f2)

                # Ensure that start port is less than end port
                if (( start > end )); then
                    printf "${GREEN}[${RED}!${GREEN}]${RED} Invalid port range. Please specify a valid range (e.g., 1-100).\n"
                    exit 1
                else
                    # If valid, perform scan using Python script
                    printf "${GREEN}[${BLUE}*${GREEN}]${WHITE} Scanning $host on ports $start to $end\n\n"
                    python .bin/"$file" "$host" "$port"
                fi
            else
                # If only one port is provided, perform scan
                printf "${GREEN}[${BLUE}*${GREEN}]${WHITE} Scanning $host on port $port\n\n"
                python .bin/"$file" "$host" "$port"
            fi
        else
            printf "${GREEN}[${RED}!${GREEN}]${RED} Invalid port format. Please specify a valid port or port range.\n"
            exit 1
        fi
    else
        printf "${GREEN}[${RED}!${GREEN}]${RED} Please provide a valid host and port.\n"
        exit 1
    fi
}

# Display version
version() {
    printf "${GREEN}xscan v1\n"
}

# Service detection
service_detect() {
    file="socket_tcp"
    if [[ -z $host || -z $port ]]; then
        echo -e "${GREEN}[${RED}!${GREEN}]${RED} Please specify the host and port"
        exit 1
    elif [[ $udp_mode ]]; then
        file="socket_udp"
    fi
    python .bin/"$file" "$host" "$port" -v
    exit 0
}

# Main function
Main_function() {
    if [[ "${#}" < 1 ]]; then
        help_menu
        exit 1
    fi

    while [[ "${#}" -gt 0 ]]; do
        case $1 in
            -h|--help)
                help_menu; exit 0 ;;
            -p|--port)
                port="$2"
                if [[ -z $port ]]; then
                    printf "${GREEN}[${RED}!${GREEN}] ${RED}Please specify a port\n"
                    exit 1
                fi
                port_status=true; shift 2 ;;
            -H|--Host)
                host="$2"
                if [[ -z $host ]]; then
                    printf "${GREEN}[${RED}!${GREEN}]${RED} Please specify a hostname or IP address\n"
                    exit 1
                fi
                host_status=true; shift 2 ;;
            -sT|--Tcp-scan)
                tcp_mode=true; shift ;;
            -sU|--Udp-scan)
                udp_mode=true; shift ;;
            -sV|--service)
                service=true; service_detect; shift ;;
            -v|--version)
                version; shift ;;
            *)
                echo "${GREEN}[${RED}!${GREEN}]${RED} Invalid option"; exit 1 ;;
        esac
    done

   if [[ $host_status == true && $port_status == true ]]; then
    	valid_host
    	scan
    	exit 0
    elif [[ $host_status == true ]]; then
    	valid_host
    	is_up
    	exit 0
    elif [[ $port_status == true && ! $host_status ]]; then
    	printf "${GREEN}[${RED}!${GREEN}]${RED} Please specify the host first.\n"
    exit 1

    elif [[ $udp_mode == true && $service == true ]]; then
        printf "${GREEN}[${RED}!${GREEN}]${RED} You can't detect service version with UDP scan!\n"
        exit 1
    elif [[ $tcp_mode == true && $udp_mode == true ]]; then
        printf "${GREEN}[${RED}!${GREEN}]${RED} You can't specify both TCP and UDP together!\n"
        exit 1
    elif [[ $tcp_mode == true || $udp_mode == true ]]; then
        if [[ ! $port_status ]]; then
            printf "${GREEN}[${RED}!${GREEN}]${RED} Please specify the port\n"
        fi
    fi
}

Main_function "$@"
