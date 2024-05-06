
#Discover the SIDs from user
$newLabelnName = hostname

#create SID array
$usersSID = @()
$usersSID += Get-ChildItem "hklm:software/microsoft/windows nt/currentversion/profilelist/S-1-5-21-*" | % pschildname

$winUsers = @()
$winUsers += (Get-ItemProperty -Path 'hklm:software/microsoft/windows nt/currentversion/profilelist/S-1-5-21-*' | % ProfileImagePath).ToUpper().Trim('C:\USERS\')


    Write-Host "Array SID created with size of"$usersSID.length
    Write-Host "Array Win-Users created with size of"$winUsers.length
    Write-Host "Nome do PC"$newLabelnName
	
   foreach ($user in $winUsers){
        #Discover the SID from user
        $sidUser = ls 'hklm:software/microsoft/windows nt/currentversion/profilelist' | ? {$_.getvalue('profileimagepath') -match $user} | % pschildname
        Write-Host "The user:"$user " - has the following SID defined:"$sidUser
    }
