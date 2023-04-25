#Needs User.Readwrite.all permission scope to create users 
Connect-MgGraph


[string]$delete_or_create = Read-Host -Prompt "Create(C) or Delete Employee(D)? "

if ($delete_or_create -ne "C" -and $delete_or_create -ne "D"){
    Write-Host "Enter C or D"
    Stop-Process
   
}
$first_name = Read-Host -Prompt "Enter Employee's First Name"
$last_name = Read-Host -Prompt "Enter Employee's Last name"

#########
#creates a temporary password
#########
$alphabet = @("A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z")
$numbers = @(0,
1,
2,
3,
4,
5,
6,
7,
8,
9)
$pass = ""
for($i = 0; $i -lt 2; $i++){
    if($i -eq 0){
    for($z = 0; $z -lt 3; $z++){
        if($z -eq 1 -or $z -eq 2){
        $lowercase_pw = $alphabet | Get-Random
        $pass += $lowercase_pw.ToLower()
        }
        else{
        $pass += $alphabet | Get-Random
        }
        }
    }
    else{
    for($j = 0; $j -lt 5; $j++){
        $pass += $numbers | Get-Random
        }
    }
    
}
##########################################################################
#update pass: Update-MgUserPassword -UserId $userId -BodyParameter $params
##########################################################################

#creates a dictionary to be passed as attributes
$PasswordProfile = @{
    Password = $pass
    ForceChangePasswordNextSignIn = $true
    ForceChangePasswordNextSignInWithMfa = $true
}

#stores first and last name into $user_display
[string]$user_display = "{0} {1}" -f $first_name, $last_name
#gets upn from first and last names input and converts to lowercase and stores them into $user_principal_name
$user_principal_name = "{0}.{1}@nw-its.com" -f $first_name.ToLower(),$last_name.ToLower()
#
$mail_nickname = "{0}.{1}" -f $first_name, $last_name

if ($delete_or_create -eq "C"){
New-MgUser -DisplayName $user_display -PasswordProfile $PasswordProfile -UserPrincipalName $user_principal_name -MailNickname $mail_nickname -AccountEnabled -UsageLocation US
Write-Host "Successfully Created $user_display! with password $pass"
Invoke-Item "C:\Users\SonNguyen\OneDrive - Nationwide It Services, Inc\Documents\Custom Office Templates\Nationwide IT Services Account Setup and IT Onboarding Information - .msg"
}

if ($delete_or_create -eq "D"){
    $user_delete = Get-MgUser -filter "displayname eq '$user_display'"
    Remove-MgUser -UserId $user_delete.id -confirm
    Write-Host "Successfuly deleted $user_display!" 
    
}
