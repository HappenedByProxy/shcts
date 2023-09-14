#!/bin/bash
RED='\033[0;31m'
LRED='\033[1;31m'
GREEN='\033[0;32m'
LGREEN='\033[1;32m'
TERRY='\033[0;33m'
PISS='\033[1;33m'
BLU='\033[0;34m'
LBLU='\033[1;34m'
CYAN='\033[0;36m'
LCYAN='033[1;36m'
PURP='\033[0;35m'
GAY='\033[1;35m'
GRAY='\033[1;30m'
LGRAY='\033[0;37m'
NC='\033[0m'


# List unique files in a folder
function files() {
   find . -type f | sed -e 's/.*\.//' | sed -e 's/.*\///' | sort | uniq -c | sort -rn
}

# Download best quality YouTube video
function best() {
  yt-dlp --format '(bestvideo[vcodec^=av01][height>=4320][fps>30]/bestvideo[vcodec^=vp9.2][height>=4320][fps>30]/bestvideo[vcodec^=vp9][height>=4320][fps>30]/bestvideo[vcodec^=avc1][height>=4320][fps>30]/bestvideo[height>=432$$>=144]/bestvideo)+(bestaudio[acodec^=opus]/bestaudio)/best' --add-metadata --ignore-errors --no-continue --no-overwrites --download-archive archive.log --merge-output-format mkv --check-formats --concurrent-fragments 5 $1
}

# Download any website to a warc
function quick-warc {
        if [ -f $1.warc.gz ]
        then
                echo "$1.warc.gz already exists"
        else
                wget --warc-file=$1 --warc-cdx --mirror --page-requisites --no-check-certificate --restrict-file-names=windows \
                -e robots=off --waitretry 5 --timeout 60 --tries 5 --wait 1 \
                -U "Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US) AppleWebKit/533.20.25 (KHTML, like Gecko) Version/5.0.4 Safari/533.20.27" \
                "http://$1/"
        fi
}

# 0x0 uploader
function 0x0() {

  PS3='Select null pointer instance: '
  options=("0x0.st - 512MiB" "envs.sh - 512MiB" "ttm.sh - 256MiB" "Pixeldrain - 18.63GiB" "Quit")
  file=($1)
  select opt in "${options[@]}"
  do
      case $opt in
          "0x0.st - 512MiB")
              url=(https://0x0.st)
              break
              ;;
          "envs.sh - 512MiB")
              url=(https://envs.sh)
              break
              ;;
          "ttm.sh - 256MiB")
              url=(https://ttm.sh)
              break
              ;;
          "Pixeldrain - 18.63GiB")
             url=(https://pixeldrain.com/api/file/)
             id_=$(curl -T "$file" $url | jq -r '.id')
             printf "https://pixeldrain.com/u/$id_ " | tee >(clip.exe) && exit
             ;;
          "Quit")
              break
              ;;
          *) echo "invalid option $REPLY";;
      esac
  done

  curl -F"file=@$file" $url | tee >(clip.exe)
  #echo $file $url
}

#hmap - nmap helper
function hmap() {
   if [ -z "$1" ]
   then
     printf "hmap : nmap helper\n"
     printf "a : all\n"
     printf "aa : all, aggressive\n"
     printf "s : stealth\n"
   fi

	if [ "$1" = "a" ]
	then
		nmap -A -v $2
	fi

 	if [ "$1" = "aa" ]
	then
		nmap -A -v -T4 $2
	fi
 
	if [ "$1" = "s" ]
	then
		nmap -v -sS $2
	fi
 
}

#Simple IP lookup
function ipinfo() {
   curl "ipinfo.io/$1"
}

#Fully removes a package, thanks to u/nickelodeandiesel on r/archlinux. Needs yay.
function yeet() {
   yay -Rsnd $1
}

