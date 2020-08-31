#Adobe Sync Module
#Benjamin Nichols 8/24/2020

<#
    .Synopsis
    Manage Adobe Named Users in Active Directory

    .Description
    Moves Adobe users from Powerschool CSV file to appropriate AD groups. Also can remove previous users from said groups.
    Benjamin Nichols 8/2020

    .Parameter CsvFile
    The Powerschool CSV File with Adobe Users

    .Parameter RemoveUsers
    Removes Users from All Adobe Named User AD groups

    .Example
    #Remove All Adobe Named Users from AD Groups
    Sync-Adobe -RemoveUsers

    .Example
    #Remove All Adobe Named Users frome AD Groups and update groups with CSV file
    Sync-Adobe -CsvFile ".\file.csv" -RemoveUsers

#>
function Sync-Adobe{
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        [Parameter(Mandatory = $false)]
        [String[]] $CsvFile,

        [switch] $RemoveUsers = $false
    )

    #Remove all users from Adobe Groups if flag is set. Uses Regex to only remove students.
    if ($RemoveUsers){
        Get-ADGroupMember "JCS VDI - Adobe Named" | ForEach-Object {
            if ($_.Name -match '[0-9]'){
                Remove-ADGroupMember "JCS VDI - Adobe Named" $_ -Confirm:$false
            } 
        }
        Get-ADGroupMember "CLHS VDI - Adobe" | ForEach-Object {
            if ($_.Name -match '[0-9]'){
                Remove-ADGroupMember "CLHS VDI - Adobe" $_ -Confirm:$false
            }
        }
        Get-ADGroupMember "CHHS VDI - Adobe" | ForEach-Object {
            if ($_.Name -match '[0-9]'){
                Remove-ADGroupMember "CHHS VDI - Adobe" $_ -Confirm:$false
            }
        }
        Get-ADGroupMember "CVHS VDI - Adobe" | ForEach-Object {
            if ($_.Name -match '[0-9]'){
                Remove-ADGroupMember "CVHS VDI - Adobe" $_ -Confirm:$false
            }
        }
        Get-ADGroupMember "WJHS VDI - Adobe" | ForEach-Object {
            if ($_.Name -match '[0-9]'){
                Remove-ADGroupMember "WJHS VDI - Adobe" $_ -Confirm:$false
            }
        }
    }
        
    #import CSV file and create log file
    if($CsvFile){
        $csv = Import-Csv $CsvFile
        }
    Out-File -FilePath "C:\_Install\AdobeLog $(get-date -f yyyy-MM-dd).log"
    $logfile = "C:\_Install\AdobeLog $(get-date -f yyyy-MM-dd).log"

    ##Parse the CSV file for student names and IDs, then format into correct username formatting
    ForEach ($student in $csv){
       if ($student.COURSE_DESCRIPTION -match 'Adobe'){
           $first = $student.STUDENT_FIRST_NAME
           $last = $student.STUDENT_LAST_NAME
           $4name = -join($first[0] , $last[0], $last[1], $last[2])

           $id = $student.STUDENT_NUMBER 
           $length = $id.Length
           $last4 = $id.Substring($length -4)
   
           $username = $4name + $last4


           #Get the School ID of the student and assign the correct AD group
           if ($student.School_ID -eq 510324){
                $group = "CLHS VDI - Adobe"
                }
           elseif ($student.SCHOOL_ID -eq 510327){
                $group = "CVHS VDI - Adobe"
                }
           elseif ($student.SCHOOL_ID -eq 510333){
                $group = "CHHS VDI - Adobe"
                }
           elseif ($student.SCHOOL_ID -eq 510406){
                $group = "WJHS VDI - Adobe"
           }
 
            #Add user to the group, write to logfile if there is an error.
            try{
                Add-ADGroupMember -Identity "JCS VDI - Adobe Named" -Members $username
                Add-ADGroupMember -Identity $group -Members $username
            }
            catch{
                "An error has occurred. Check the logfile at C:\_install"
                Add-Content -Path $logfile -Value "Error adding user: $username to group: $group"
            }
        }
    }
}


