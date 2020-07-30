# fetchWlcBackup.sh
Script to order a cisco WLC9800 to generate a backup and send it to a SFTP server

# Word of wisdom
This was made for a WLC9800, considering SFTP upload. This may work with other WLC versions or may need a bit of tweaking.
Also, if you opt for something else than SFTP for upload, you will have to manually edit some lines, but the core of the script should still work fine

#Known bug (but not mine)
Upen sending the SFTP command, you WILL receive from WLC an error such as : 
```
"errorText":"**CLI Line # 2: Address or name of remote host [10.0.0.1]? \r\n**CLI Line # 2: Destination filename [test\/\/mywlc.localnet-20200730-154625.cfg]? \r\n**CLI Line # 2: SFTP send: Writing to \/home\/user\/test\/\/myqlc.localnet-20200730-154625.cfg size 26867\r\n**CLI Line # 2: !\r\n**CLI Line # 2: 26867 bytes copied in 0.126 secs (213230 bytes\/sec)","status":"invalid"},{"cli":"delete bootflash:config.txt","status":"invalid"},{},{},{},{}]
```
However, this is normal output from WLC and the upload was done all the same
