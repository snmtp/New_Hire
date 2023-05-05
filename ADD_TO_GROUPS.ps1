# Connect to Microsoft Graph and Exchange 
Connect-MgGraph 
Connect-ExchangeOnline 
#Connect-MicrosoftTeams


######## NOTES ####################################################
######## ERROR: Current operation is not supported on GroupmailBox
######## SOLUTION: use New-MgGroupMember instead of Add
###################################################################

[string]$user_first = Read-Host "First Name"
[string]$user_last = Read-Host "Last name"

$i = 0
########## 20 is an arbitrary number ###################
########################################################
while($i -lt 20){
    try { 
    [string]$group_add = Read-Host "Which group(s) to add"
    [string]$group_option = Read-Host "exchange-based or security (E or S)?"
    $GroupId = (Get-MgGroup -Filter "DisplayName eq '$group_add'").Id
    #do a if statement to check if group is (distro, mail-sec) or (security and 365) 
        if ($group_option -eq "E"){
        #The parameter member needs to be an EMAIL
            Add-DistributionGroupMember -Identity "$group_add" -Member "$user_first.$user_last@domain.com" -BypassSecurityGroupManagerCheck 
            Write-Host "$user_first $user_last successfully added! "
                }
        else{
            New-MgGroupMember -GroupId $GroupId -DirectoryObjectId (Get-MgUser -UserId "$user_first.$user_last@domain.com").Id
            Write-Host "Successfully added!"
                }
        $i++
        }

    catch {
     Write-Host "Error Occured"
     Write-Host $_
    }
}



