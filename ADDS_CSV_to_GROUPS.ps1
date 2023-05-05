Connect-MgGraph
#Connect-ExchangeOnline

#Imports the csv file 
$members = Import-Csv -Path 'C:\Users\SonNguyen\Desktop\2022AEAE.csv.csv' 
$empty_array = @()
foreach ($val in $members)
{
#write-output $val.name.toString();

#--------- Appends member names to the array ----------
$names = $val.Name.ToString()
$empty_array += $names 
}
for($i = 0; $i -lt $empty_array.Length; $i++){
   #splits first name and last name using the comma as the delimiter
$split_array_name = $empty_array[$i].split(',')
    #gets the name from the array's index 0 and 1 in the appropriate format: firstname.lastname@domain.com
$full_mailname = $split_array_name[1] + '.' + $split_array_name[0] + '@domain.com'
#write-output $full_mailname
    #------- Adds every name to the group 2022aeae -------
    #bypass switch is used to bypass owner check
Add-DistributionGroupMember -Identity "2022AEAE" -Member $full_mailname.ToLower().trim() -BypassSecurityGroupManagerCheck  
}