#Nmap scan for local devices with multiple options.
function nmaplocal() {
   if [ -z "$1" ]
   then
      printf "Available commands:\n"
      printf "${LGREEN}public - Ping scan only, no port scanning.${NC}\n"
      printf "${LRED}private - Extensive. OS Detection, Service, Script and Port scan. Might trigger something.${NC}\n"
   fi

   if [ "$1" = "private" ]
   then
      sudo nmap -v -O -sC -sV 192.168.1.0/24 | grep -v "down"
   fi

   if [ "$1" = "public" ]
   then
      nmap -v -sn 192.168.1.0/24 | grep -v "down"
  fi
}

# Get status code of any website, and ONLY the status code.
function webstatus() {
   STATUS=$(http -hdo ./body $1 2>&1 | grep HTTP/ ); echo $STATUS
}

# Untar stuff.
function untar() {
   tar -vxf $1
}

# Tars stuff.
function maketar() {
   tar -cf $1 $2
}

# Consults cheat.sh for man TLDRs. 
function cheat() {
  curl cheat.sh/$1
}

function spoofmac() {
  #WiFi goes down!
  ip link set dev wlo1 down
  sleep 5

  #Change MAC address.
  macchanger -r wlo1
  sleep 5

  #WiFi goes up!
  ip link set dev wlo1 up
  sleep 5
}

