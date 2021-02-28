

#create hostname account with root privelages.
function create_user () {

install_log "Create a SNApp host user account"

if [ $(id -u) -eq 0 ]; then
	read -p "Enter username : " username
	read -s -p "Enter password : " password
	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$username exists!"
		exit 1
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		useradd -m -p $pass $username
    sudo adduser $username sudo
		[ $? -eq 0 ] && echo "User has been added to system!" || echo "Failed to add a user!"
	fi
else
	echo "Only root may add a user to the system"
	exit 2
fi

}

# Outputs a Deadalus Install log line
function install_log() {
    echo -e "\033[1;32mSNApp Install: $*\033[m"
}

# Outputs a Deadalus Install Error log line and exits with status code 1
function install_error() {
    echo -e "\033[1;37;41mSNApp Install Error: $*\033[m"
    exit 1
}

# Outputs a Deadalus Warning line
function install_warning() {
    echo -e "\033[1;33mAdvisory: $*\033[m"
}

# Outputs a welcome message
function display_welcome() {
    raspberry='\033[0;35m'
    green='\033[1;32m'
    cyan='\033[1;36m'

    echo -e "${cyan}\n"
    echo -e "  ____                 _       _ "          
    echo -e " |  _ \  __ _  ___  __| | __ _| |_   _ ___ "
    echo -e " | | | |/ _  |/ _ \/ _  |/ _  | | | | / __| "
    echo -e " | |_| | (_| |  __/ (_| | (_| | | |_| \__ \ "
    echo -e " |____/ \__,_|\___|\__,_|\__,_|_|\__,_|___/ "
    echo -e "${raspberry}  ____  _   _    _                 ____            __ _  "           
    echo -e " / ___|| \ | |  / \   _ __  _ __  / ___|_ __ __ _ / _| |_ ___ _ __  "
    echo -e " \___ \|  \| | / _ \ |  _ \|  _ \| |   |  __/ _  | |_| __/ _ \  __|  "
    echo -e "  ___) | |\  |/ ___ \| |_) | |_) | |___| | | (_| |  _| ||  __/ |  "  
    echo -e " |____/|_| \_/_/   \_\ .__/| .__/ \____|_|  \__,_|_|  \__\___|_|  "   
    echo -e "                     |_|   |_| TM  "
    echo -e "${cyan}by Minotaurware.net "
    echo -e "${green}\n"
    echo -e "SNApp setup tool for Linux based operating systems."
    echo -e "The Quick Installer will guide you through a few easy steps\n\n"
}

### NOTE: all the below functions are overloadable for system-specific installs
### NOTE: some of the below functions MUST be overloaded due to system-specific installs
# Runs a system software update to make sure we're using all fresh packages

function update_system_packages() {
    # OVERLOAD THIS
    install_error "No function definition for update_system_packages"
}

# Installs additional dependencies using system package manager
function install_dependencies() {
    # OVERLOAD THIS
    install_error "No function definition for install_dependencies"
}

# Halts lokinet to allow for modifications to it
function stop_lokinet(){
    sudo systemctl stop lokinet.service
}

# Verifies existence and permissions of SNApp directory
function create_webpage_directory() {
    install_log "Creating webpage directory"
    snapp_dir="/home/$username/snapp"

    if [ -d "$snapp_dir" ]; then
        sudo mv $snapp_dir "$snapp_dir.`date +%F-%R`" || install_error "Unable to move old '$snapp_dir' out of the way"
    fi
    sudo mkdir -p "$snapp_dir" || install_error "Unable to create directory '$snapp_dir'"
    sudo chown -R $username:$username "$snapp_dir" || install_error "Unable to change file ownership for '$snapp_dir'"
}

# Fetches latest files from github for basic SNapp
function download_latest_files() {
    if [ -d "$snapp_dir" ]; then
        sudo mv $snapp_dir "$snapp_dir.`date +%F-%R`" || install_error "Unable to remove old snap directory"
    fi

    install_log "Cloning latest files from github"
    git clone --depth 1 https://github.com/necro-nemesis/Daedalus-SNAppCrafter $snapp_dir || install_error "Unable to download files from github"

#handle changes to resolvconf giving nameserver 127.3.2.1 priority.
		sudo systemctl stop resolvconf
		sudo mv $snapp_dir/head /etc/resolvconf/resolv.conf.d/head || install_error "Unable to move resolvconf head file"
		sudo rm /etc/resolv.conf
		sudo ln -s /etc/resolvconf/run/resolv.conf /etc/resolv.conf
		sudo resolvconf -u || install_error "Unable to update resolv.conf"
		sudo systemctl start resolvconf
}

# Sets files ownership in SNapp directory
function change_file_ownership() {
    if [ ! -d "$snapp_dir" ]; then
        install_error "snapp directory doesn't exist"
    fi

    install_log "Changing file ownership in SNApp directory"
    sudo chown -R $username:$username "$snapp_dir" || install_error "Unable to change file ownership for 'snapp_dir'"
		sudo chmod -R 0755 "$snapp_dir" || install_error "Unable to change permissions for 'snapp_dir'"
		sudo mv $snapp_dir/snapp /usr/local/bin
}

function install_complete() {

		#append /var/lib/lokinet/lokinet.ini
		sed -i 's#\#keyfile=#keyfile=/var/lib/lokinet/snappkey.private#g' /var/lib/lokinet/lokinet.ini
		sudo systemctl restart lokinet

		#set nginx host directory to snapp_dir
		sed -i 's#/var/www/html#'"$snapp_dir"'#g' /etc/nginx/sites-enabled/default

		#clean out installer files
		sudo rm -r $snapp_dir/installers || install_error "Unable to remove installers"
    sudo rm -r /tmp/snapp || install_error "Unable to remove /tmp/snapp folder"

		#provide option to launch and display lokinet address
		
    cyan='\033[1;36m'		
    echo -e "${cyan}\n"
    echo -e "  ____                 _       _  "  
    echo -e " |  _ \  __ _  ___  __| | __ _| |_   _  __  "
    echo -e " | | | |/ _  |/ _ \/ _  |/ _  | | | | / __|  "
    echo -e " | |_| | (_| |  __/ (_| | (_| | | |_| \__ \  " 
    echo -e " |____/ \__,_|\___|\__,_|\__,_|_|\__,_|___/  "
    echo -e " by Minotaurware.net  "
		install_log "Daedalus has completed your installation"
		IP="127.3.2.1"
		snapp_address=$(host -t cname localhost.loki $IP | awk '/alias for/ { print $6 }')
		install_warning "Your Lokinet Address is:\nhttp://${snapp_address}"
		install_warning "Place your SNApp in ${snapp_dir}"
    echo -n "Do you wish to go live with test snapp? [y/N]: "
    read answer
    if [[ $answer != "y" ]]; then
        echo "Server not launched. Exiting installation"
        exit 0
    fi
    install_log "Server Launching"
		sudo systemctl restart nginx
		sudo systemctl restart lokinet
		exit 0 || install_error "Unable to exit"
}

function install_Daedalus() {
    display_welcome
    update_system_packages
    install_dependencies
		stop_lokinet
    create_user
    create_webpage_directory
    download_latest_files
    change_file_ownership
    install_complete
}
