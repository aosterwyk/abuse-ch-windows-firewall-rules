# Botnet Blocklist IPs Firewall Rules Sync Script v1.1
# https://github.com/aosterwyk/feodo-tracker-blocklist-firewall-rules

param (
    [switch]$update
)

if($update) { 
    Write-Host -ForegroundColor Cyan "Running git pull to check for updates"
    Start-Process "git" -ArgumentList "pull" -Wait
    Write-Host -ForegroundColor Green "Done"
}

$excludedIPs = @()
# $excludedIPs = @("1.1.1.1", "1.0.0.1")

$blockListURL = "https://www.spamhaus.org/drop/drop_v4.json"
$result = Invoke-RestMethod $blockListURL

Write-Host "Removing old Botnet Blocklist IPs firewall rules"
Remove-NetFirewallRule -DisplayName "Botnet Blocklist IPs" -ErrorAction SilentlyContinue 

$IPList = @()

$blockList = $result -Split "`n"

$blockList | ForEach-Object {
    $item = ConvertFrom-Json $_
    $IP = $item.cidr

    if($IP.length -gt 6) { 
        if($excludedIPs -contains $IP) {
            write-host -ForegroundColor Yellow "$($IP) is in excluded list. Skipping."
            return
        }
        write-host "Adding $($IP) to IP list"        
        $IPList += $IP 
    }
}

Write-Host "Creating Windows Firewall rule"
New-NetFirewallRule -DisplayName "Botnet Blocklist IPs" -Direction Outbound -RemoteAddress $IPList | Out-Null