#List some commands I keep forgetting about.
function commands() {
   if [ -z "$1" ]
   then
      printf "Choose a catagory:\n"
      printf "${GRAY}custom${NC}\n"
      printf "${CYAN}OSINT${NC}\n"
      printf "${PISS}(search)ing${NC}\n"
      printf "${GAY}OpenDirectory(opend)${NC}\n"
      printf "${TERRY}nmap${NC}\n"
      printf "${TERRY}scripts{$NC}\n"
		  printf "${LBLU}dorking${NC}\n"
      printf "bspwm"
      printf "sudo chown byproxy:wheel to take back a file you should own\n"
      printf "brightnesctl set 10000\n"
      printf "nmtui = Network manager terminal interface\n"
      printf "usbdeath\n"
    fi

   if [ "$1" = "osint" ]
   then
      printf "h8mail - Email info and password lookup tool.\n"
      printf "phoneinfoga - Phone info lookup tool.\n"
      printf "infoga - Email info lookup tool.\n"
      printf "raccoon - Offensive tool for reconnaissance and vulnerability scanning.\n"
      printf "nmap - You know what this does.\n"
      printf "nikto - Powerful webserver vulnerablity tool. Takes hours.\n"
      printf "ghunt - Tool to extract info from gmail accounts.\n"
   fi

   if [ "$1" = "yay" ]
   then
      printf "Searching for packages:\n"
      printf "pacman -Ql - List where a program is.\n"
      printf "yay -Ss - Search packages.\n"
      printf "pacman -Qi - Check package info.\n"
      printf "yay -Pw - Check Arch news.\n"
      printf "yay -Ps - Package manager information.\n"
      printf "yay -Sc - Clean cached AUR packages.\n"
      printf "yay -Pc - Complete list of all AUR packages, you shouldn't use this.\n"
      printf "pacman -R $(pacman -Qsq .query.) - Remove all packages containing a word.\n"
      printf ""
      printf "\n" 
      printf "Searching for files:\n"
      printf "fzf - Fuzzy finder.\n"
   fi

   if [ "$1" = "nmap" ]
   then
      printf "nmap -sn 192.168.1.0/24 - Scan for local devices, no port scanning.\n"
      printf "--script /usr/lib/python3.8/site-packages/raccoon_src/utils/misc/vulners.nse - Vulners script.\n"
      printf 'nmap -T2 -sn -Pn -v -oN "/home/byproxy/Desktop/nmap results/[FILE]" [inet].0.0/16" - Scan all devices on subnet\n'
      printf "nmap -v -F -sC -sV -O {target} - The full sauce.\n"
   fi

	if [ "$1" = "dorking" ]
	then
		printf 'Scanner results: intitle:"report" ("qualys" | "acunetix" | "nessus" | "netsparker" | "nmap") filetype:pdf\n'
		printf 'Logs: allintext:username filetype:log\n'
		printf 'FTP: intitle:"index of" inurl:ftp\n'
		printf 'Webcams: intitle:"webcamxp 5"\n'
		printf 'DB passwords: db_password filetype:env\n'
		printf 'Github thingies: filetype:inc php -site:github.com -site:sourceforge.net\n'
		printf 'Expose PHP variables: filetype:php "Notice: Undefined variable: data in" -forum\n'
		printf 'WAMPServers: intitle:"WAMPSERVER homepage" "Server Configuration" "Apache Version"\n'
      printf 'intitle:"SecureWEB"'
   fi

	if [ "$1" = "programs" ]
	then
		printf 'hexyl - Hex viewer, it has colours too!\n'
		printf 'yy-chr - Sprite editor, needs Wine to run it.\n'
	fi 

   if [ "$1" = "bspwm" ]
   then
      printf "You'll be here a lot :)\n"
      printf "Move windows to another workspace: Super Shift Num\n"
      printf "Launchbar: Super Space\n"
      printf "Enlargen width: Super Alt HJKL\n"
      printf "Smaller width: Super Alt SHift JHKL"
      printf "Close highlihted window: Super W\n"
      printf "Change window position: Super Shift HJKL\n"
      printf "Determine where the next window will go: Ctrl SUper HJKL\n"
      printf "Toggle window flags:\n"
      printf "Super T - Tiled\n"
      printf "Super Shift T - Psuedo Tiled\n"
      printf "Super S - Floating\n"
      printf "Super F - Fullscreen\n"
      printf "Moving floating windows: Super Arrows"
   fi

   if [ "$1" = "sec" ]
   then
      printf "autopsy"
   fi

   if [ "$1" = "usbdeath" ]
   then
      printf "usbdeath show - Check connected USB devices\n"
      printf "usbdeath on - Generate whitelist of connected devices\n"
      printf "usbdeath eject - Add event on ejection of specific device\n"
      printf "usbdeath off - Turn off usbdeath (to insert a new trusted device)\n"
      printf "usbdeath gen - Permanently add new trusted device\n"
      printf "usbdeath edit - Edit udev rules manually\n"
      printf "usbdeath del - Delete the udev rules files and start over\n"
   fi

   if [ "$1" = "custom" ]
   then
      printf "files - list unique files\n"
      printf "best - download best quality yt\n"
      printf "quick-warc - make a warc of a website [quick-warc \$website]\n"
      printf "0x0 - file uploader [0x0 \$file]\n"
      printf "hmap - nmap helper\n"
      printf "nmaplocal - local namp scan\n"
      printf "ipinfo - ip lookup\n"
      printf "yeet - fully remove a package\n"
      printf "webstatus - get http status\n"
      printf "untar / maketar - tar stuff\n"
      printf "cheat - consult cheat.sh\n"
      printf "spoofmac - change mac address\n"
   fi

   if [ "$1" = "scripts" ]
   then
   	printf "${LGRAY}default - Scripts that are ran when using -sC or -A.\n"
	  printf "${LGREEN}safe - Scripts that aren't designed to crash services, use large amounts of bandwidth or exploits. A bit more sysadmin friendly. Almost.\n"
	  printf "${LRED}auth - Authentication credentials (and bypassing them). No bruteforce.\n"
	  printf "${ORANGE}broadcast - Scripts that broadcast on the local network.\n"
	  printf "${RED}brute - Automate bruteforce attacks to guess the auth creds of a target.\n"
	  printf "${ORANGE}discovery - Tries to actively discover more about the network by querying third parties.\n"
	  printf "${RED}dos - Scripts that may cause a denial of service. May also crash the target system.\n"
	  printf "${RED}exploit - Actively exploit some vulnerability\n."
	  printf "${ORANGE}external - May send data to third-party databases.\n"
	  printf "${RED}fuzzer - Scripts which are designed to send unexpected or randomized fields in each packet. It's slow, bandwidth intensive and may cause a DoS or crash the target.\n"
	  printf "${RED}intrusive - High chance of harming the target system.\n"
	  printf "${LRED}malware - Checks whether the target is infected with malware or backdoors.\n"
	  printf "${RED}vuln - Check for specific known vulnerabilities.\n"
   fi
}
