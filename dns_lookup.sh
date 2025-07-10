#!/bin/bash

#checking if count of parameters is greater than 1 then display error and quit
if [ "$#" -gt 1 ]; then
	echo "Too many parameters entered"
	exit
fi

#checking if no parameters are entered
if [ -z "$1" ]; then
	#loop to keep executing code till user quits
	while true; do
		#displaying menu
		echo Please select the option you want to process:
	    	echo 1 Input a domain name
	    	echo 2 Quit the program
    		
    		#taking user input in choice
	    	read choice
	    	
	    	#case statements to check choice and perform appropriate action
	    	case "$choice" in
		"1")
			#when choice in one take user input for domain
			echo Enter domain name
			read domain
			
			#use host command to print IP address against that domain
			echo IP address: 
			host $domain
			echo -------------------------
			;;
		"2") 
			#when choice is 2 quit program
			echo Exitting program
			exit
			;;
		*)
			#any choice other than 1 or 2 is invalid
			echo Invalid input
			;;
		esac
	done
	exit
fi

#when a filename is passed as parameter store it
filename=$1

#checking if file exists
if !(test -e "$filename"); then
	echo File does not exist
	exit
fi

#checking if extension is txt
if [ "${filename#*.}" != "txt" ]; then
	echo File is not text file
	exit
fi

#reading file line by line
while IFS= read -r domain
do
	#storing line in domain variable and displaying it
	echo Domain: "$domain"
	echo -n IP Address: 
	
	#writing output of host to temp.txt
	host "$domain" > temp.txt
	
	#using grep to read data from temp.txt and display the ip addresses only
	grep -o "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*" "temp.txt"
	echo --------------------------------------	
done < $filename

#deleting temp.txt
rm temp.txt