<#
    .Synopsis
    Manage Drafting Users in Active Directory

    .Description
    Moves Drafting users from Powerschool CSV file to appropriate AD groups. Also can remove previous users from said groups.
    Benjamin Nichols 8/2020

    .Parameter CsvFile
    The Powerschool CSV File with Drafting Users

    .Parameter RemoveUsers
    Removes Users from All Drafting User AD groups

    .Example
    #Remove All Drafting Users from AD Groups
    Sync-Drafting -RemoveUsers

    .Example
    #Remove All Adobe Named Users frome AD Groups and update groups with CSV file
    Sync-Drafting -CsvFile ".\file.csv" -RemoveUsers

#>
function Sync-Drafting{
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        [Parameter(Mandatory = $false)]
        [String[]] $CsvFile,

        [switch] $RemoveUsers = $false
    )

    #Remove all users from Adobe Groups if flag is set. Uses Regex to only remove students.
    if ($RemoveUsers){
        
        Get-ADGroupMember "CHHS VDI - Drafting" | ForEach-Object {
            if ($_.Name -match '[0-9]'){
                Remove-ADGroupMember "CHHS VDI - Drafting" $_ -Confirm:$false
            }
        }
        Get-ADGroupMember "CVHS VDI - Drafting" | ForEach-Object {
            if ($_.Name -match '[0-9]'){
                Remove-ADGroupMember "CVHS VDI - Drafting" $_ -Confirm:$false
            }
        }
        Get-ADGroupMember "WJHS VDI - Drafting" | ForEach-Object {
            if ($_.Name -match '[0-9]'){
                Remove-ADGroupMember "WJHS VDI - Drafting" $_ -Confirm:$false
            }
        }
    }
        
    #import CSV file and create log file
    if($CsvFile){
        $csv = Import-Csv $CsvFile
        }
    Out-File -FilePath "C:\_Install\DraftLog $(get-date -f yyyy-MM-dd).log"
    $logfile = "C:\_Install\DraftLog $(get-date -f yyyy-MM-dd).log"

    ##Parse the CSV file for student names and IDs, then format into correct username formatting
    ForEach ($student in $csv){
       if ($student.COURSE_DESCRIPTION -match 'Draft'){
           $first = $student.STUDENT_FIRST_NAME
           $last = $student.STUDENT_LAST_NAME
           $4name = -join($first[0] , $last[0], $last[1], $last[2])

           $id = $student.STUDENT_NUMBER 
           $length = $id.Length
           $last4 = $id.Substring($length -4)
   
           $username = $4name + $last4


           #Get the School ID of the student and assign the correct AD group
          
           if ($student.SCHOOL_ID -eq 510327){
                $group = "CVHS VDI - Drafting"
                }
           elseif ($student.SCHOOL_ID -eq 510333){
                $group = "CHHS VDI - Drafting"
                }
           elseif ($student.SCHOOL_ID -eq 510406){
                $group = "WJHS VDI - Drafting"
           }
 
            #Add user to the group, write to logfile if there is an error.
            try{
                Add-ADGroupMember -Identity $group -Members $username
            }
            catch{
                "An error has occurred. Check the logfile at C:\_install"
                Add-Content -Path $logfile -Value "Error adding user: $username to group: $group"
            }
        }
    }
}


<#
    .Synopsis
    Manage PLTW Users in Active Directory

    .Description
    Moves PLTW users from Powerschool CSV file to appropriate AD groups. Also can remove previous users from said groups.
    Benjamin Nichols 8/2020

    .Parameter CsvFile
    The Powerschool CSV File with PLTW Users

    .Parameter RemoveUsers
    Removes Users from All PLTW User AD groups

    .Example
    #Remove All PLTW Users from AD Groups
    Sync-PLTW -RemoveUsers

    .Example
    #Remove All Adobe Named Users frome AD Groups and update groups with CSV file
    Sync-PLTW -CsvFile ".\file.csv" -RemoveUsers

