#!/bin/bash


########## Variable definitions ##########
#Set a bunch of option to match your environment
device='mywlc9800.localnet'
userpass='admin:cisco' #username and password to open webgui
sftpServer='10.0.0.1'
sftpUsername='backup'
sftpPassword='password'
sftpPath='/' #Caution ! Sftp root directory is sftpUsername's home directory, not actual server root directory

#Set the name under which the backup should be generated
date=`date +%Y%m%d-%H%M%S`
fileName="$device-$date.cfg"


#Set curl verbosity swithc if needed
v=''
#v='-v '

########## cURL calls ##########

#first, log into webui and save cookies (one of them contains authentication session string)
curl -k -L $v \
--user "$userpass" \
--referer "https://$device/webui/" \
-A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.106 Safari/537.36" \
--cookie cookies.txt --cookie-jar cookies.txt \
https://$device/webui/index.html

#Then, asks for DeviceCapability, as this calls generate a CSRF token. Store headers containing said token in a file.
curl -k -D headers.txt $v -L \
--cookie cookies.txt --cookie-jar cookies.txt \
--referer "https://$device/webui/" \
-A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.106 Safari/537.36" \
https://$device/webui/rest/getDeviceCapability

#Extract csrf token from headers
csrfToken=`grep X-Csrf-Token headers.txt`

#Call the Backup generation function
curl -k $v -L \
--cookie cookies.txt --cookie-jar cookies.txt \
--header "Content-Type: application/json" \
--header "$csrfToken" \
--referer "https://$device/webui/" \
-A "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/83.0.4103.106 Safari/537.36" \
--request POST \
--data "{\"uploadFileType\":\"Configuration\",\"uploadConfigFileType\":\"startup-config\",\"uploadFilePath\":\"$sftpPath\",\"uploadProtocol\":\"SFTP\",\"uploadUserName\":\"$sftpUsername\",\"uploadPassword\":\"$sftpPassword\",\"uploadIPAddress\":\"$sftpServer\",\"uploadFileName\":\"$fileName\",\"opType\":\"upload\",\"platformType\":\"vwlc\",\"applyBackup\":\"Off\"}" \
https://$device/webui/resource/commandsFeature

#cleanup
rm headers.txt cookies.txt
