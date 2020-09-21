#!/bin/bash

RLOGIN='ssh'

TIMESTAMP=$(data +"%m-%d-%Y-%H:%M") 
# This is used to append the current time onto the beginning of the log.

function reboot-env()

{

    for HOST in $ENVHOSTS ; do
    # Begins for loop

    printf "Getting and logging selinux status for $HOST ...\n" 2>&1 | tee -a $TIMESTAMP-$PRODUCT-reboot.log
    # The tee -a command sends the above text to the log and the screen.
    
    printf "\n" | tee -a $TIMESTAMP-$PRODUCT-reboot.log
   
    $RLOGIN $HOST sudo sestatus 2>&1 | tee -a $TIMESTAMP-$PRODUCT-reboot.log

    printf "\n" | tee -a $TIMESTAMP-$PRODUCT-reboot.log

    printf "\n"

    printf "Getting ready to reboot $HOST...\n"

    printf "\n

    ssh -t $HOST "sudo reboot -f" & 
    # The & enables the script to continue after rebooting a remote host.

    printf "\n" | tee -a $TIMESTAMP-$PRODUCT-reboot.log

    sleep 120 
    # This tells the script to pause 120 seconds, to give the rebooted server time to respond to the corresponding commands.

    printf "Uptime for $HOST is ...\n" | tee -a $TIMESTAMP-$PRODUCT-reboot.log
    # This is for checking to see if the host actually rebooted.

    printf "\n" | tee -a $TIMESTAMP-$PRODUCT-reboot.log

    printf "Getting and logging selinux status for $HOST after the reboot ...\n" 2>&1 | tee -a $TIMESTAMP-$PRODUCT-reboot.log
       
    printf "\n" | tee -a $TIMESTAMP-$PRODUCT-reboot.log

    printf "Getting and logging status of services for $HOST after reboot...\n" 2>&1 | tee -a $TIMESTAMP-$PRODUCT-reboot.log

    $RLOGIN $HOST ls -l /var/www/files 2>&1 | tee -a $TIMESTAMP-$PRODUCT-reboot.log

    printf "\n" | tee -a $TIMESTAMP-$PRODUCT-reboot.log

done 
# Ends the for loop...

}

# Ends the reboot-env function...

function pass-env() {

    # This function passes the name of the log, which servers to run against and which environment to run against.

    if [ "$1" = "staging" ]
    # Starts the if statement...

    # The value of "$1" is being passed to this function by the set-env function, which is defined below.

    then 

     PRODUCT="STG-yourapplication-fileserver"
     # This is passed for the name of the log, which is pre-pended with the date and time.

     ENVHOSTS=`awk -F "=" '/stagingfileserver/ { print $2}' servers.cfg'
     # This uses awk to read in the fileservers in the servers.cfg file that match the pattern between / /.
     # In the case, awk is using "=" as the delimiter.

     reboot-env "$PRODUCT" "$ENV"
     # This calls the reboot-env function and passes the above parameters to it.

    elif [ "$1" = "prod" ]

    then

     PRODUCT="PROD-yourapplication-fileserver"

     ENVHOSTS=`awk -F "=" '/prodfileserver/ { print $2}' servers.cfg'

     reboot-env "$PRODUCT" "$ENV"

    else

      printf "You didn't specify a requested environment, this script will now exit.\"

      printf "\n"

      exit 1
      # 1 will return a failed status, 0 returns a succeeded status, in case this is needed.

    fi
    # Ends the if statement...

}

# Ends the passenv function...

function setenv() {

  # This function gets the environment from the getenv function defined below.

  # This function then calls the pass-env function and passes it the environment value it received from the getenv function.

  pass-env $ENV

  printf "\n"

}

# Ends the setenv function...

function getenv() {
 
  # This function really starts the whole script, by getting the environment variable typed in at the command line.

  # The environment variable is then passed to the above setenv function.

  read -p "Please enter the environment as staging or prod...`echo $'\n> '`" ENV
  # This gets the environment variable typed in at the command line.

  # This variable is then passed to the setenv function, which passes it to the pass-env function.

  # Finally, the pass-env function passes the environment and list of servers to the reboot-env function.

  # The `echo $'\n> '` command creates a newline and a prompt for the user to enter the environment variable.

  printf "You entered $ENV.\n"
  # This gives the script user feedback on screen for what they typed in.

  printf "\n"

  setenv $ENV
  # This calls the setenv function and passes it the typed in environment variable.

}
  # Ends the getenv function definition...

getenv

# This kicks off the entire script by getting the environment variable from the user.
