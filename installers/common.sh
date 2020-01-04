

#create hostname account

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

# Outputs a SNApp-Pi-Host Install log line
function install_log() {
    echo -e "\033[1;32mSNApp Install: $*\033[m"
}

# Outputs a SNApp-Pi-Host Install Error log line and exits with status code 1
function install_error() {
    echo -e "\033[1;37;41mSNApp Install Error: $*\033[m"
    exit 1
}

# Outputs a SNApp-Pi-Host Warning line
function install_warning() {
    echo -e "\033[1;33mWarning: $*\033[m"
}

# Outputs a welcome message
function display_welcome() {
    raspberry='\033[0;35m'
    green='\033[1;32m'

    echo -e "${green}\n"
    echo -e "  ___ _  _   _                 ___ ___    _  _  ___  ___ _____ "
    echo -e " / __| \| | /_\  _ __ _ __ ___| _ \_ _|__| || |/ _ \/ __|_   _|"
    echo -e " \__ \ .' |/ _ \| '_ \ '_ \___|  _/| |___| __ | (_) \__ \ | |"
    echo -e " |___/_|\_/_/ \_\ .__/ .__/   |_| |___|  |_||_|\___/|___/ |_|"
    echo -e "                 |_|  |_|"
    echo -e "${raspberry}"
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


# Verifies existence and permissions of RaspAP directory
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
    git clone --depth 1 https://github.com/necro-nemesis/SNapp-Pi-Host $snapp_dir || install_error "Unable to download files from github"
}

# Sets files ownership in SNapp directory
function change_file_ownership() {
    if [ ! -d "$snapp_dir" ]; then
        install_error "snapp directory doesn't exist"
    fi

    install_log "Changing file ownership in SNApp directory"
    sudo chown -R $username:$username "$snapp_dir" || install_error "Unable to change file ownership for 'snapp_dir'"
}

function display_lokiaddress (){
        IP="10.0.0.1"
        snapp_address=$(nslookup $IP | sed -n 's/.*arpa.*name = \(.*\)/\1/p')
        echo -e "Your Lokinet Address is:\nhttp://${snapp_address}"
}

function install_complete() {
    sudo rm -r $snapp_dir/installers || install_error "Unable to remove installers"
    sudo rm -r /tmp/snapp || install_error "Unable to remove /tmp/snapp folder"
    install_log "Installation completed!"

    echo -n "Installation complete. Do you wish to launch your SNApp? [y/N]: "
    read answer
    if [[ $answer != "y" ]]; then
        echo "SNApp not launched. Exiting installation"
        exit 0
    fi
    install_log "SNApp Launching"
    echo -n "SNApp Launching"
    sudo screen -S snapp -d -m python3 -m http.server --bind localhost.loki 80 --directory $snapp_dir
    exit 0 || install_error "Unable to exit"
}

function install_pihost() {
    display_welcome
    update_system_packages
    install_dependencies
    create_user
    create_webpage_directory
    download_latest_files
    change_file_ownership
    display_lokiaddress
    install_complete
}