#>
function Sync-PLTW{
    [CmdletBinding(SupportsShouldProcess=$true)]
    param (
        [Parameter(Mandatory = $false)]
        [String[]] $CsvFile,

        [switch] $RemoveUsers = $false
    )

    #Remove all users from Adobe Groups if flag is set. Uses Regex to only remove students.
    if ($RemoveUsers){
        
        Get-ADGroupMember "CVHS VDI - PLTW" | ForEach-Object {
            if ($_.Name -match '[0-9]'){
                Remove-ADGroupMember "CVHS VDI - PLTW" $_ -Confirm:$false
            }
        }
        Get-ADGroupMember "CVMS VDI - PLTW" | ForEach-Object {
            if ($_.Name -match '[0-9]'){
                Remove-ADGroupMember "CVMS VDI - PLTW" $_ -Confirm:$false
            }
        }
        Get-ADGroupMember "SEMS VDI - PLTW" | ForEach-Object {
            if ($_.Name -match '[0-9]'){
                Remove-ADGroupMember "SEMS VDI - PLTW" $_ -Confirm:$false
            }
        }
        Get-ADGroupMember "SMMS VDI - PLTW" | ForEach-Object {
            if ($_.Name -match '[0-9]'){
                Remove-ADGroupMember "SMMS VDI - PLTW" $_ -Confirm:$false
            }
        }
        Get-ADGroupMember "RWMS VDI - PLTW" | ForEach-Object {
            if ($_.Name -match '[0-9]'){
                Remove-ADGroupMember "RWMS VDI - PLTW" $_ -Confirm:$false
            }
        }
        Get-ADGroupMember "SSHS VDI - PLTW" | ForEach-Object {
            if ($_.Name -match '[0-9]'){
                Remove-ADGroupMember "SSHS VDI - PLTW" $_ -Confirm:$false
            }
        }
    }
        
    #import CSV file and create log file
    if($CsvFile){
        $csv = Import-Csv $CsvFile
        }
    Out-File -FilePath "C:\_Install\PLTWtLog $(get-date -f yyyy-MM-dd).log"
    $logfile = "C:\_Install\PLTWLog $(get-date -f yyyy-MM-dd).log"

    ##Parse the CSV file for student names and IDs, then format into correct username formatting
    ForEach ($student in $csv){
       if ($student.COURSE_DESCRIPTION -match 'PLTW'){
           $first = $student.STUDENT_FIRST_NAME
           $last = $student.STUDENT_LAST_NAME
           $4name = -join($first[0] , $last[0], $last[1], $last[2])

           $id = $student.STUDENT_NUMBER 
           $length = $id.Length
           $last4 = $id.Substring($length -4)
   
           $username = $4name + $last4


           #Get the School ID of the student and assign the correct AD group
          
           if ($student.SCHOOL_ID -eq 510327){
                $group = "CVHS VDI - PLTW"
                }
            elseif ($student.SCHOOL_ID -eq 510379){
                $group = "RWMS VDI - PLTW"
                }
            elseif ($student.SCHOOL_ID -eq 510390){
                $group = "SEMS VDI - PLTW"
                }
            elseif ($student.SCHOOL_ID -eq 510397){
                $group = "SMMS VDI - PLTW"
                }
            elseif ($student.SCHOOL_ID -eq 510329){
                $group = "CVMS VDI - PLTW"
                }
            elseif ($student.SCHOOL_ID -eq 510399){
                $group = "SSHS VDI - PLTW"
                }

 
            #Add user to the group, write to logfile if there is an error.
            try{
                Add-ADGroupMember -Identity $group -Members $username
            }
            catch{
                "An error has occurred. Check the logfile at C:\_install"
                Add-Content -Path $logfile -Value "Error adding user: $username to group: $group"
            }
        }
    }
}
Export-ModuleMember -Function sync-adobe, sync-drafting, sync-PLTW