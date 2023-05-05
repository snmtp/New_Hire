 Connect-MgGraph

#-------------------SCRIPT FOR NEW HIRES and TERMINATION-------------------------------

[string]$delete_or_create = Read-Host -Prompt "Create(C) or Delete Employee(D)? "

if ($delete_or_create -ne "C" -and $delete_or_create -ne "D"){
    Write-Host "Enter C or D"
    Stop-Process
   
}
#gets user's first and last name
$first_name = Read-Host -Prompt "Enter Employee's First Name"
$last_name = Read-Host -Prompt "Enter Employee's Last name"

###############################
##creates a temporary password#
###############################
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
    #for loop will iterate twice 
    #password will have 8 characters (3 letters and 5 numbers). First character is capitalized and the rest isn't (ex: Joe87654)
    if($i -eq 0){
    for($z = 0; $z -lt 3; $z++){
        #gets random letters for the last two letters
        if($z -eq 1 -or $z -eq 2){
            $lowercase_pw = $alphabet | Get-Random
            $pass += $lowercase_pw.ToLower()
                }
        #gets random letters for the first letter. Capitalized
        else{
            $pass += $alphabet | Get-Random
                }
        }
    }
        #gets random numbers for the rest
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
$user_principal_name = "{0}.{1}@domain.com" -f $first_name.ToLower(),$last_name.ToLower()
#sets mail nickname to firstname.lastname 
$mail_nickname = "{0}.{1}" -f $first_name, $last_name

#if user input was for create*
if ($delete_or_create -eq "C"){
#creates new user ------- Usage Location has to be enabled ---------
New-MgUser -DisplayName $user_display -PasswordProfile $PasswordProfile -UserPrincipalName $user_principal_name -MailNickname $mail_nickname -AccountEnabled -UsageLocation US
Write-Host "Successfully Created $user_display! with password $pass"
#------------- opens outlook to send an email. Optional --------------
Invoke-Item "C:\Users\SonNguyen\OneDrive\Documents\Custom Office Templates\Email_Template - .msg"
}

if ($delete_or_create -eq "D"){
    $user_delete = Get-MgUser -filter "displayname eq '$user_display'"
    Remove-MgUser -UserId $user_delete.id -confirm
    Write-Host "Successfuly deleted $user_display!" 
    
}
