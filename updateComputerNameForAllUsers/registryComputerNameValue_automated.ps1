
#Check if the user running the script has Administrator rights
IF (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] “Administrator”))
{

    Write-Warning “You DONT have Administrator rights to run this script!`nPlease re-run this script as an Administrator!”
    Break

}
#Insert user
#$userEMEA = Read-Host -Prompt 'Write your EMEA account name (value like A[numbers])'
#Create array containing all the users
$winUsers = @()
$winUsers += (Get-ItemProperty -Path 'hklm:software/microsoft/windows nt/currentversion/profilelist/S-1-5-21-*' | % ProfileImagePath).ToUpper().Trim('C:\USERS\')

#Inform label name value
#$newLabelName = Read-Host -Prompt 'Write your desired computer name label'
$newLabelName = hostname

foreach ($user in $winUsers){
        #Discover the SID from user
        $sidUser = ls 'hklm:software/microsoft/windows nt/currentversion/profilelist' | ? {$_.getvalue('profileimagepath') -match $user} | % pschildname
        #Write-Host "The SID is:"$sidUser

        #Set registry path location
        $regPathValue ="Registry::HKU\$sidUser\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}"

        #Check if this path exists (if yes, means that the user logged recently or is already logged in)
    IF(Test-Path $regPathValue){
        #Write-Host "Path exists! PATH:"$regPathValue 
        
            Write-Host -ForegroundColor DarkGreen ".... Changing computer name label for user:"$user
        #Set new label computer name
            Set-ItemProperty -Path $regPathValue -Name "(default)" -Value $newLabelName

        #Show values under path
            Get-ItemProperty -Path $regPathValue | Select-Object "(default)", PSPath | Format-List
        } ELSE {
        Write-Host -BackgroundColor DarkRed -ForegroundColor Yellow "The user $user did NOT have the computer name changed (due to not being logged in or their session being lost)."`n
        }
}