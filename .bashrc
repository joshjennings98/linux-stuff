# Functions
megacd()
{
    # cd into directory and list files
    cd "$1" && ls
}

flash_keyboard()
{

if [ "$1" == "-h" ] || [ "$1" == "--help" ]

then
	echo "Add -i or --install to install dfu programmer."
	echo "Add -f or --flash to flash to file in second argument."
	echo "Add -h or --help to list help."
fi

if [ "$1" == "-i" ] || [ "$1" == "--install" ]

then
	git clone https://github.com/dfu-programmer/dfu-programmer.git # get the files for the dfu programmer

	cd dfu-programmer       # change to the top-level directory

	# If the source was checked-out from GitHub, run the following command.
	# You may also need to do this if your libusb is in a non-standard location,
	# or if the build fails to find it for some reason.  This command requires
	# that autoconf is installed (sudo apt-get install autoconf)

	./bootstrap.sh          # regenerate base config files

	# Optionally you can add autocompletion using the dfu_completion file,
	# and possibly instructions provided after running the ./bootstrap command

	./configure             # regenerate configure and run it

	# Optionally you can specify where dfu-programmer gets installed
	# using the --prefix= option to the ./configure command.  See
	# ./configure --help for more details.

	# By default the build process will use libusb-1.0 if available.
	# It tries to auto-discover the library, falling back to the older
	# libusb if libusb-1.0 is not available. This process is not entirely
	# reliable and may decide that libusb-1.0 is available when in fact
	# it is not. You can select libusb using --disable-libusb_1_0. If
	# usb library is not available try getting libusb-1.0-0-dev

	make                    # build dfu-programmer

	# Become root if necessary

	make install            # install dfu-programmer
fi

if [ "$1" == "-f" ] || [ "$1" == "--flash" ]

then
	sudo dfu-programmer atmega32u4 erase
	sudo dfu-programmer atmega32u4 flash $2
	sudo dfu-programmer atmega32u4 reset
fi

}

# Misc
alias ls='ls --color=auto' # So ls is coloured correctly
alias cd='megacd'

# Aliases for commands
alias reloadbashrc='source ~/.bashrc'
alias resetwifi='sudo /etc/init.d/network-manager restart'
alias p='python3'
alias pingtest='ping 8.8.8.8 -c 4'
alias cd..='cd ..' # Cause I get this wrong often enough for this to be useful
alias flashkb='flash_keyboard'

# Aliases for directories
alias docs='cd ~/Documents/ && ls'
alias home='cd ~/ && ls'
alias ..='cd ..'




# Virtual Environment Wrapper
source /usr/local/bin/virtualenvwrapper.sh

# Install Ruby Gems to ~/gems
export GEM_HOME="$HOME/gems"
export PATH="$HOME/gems/bin:$PATH"
