#!/bin/bash

# only works if the MDM profile is removable
# if not API calls removing the MDM profile will be required

if [ `who | grep -c "$3"` -gt 0 ];
	then
		jamf removeMDMProfile
			sleep 5
		jamf mdm
			sleep 5
		jamf mdm -userLevelMdm
			sleep 5
		jamf recon
			sleep 5

		loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
		su -l $loggedInUser -c "open /Applications/Self\ Service.app/"

		exit 0

	else
		echo "ERROR: No user is logged in" 1>&2
    	exit 1 # terminate and indicate error
fi
