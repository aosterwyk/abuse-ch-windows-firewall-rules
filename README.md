# Botnet Blocklist Firewall Rule Sync Script

[![GitHub last commit](https://img.shields.io/github/last-commit/aosterwyk/botnet-blocklist-firewall-rules)](https://github.com/aosterwyk/botnet-blocklist-firewall-rules/commits/master) 

This script is based off of an idea in [a video on The PC Security Channel](https://www.youtube.com/watch?v=7UWFJGeix_E&list=FLD_a_ArvwQLrUruC8_nw4eQ) to create outbound block rules for known botnet IPs. The script uses the [Spamhaus IPv4 block list](https://www.spamhaus.org/blocklists/do-not-route-or-peer/).

This script will
- Download the [updated list](https://www.spamhaus.org/drop/drop_v4.json)
- Delete any firewall rules named `Botnet Blocklist IPs` 
- Create new firewill rule named `Botnet Blocklist IPs` to block outbound traffic for each IP on the list

## Usage

You can run this manually or as a [scheduled task](#scheduled-task-settings). 

**Note** This script does not verify the download list. This could be vulnerable if the domain is spoofed. Use this at your own risk on networks that you trust. 

IPs can be excluded by adding them to the `$excludedIPs` object. See the commented version below it for a formatting example. 

Run the script with **-update** to run `git pull` before starting the script to keep it updated. You will need to clone this repo and keep the .git directory for this switch to work. 

### Scheduled Task Settings
This task needs to be run as an administrator ("Run with highest privileges") to create and modify rules in Windows Firewall.

Create a scheduled task with the settings below. The script is located in c:\scripts in the example.

Create task > Actions tab
    
Program/Script:

    powershell.exe

Add arguments:

    -ExecutionPolicy Bypass "c:\scripts\botnet-blocklist-firewall-rules-sync.ps1 -update"

Start in:

    c:\scripts

## License
[Apache License 2.0](https://choosealicense.com/licenses/apache-2.0/)
