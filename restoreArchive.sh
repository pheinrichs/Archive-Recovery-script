#!/bin/bash
x=0
y=0

dir=null
dir1=null

userLength=null
dirLength=null

archiveDirectory="/usr/local/surgemail/archive_deleted/"
activeDirectory="/var/surgemail/"

read -p "Enter Username: " username 
read -r -p "$username: Are you sure? [y/N] " response

userLength=${#username} 

case $response in
[yY][eE][sS]|[yY]) 
    read -p "Enter domain: " domain 
	read -r -p "$domain: Are you sure? [y/N] " response1

	case $response1 in
	[yY][eE][sS]|[yY]) 

		read -p "Default Archive Directory[ $archiveDirectory ]? " archiveResponse 
		if [ -z "$archiveResponse" ]
		then
			archiveDirectory="/usr/local/surgemail/archive_deleted/$domain"
		else
			archiveDirectory="$archiveResponse"
		fi

		read -p "Default Active Directory [ $activeDirectory ] ? " activeResponse
		if [ -z "$activeResponse" ]
		then
			activeDirectory="/var/surgemail/$domain"
		else
			activeDirectory="$activeResponse"
		fi

		#gather paths for old archive directory and active directory
	    find=$(find $archiveDirectory | grep -r  "$username")
	    findNew=$(find $activeDirectory | grep -r  "$username")
	    echo "$activeDirectory"
	    #gather first response in grep, it always returns the root folder first which we need
	    for i in $find; do
	    	if [ $x -eq "0" ] 
	    	then
	    		dir="$i"		    		
	    	fi
			((x++))
	    done

	    for j in $findNew; do
		    	if [ $y -eq "0" ] 
		    	then
		    		dir1="$j"
		    	fi
		    	((y++))
		done

		#set dirLength to the length of the the active directory - username length 

		dirLength=${#dir1}
		dirLength=$((dirLength-userLength))

	     read -r -p "Do you want to recover the $username mailbox from $dir to $dir1? [y/N] " response3
	 		case $response3 in
			[yY][eE][sS]|[yY]) 
				#run rsync from old Dir to new active
				rsync -av --delete-during --progress --stats $dir ${dir1:0:dirLength}
				echo "complete"
			;;
			*)
			esac
	;;
	*)
	;;
	esac

;;
*)
;;
esac