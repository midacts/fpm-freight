#!/bin/bash
# FPM with Freight Installation Script
# Date: 20th of May, 2014
# Version 1.0
#
# Author: John McCarthy
# Email: midactsmystery@gmail.com
# <http://www.midactstech.blogspot.com> <https://www.github.com/Midacts>
#
# To God only wise, be glory through Jesus Christ forever. Amen.
# Romans 16:27, I Corinthians 15:1-4
#---------------------------------------------------------------
function installFPM(){
	# Prerequisite Software
		echo
		echo -e '\e[01;34m+++ Installing the prerequisite software...\e[0m'
		apt-get update
		apt-get -y install build-essential git ruby-dev
		echo -e '\e[01;37;42mThe prerequisite software has been successfully installed!\e[0m'

	# Download the latest fpm files from Jordan Sissel's Github repo
		echo
		echo -e '\e[01;34m+++ Downloading the latest FPM files...\e[0m'
		cd
		git clone https://github.com/jordansissel/fpm
		echo -e '\e[01;37;42mThe latest fpm files have been successfully downloaded!\e[0m'

	# Change to the newly downloaded fpm directory
		cd fpm

	# Install FPM
		echo
		echo -e '\e[01;34m+++ Installing FPM...\e[0m'
		gem install fpm
		echo -e '\e[01;37;42mFPM has been successfully installed!\e[0m'
}
function installFreight(){
	# Add Richard Crowley's repo to your apt sources
		echo
		echo -e '\e[01;34m+++ Downloading rcrowley'\''s rcrowley.list and GPG files...\e[0m'
		cd
		echo "deb http://packages.rcrowley.org $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/rcrowley.list

	# Download Richard Crowley's GPG key for his repo
		wget -O /etc/apt/trusted.gpg.d/rcrowley.gpg http://packages.rcrowley.org/keyring.gpg
		echo -e '\e[01;37;42mThe rcrowley.list and GPG files have been successfully downloaded!\e[0m'

	# Update your apt sources.list
		echo
		echo -e '\e[01;34m+++ Updating repos...\e[0m'
		apt-get update
		echo -e '\e[01;37;42mThe repos have been successfully updated!\e[0m'

	# Install freight
		echo
		echo -e '\e[01;34m+++ Installing freight...\e[0m'
		apt-get -y install freight
		echo -e '\e[01;37;42mFreight has been successfully installed!\e[0m'
}
function configFreight(){
	# Renames the freight.conf file
		echo
		echo -e '\e[01;34m+++ Editing freight.conf file...\e[0m'
		mv /etc/freight.conf.example /etc/freight.conf

	# For VM machines, this helps when creating certs or things that require lots of random data (Otherwise things like this tend to hang)
		mv /dev/random /dev/chaos
		ln -s /dev/urandom /dev/random

	# Editing the freight.conf file
		echo
		echo -e '\e[33mPlease type in the email address of your GPG key provider:\e[0m'
		echo -e '\e[33;01mFor Example:  example@example.com\e[0m'
		read gpg
		sed -i 's/example@example.com/'"$gpg"'/g' /etc/freight.conf
		echo -e '\e[01;37;42mThe freight.conf file has been successfully edited!\e[0m'

	# Creates your GPG key
		echo
		echo -e '\e[01;34m+++ Creating your GPG key...\e[0m'
		gpg --gen-key

	# Updates your apt sources
		apt-get update
		echo -e '\e[01;37;42mYour GPG key has been successfully created!\e[0m'
}
function configApache2(){
	# Install the required packages
		echo
		echo -e '\e[01;34m+++ Installing Apache2...\e[0m'
		apt-get -y install apache2
		echo -e '\e[01;37;42mApache2 has been successfully installed!\e[0m'

	# Makes a backup of your current default site file
		cp /etc/apache2/sites-available/default /etc/apache2/sites-available/default.BAK

	# Assigns yours email to a variable
		echo
		echo -e '\e[33mWhat would you like to use as the ServerAdmin'\''s email address ?\e[0m'
		read email

	# Modifies the default site to point to the freight repo directory and to use your email address
		sed -i 's@/var/www@/var/cache/freight@g' /etc/apache2/sites-available/default
		sed -i 's/ServerAdmin webmaster@localhost/ServerAdmin '"$email"'/g' /etc/apache2/sites-available/default

	# Restart the apache2 service
		echo
		echo -e '\e[01;34m+++ Restarting the Apache service...\e[0m'
		service apache2 restart
		echo -e '\e[01;37;42mThe apache service has been successfully restarted!\e[0m'

}
function doAll(){
	# Calls Function 'installFPM'
		echo -e "\e[33m=== Install FPM ? (y/n)\e[0m"
		read yesno
		if [ "$yesno" = "y" ]; then
			installFPM
		fi

	# Calls Function 'installFreight'
		echo
		echo -e "\e[33m=== Install Freight ? (y/n)\e[0m"
		read yesno
		if [ "$yesno" = "y" ]; then
			installFreight
		fi

	# Calls Function 'configFreight'
		echo
		echo -e "\e[33m=== Configure Freight ? (y/n)\e[0m"
		read yesno
		if [ "$yesno" = "y" ]; then
			configFreight
		fi

	# Calls Function 'apache2'
		echo
		echo -e "\e[33m=== Configure apache to host your repo ? (y/n)\e[0m"
		read yesno
		if [ "$yesno" = "y" ]; then
			configApache2
		fi

	# End of Script Congratulations, Farewell and Additional Information
		clear
		FARE=$(cat << EOZ


         \e[01;37;42mWell done! You have completed your FPM/Freight Installation! \e[0m

                           \e[01;30mCreate a \e[01;37mpackage\e[01;30m with \e[01;37mFPM\e[01;30m.\e[0m

                    \e[01;30mAdd the package to your Freight repo with\e[0m
                        \e[01;30m"\e[01;37mfreight add\e[01;30m" and "\e[01;37mfreight cache\e[01;30m"\e[0m


          \e[01;30mThen add your Freight repo to another machine's sources.list\e[0m
        \e[01;37mhttps://github.com/Midacts/freightrepo/blob/master/freightrepo.sh\e[0m

         \e[01;30mand you can begin installing packages from your Freight repo.\e[0m

 
 
  \e[30;01mCheckout similar material at midactstech.blogspot.com and github.com/Midacts\e[0m

                            \e[01;37m########################\e[0m
                            \e[01;37m#\e[0m \e[31mI Corinthians 15:1-4\e[0m \e[01;37m#\e[0m
                            \e[01;37m########################\e[0m
EOZ
)

		#Calls the End of Script variable
		echo -e "$FARE"
		echo
		echo
		exit 0
}

# Check privileges
[ $(whoami) == "root" ] || die "You need to run this script as root."

# Welcome to the script
clear
echo
echo
echo -e '       \e[01;37;42mWelcome to Midacts Mystery'\''s FPM with Freight Installation Script!\e[0m'
echo
echo
case "$go" in
        * )
                        doAll ;;
esac

exit 0
