@ECHO OFF

::Case where there are no input parameters from command line
IF "%1" == "" GOTO :NOFILE

::Case where there are 2 or more input parameters form command line
IF NOT "%2" == "" GOTO :EXTRAPARAMTER

SET Filename=%1

::Checking if file doesnot exist display error and quit
IF NOT EXIST %Filename% ECHO File does not exist & GOTO :EOF

::Extracting the last three characters of the file to get the extension
SET FileExtension=%Filename:~-3%

::Matching the extension to txt to check that the file is a text file
IF NOT "%FileExtension%"=="txt" ECHO File is not a text file & GOTO :EOF

::outputfile cleared
TYPE NUL > outputfile.txt

::Loop to iterate over all domains in file
FOR /F "usebackq tokens=*" %%a IN ("%Filename%") DO (
	::Appending Domain to outputfile
	ECHO Domain: %%a>>outputfile.txt
	
	::Appending IP Address text to outputfile without newline
	ECHO |SET /P=IP Address:>>outputfile.txt
	
	::Loop to iterte over the output of nslookup and only extracting the ip addresses from the output
	FOR /F "tokens=*" %%i IN ('nslookup %%a ^| findstr /R "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*"') DO (
		::Appending IP Addresses to the outputfile
		ECHO %%i >>outputfile.txt
	)

	ECHO ------------------------------- >>outputfile.txt
)

::Clear screen
CLS

::Print outputfile
TYPE outputfile.txt

DEL outputfile.txt

GOTO :EOF


::TO handle no parameter case
:NOFILE

ECHO Please select the option you want to procees:
ECHO 1)input a domain name
ECHO 2)quit the program

::User input of choice
SET /P choice=""

::If user chooses to quit go to end of file
IF "%choice%" == "2" GOTO :EOF

::If user enters invalid input then print error and take input again
IF "%choice%" NEQ "1" IF "%choice%" NEQ "2" ECHO Invalid choice & GOTO :NOFILE

::Taking domain as user input if choice is 1. Displaying the ip addresses against that domain
SET /P Domain=Input the domain name: 

ECHO|SET /P=IP Address: 

nslookup %Domain%	
 
ECHO -------------------------------


::Displays menu again until user quits
GOTO :NOFILE


::To handle extra parameters case
:EXTRAPARAMTER

ECHO Too many parameters entered
