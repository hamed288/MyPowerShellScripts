#################################################################################
# DL Members V. 1.1                                                             #
# Before running the script connect to Exchange Online (Connect-ExchangeOnline) #
#################################################################################

$input = Read-Host "Enter DL email address"
$DLfilename = "SubDLs-" + (Get-DistributionGroup $input).Name +".csv"
$Membersfilename = "Members-" + (Get-DistributionGroup $input).Name +".csv"

Write-Host -ForegroundColor Green "====== These are your export files ======"
$DLfilename
$Membersfilename

$dlmember = Get-DistributionGroupMember $input

$dls = @()
$users = @()

While ($dlmember.count -ne "0") {
    $temp = @()
    foreach ($member in $dlmember) {
        If ($member.RecipientType -eq "MailUniversalDistributionGroup") {
                
                $dls += New-Object psobject -Property @{
                Email = $member.PrimarySmtpAddress
                DisplayName = $member.DisplayName
                }

                $temp += Get-DistributionGroupMember $member.PrimarySmtpAddress
                #$temp
        }

        Elseif ($member.RecipientType -eq "UserMailbox") {
                
                $users += New-Object psobject -Property @{
                Email = $member.PrimarySmtpAddress
                DisplayName = $member.DisplayName
                }

        }
    }
    $dlmember = $temp
} 

Write-Host -ForegroundColor Green "====== Here is the list of all "$dls.count" nested DLs ======"
$dls | ft

Write-Host -ForegroundColor Green "====== Here is the list of all "$users.count" members ======"
$users | ft 

$dls | Export-Csv $DLfilename -NoTypeInformation
$users | Export-Csv $Membersfilename -NoTypeInformation

