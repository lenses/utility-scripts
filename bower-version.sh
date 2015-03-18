#!/usr/bin/env bash



ROOT=../
ELEMENT_PREFIX="lens*"
yellow='\033[0;33m'
red='\033[0;31m'
NC='\033[0m' # No Color

if [ $# -lt 2 ]; then
echo "";
#echo "-------------------------------------------------------------- "
echo "";
echo "Usage 1: $0 getdependency-name";
echo "Usage 2: $0 update dependency-name new-version [--gp]";
echo "";
echo "get: to get all versions of the dependency in different bower files";
echo "update: to update all versions of the dependency in different bower files [--gp option pushes changes to github]";
echo "";
#echo "-------------------------------------------------------------- "
exit 1;
fi

getVersion () {
	cd $ROOT
	prevVersion=""

	bower_files=`find $ELEMENT_PREFIX -name bower.json`
	for bower in $bower_files;
	do
		grepDependency="\"$1\"\s*:\s*\"[a-zA-Z0-9\-]*/$1"  #looking for "dependency":"[organization]/dependency"
		grepVersion="#[\^~=](\d.\d.\d)"  #looking for #version"

		version=$(grep $grepDependency $bower | egrep -o $grepVersion)

		newVersionAlert=""

		if [ "$prevVersion" != "$version" ]; then 
    		newVersionAlert="${red} found new version $version ${NC}"
			#echo "version: $version"
		fi;

		echo -e "'$1' version in $bower is ${yellow} $version ${NC} $newVersionAlert"

		prevVersion=$version


	done
}


updateVersion () {
	cd $ROOT

	bower_files=`find $ELEMENT_PREFIX -name bower.json`
	for bower in $bower_files;
	do
		grepDependency="\"$1\"\s*:\s*\"[a-zA-Z0-9\-]*/$1"  #looking for "dependency":"[organization]/dependency"
		grepVersion="#[\^~=](\d.\d.\d)"  #looking for #version"

		grepDirectory="${bower/\/bower\.json/}"


		version=$(grep $grepDependency $bower | egrep -o $grepVersion)

		newVersion="#$2"

		

		if [ "$version" ] && [ "$newVersion" ] && [ "$newVersion" != "$version" ]; then 
			verReplace="s/$version/$newVersion/g"
			echo -e "changing $1 version in ${yellow}$bower${NC} from ${yellow}$version${NC} to ${yellow}$newVersion${NC}"
			TMP_FILE=`mktemp /tmp/config.XXXXXXXXXX`
			sed -e "$verReplace" $bower > $TMP_FILE
			
			mv $TMP_FILE $bower
			
			if [ "$3" = "--gp" ]; then
				echo -e "${yellow}pushing to github${NC}"
				git -C $grepDirectory commit . -m "updating $1 version from $version to $newVersion"
				#git -C $grepDirectory push origin master
			fi
		else
			echo -e "$bower has the correct version $2"
		fi;



	done
}


case "$1" in
       get)
            echo "getting versions..."
            getVersion $2
            exit 0
            ;;
        
        update)
			echo "updating versions..."
			updateVersion $2 $3 $4
			exit 0
			;;
         
        *)
            echo "Usage: $0 get|update dependency-name"
            exit 1 

 esac



