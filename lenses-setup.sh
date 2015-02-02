#!/usr/bin/env bash



ROOT=~/Documents
HOME_DIR="$ROOT/lenses"
COMPOSER="th-connector" #lens-composer
GIT_ORG="thelmanews"  #lenses
COMPOSER_DIR="$HOME_DIR/$COMPOSER"

if [ $# -eq 0 ]; then
echo "";
#echo "-------------------------------------------------------------- "
echo "";
echo "Usage: $0 setup|run-server|update|kill-server";
echo "";
echo "setup: To setup the Lenses environment in $HOME_DIR";
echo "run-server: To run server";
echo "update: To update environment with latest code";
echo "kill-server: To shut down server";
echo "";
#echo "-------------------------------------------------------------- "
exit 1;
fi


setup () 
{

	if test -w $HOME_DIR; then
	  if test -w $HOME_DIR.bak; then
	  	echo "Directory $HOME_DIR and backup directory $HOME_DIR.bak both exist. Backup or delete either one to run. bye."
	  	exit 1
	  fi
	  mv -f $HOME_DIR $HOME_DIR.bak 
	  echo "Your original $HOME_DIR has been backed up to $HOME_DIR.bak"
	fi
	echo "Creating director $HOME_DIR for local lenses installation"
	mkdir -p $HOME_DIR 
	cd $HOME_DIR
	pwd
	git clone git@github.com:$GIT_ORG/$COMPOSER
	cd $COMPOSER_DIR
	pwd
	bower install

	startServer

	#kill $(ps aux | grep 'python -m SimpleHTTPServer 8000' | awk '{print $2}')


	#exit 0
}

startServer () 
{


	cd $HOME_DIR
	echo "shutting down already running server..."
	kill $(ps aux | grep 'python -m SimpleHTTPServer 8000' | awk '{print $2}')
	echo "running python server in background"
	#nohup python -m SimpleHTTPServer 8000 &
	nohup python -m SimpleHTTPServer 8000  0<&- &>/dev/null &
	echo "Python is running on port 8000. Lenses app is at http://localhost:8000/$COMPOSER/demo.html"

}

updateWorkspace () 
{
	echo "Running update will pull changes from server. It will not touch the components you have created but may erase your local modifications (like changes to th-component-list. Do you want to continue? (yes/no)"
	read continueUpdate
	if [ $continueUpdate == "yes" ]; then
		cd $COMPOSER_DIR
		git pull origin master
		bower update
	else
		echo "Aborting..."
	fi
	


}



echo $1

case "$1" in
       setup)
            echo "setup"
            setup
            exit 0
            ;;
        
        run-server)
			echo "running server"
			startServer
			exit 0
			;;

		update)
			echo "updating workspace"
			updateWorkspace
			exit 0
			;;

        kill-server)
        	echo "turning off python server"
        	kill $(ps aux | grep 'python -m SimpleHTTPServer 8000' | awk '{print $2}')
        	exit 0
        	;; 
         
        *)
            echo $"Usage: $0 {setup|run-server|update|kill-server}"
            exit 1 

 esac
