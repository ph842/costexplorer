function Get-OziAuditEC2Instances
{
    param
    (
        $Region
    )

    #Initializing objects and variables
    $AllInstanceObjects = @()
    $InstanceObject = @()

    # Fetching all instances
    $Instances = (Get-EC2Instance -Region $Region -ProfileName $AWSCredentialsProfile)

    # If there's at least one instance in the current region
    if($Instances.Count -ge 1)
    {
        foreach($i in $Instances)
        {    
            # Building the InstanceObject with information coming from the AWS EC2 API
            # http://docs.aws.amazon.com/powershell/latest/reference/items/Get-EC2Instance.html 

            $InstanceObject = New-Object System.Object
            $InstanceObject | Add-Member -type NoteProperty -name Region -value $Region                    
            $InstanceObject | Add-Member -type NoteProperty -name NameTagValue -value ($i.Instances.Tags.Value | Where-Object { $_.Instances.Tags.Key -eq "Name"})
            $InstanceObject | Add-Member -type NoteProperty -name InstanceId -value $i.Instances.InstanceId
            $InstanceObject | Add-Member -type NoteProperty -name InstanceType -value $i.Instances.InstanceType
            $InstanceObject | Add-Member -type NoteProperty -name State -value $i.Instances.State.Name      
            $InstanceObject | Add-Member -type NoteProperty -name ImageId  -value $i.Instances.ImageId
            $InstanceObject | Add-Member -type NoteProperty -name StateTransitionReason -value $i.Instances.StateTransitionReason     
            $InstanceObject | Add-Member -type NoteProperty -name LaunchTime -value $i.Instances.LaunchTime
            $InstanceObject | Add-Member -type NoteProperty -name PrivateDnsName -value $i.Instances.PrivateDnsName
            $InstanceObject | Add-Member -type NoteProperty -name PrivateIpAddress -value $i.Instances.PrivateIpAddress
            $InstanceObject | Add-Member -type NoteProperty -name PublicDnsName -value $i.Instances.PublicDnsName
            $InstanceObject | Add-Member -type NoteProperty -name PublicIpAddress -value $i.Instances.PublicIpAddress
            $InstanceObject | Add-Member -type NoteProperty -name SpotInstanceRequestId -value $i.Instances.SpotInstanceRequestId
            $AllInstanceObjects += $InstanceObject
        }            
    }
    return $AllInstanceObjects
}
function Get-OziAuditEC2ReservedInstances
{
    param
    (
        $Region
    )

    #Initializing objects and variables
    $AllReservedInstanceObjects = @()
    $ReservedInstances = @()   

    # Fetching all reserved instances
    $ReservedInstances = (Get-EC2ReservedInstance -Region $Region -ProfileName $AWSCredentialsProfile)      

    if($ReservedInstances.Count -ge 1)
    {
        foreach($ri in $ReservedInstances)
        {    
            # Building the InstanceObject with information coming from the AWS EC2 API
            # http://docs.aws.amazon.com/powershell/latest/reference/items/Get-EC2Instance.html 
            $ReservedInstanceObject = New-Object System.Object
            $ReservedInstanceObject | Add-Member -type NoteProperty -name Region -value $Region                    
            $ReservedInstanceObject | Add-Member -type NoteProperty -name AvailabilityZone -value $ri.AvailabilityZone
            $ReservedInstanceObject | Add-Member -type NoteProperty -name Duration -value $ri.Duration
            $ReservedInstanceObject | Add-Member -type NoteProperty -name InstanceType -value $ri.InstanceType
            $ReservedInstanceObject | Add-Member -type NoteProperty -name State -value $ri.State 
            $ReservedInstanceObject | Add-Member -type NoteProperty -name Start -value $ri.Start
            $AllReservedInstanceObjects += $ReservedInstanceObject
        }
    }
    return $AllReservedInstanceObjects
}
function Get-OziAuditEBSVolumes
{
    param
    (
        $Region
    )    
    #Initializing objects and variables
    $AllVolumeObjects = @()
    $VolumeObject = @() 

    # Fetching all volumes        
    $Volumes = (Get-EC2Volume -Region $Region -ProfileName $AWSCredentialsProfile)

    if($Volumes.Count -ge 1)
    {
        foreach($v in $Volumes)
        {
            # Building the VolumeObject with information coming from the AWS EC2 API
            # http://docs.aws.amazon.com/powershell/latest/reference/items/Get-EC2Volume.html
            $VolumeObject = New-Object System.Object
            $VolumeObject | Add-Member -type NoteProperty -name Region -value $Region
            $VolumeObject | Add-Member -type NoteProperty -name Attachments -value $v.Attachments      
            $VolumeObject | Add-Member -type NoteProperty -name AvailabilityZone -value $v.AvailabilityZone
            $VolumeObject | Add-Member -type NoteProperty -name CreateTime -value $v.CreateTime
            $VolumeObject | Add-Member -type NoteProperty -name Iops -value $v.Iops
            $VolumeObject | Add-Member -type NoteProperty -name Size -value $v.Size
            $VolumeObject | Add-Member -type NoteProperty -name State -value $v.State
            $VolumeObject | Add-Member -type NoteProperty -name NameTagValue -value ($v.Tags.Value | Where-Object { $_.Tags.Key -eq "Name"})
            $VolumeObject | Add-Member -type NoteProperty -name VolumeId -value $v.VolumeId 
            $VolumeObject | Add-Member -type NoteProperty -name VolumeType -value $v.VolumeType
            $AllVolumeObjects += $VolumeObject              
        }
    }
    return $AllVolumeObjects
}
function Get-OziAuditEIPAddresses
{
    param
    (
        $Region
    )
    #Initializing objects and variables
    $AllAddressObjects = @()
    $AddressObject = @()

    # Getting all Elastic IPs
    $Addresses = (Get-EC2Address -Region $Region -ProfileName $AWSCredentialsProfile)

    if($Addresses.Count -ge 1)
    {
        foreach($a in $Addresses)
        {    
            # (Get-EC2Address -AllocationId "eipalloc-0a86173a" -Region us-east-1)
            $AddressObject = New-Object System.Object
            $AddressObject | Add-Member -type NoteProperty -name Region -value $Region                  
            $AddressObject | Add-Member -type NoteProperty -name AllocationId -value $a.AllocationId                
            $AddressObject | Add-Member -type NoteProperty -name AssociationId -value $a.AssociationId
            $AddressObject | Add-Member -type NoteProperty -name Domain -value $a.Domain                 
            $AddressObject | Add-Member -type NoteProperty -name InstanceId -value $a.InstanceId
            $AddressObject | Add-Member -type NoteProperty -name NetworkInterfaceId -value $a.NetworkInterfaceId
            $AddressObject | Add-Member -type NoteProperty -name NetworkInterfaceOwnerId -value $a.NetworkInterfaceOwnerId
            $AddressObject | Add-Member -type NoteProperty -name PrivateIpAddress -value $a.PrivateIpAddress
            $AddressObject | Add-Member -type NoteProperty -name PublicIp -value $a.PublicIp
            $AllAddressObjects += $AddressObject
        }            
    }      
    return $AllAddressObjects
}


function Get-OziAuditEC2Snapshots
{
    param
    (
        $Region,
        $OwnerId        
    ) 
    #Initializing objects and variables
    $AllSnapshotObjects = @()
    $SnapshotObject = @()    

    # Getting all Snapshots
    $Snapshots = (Get-EC2Snapshot -Region $Region -OwnerId $OwnerId -ProfileName $AWSCredentialsProfile)

    if($Snapshots.Count -ge 1)
    {
        foreach($s in $Snapshots)
        {  
            $SnapshotObject = New-Object System.Object
            $SnapshotObject | Add-Member -type NoteProperty -name Region -value $Region                  
            $SnapshotObject | Add-Member -type NoteProperty -name Encrypted -value $s.Encrypted
            $SnapshotObject | Add-Member -type NoteProperty -name KmsKeyId -value $s.KmsKeyId
            $SnapshotObject | Add-Member -type NoteProperty -name OwnerAlias -value $s.OwnerAlias
            $SnapshotObject | Add-Member -type NoteProperty -name OwnerId -value $s.OwnerId
            $SnapshotObject | Add-Member -type NoteProperty -name Progress -value $s.Progress
            $SnapshotObject | Add-Member -type NoteProperty -name SnapshotId -value $s.SnapshotId
            $SnapshotObject | Add-Member -type NoteProperty -name StartTime -value $s.StartTime
            $SnapshotObject | Add-Member -type NoteProperty -name State -value $s.State
            $SnapshotObject | Add-Member -type NoteProperty -name StateMessage -value $s.StateMessage
            $SnapshotObject | Add-Member -type NoteProperty -name Tags -value $s.Tags
            $SnapshotObject | Add-Member -type NoteProperty -name VolumeId -value $s.VolumeId
            $SnapshotObject | Add-Member -type NoteProperty -name VolumeSize -value $s.VolumeSize
            $AllSnapshotObjects += $SnapshotObject
        }
    }
    return $AllSnapshotObjects
}


function Show-Summary
{
    param
    (
        $AllVolumeObjects,
        $AllReservedInstanceObjects,
        $AllInstanceObjects,
        $AllAddressObjects,
        $AllSnapshotObjects      
    )

    # EC2
    Write-Output ">>>>>> EC2 Instances Globals"    
    Write-Output ">> Total number of instances: $($AllInstanceObjects.Count)"
    Write-Output ">> Total number of stopped instances: $(($AllInstanceObjects | Where-Object -Property State -eq 'stopped').Count)"
    Write-Output ">> Percentage of started instances: $((($AllInstanceObjects | Where-Object -Property 'State' -eq 'running').Count/($AllInstanceObjects.Count)).ToString('P'))"
    Write-Output ">> Percentage of stopped instances: $((($AllInstanceObjects | Where-Object -Property 'State' -eq 'stopped').Count/($AllInstanceObjects.Count)).ToString('P'))"
    Write-Output ">> Total number of active reserved instances: $(($AllReservedInstanceObjects | Where-Object -Property State -eq 'active').Count)"
    Write-Output ">>>>"  

    Write-Output "`n>>>>>> EC2 Stopped Instances list"           

    foreach($i in ($AllInstanceObjects | Where-Object -Property 'State' -eq 'stopped'))
    {
        $Date = ""
        $StoppedSinceDateObject = @()
        #$StoppedSinceHours = ""
        $StoppedSinceDays = ""

        Write-Output ">> Region: $($i.Region)"
        Write-Output ">> InstanceId: $($i.InstanceId)"        
        Write-Output ">> Name: $($i.NameTagValue)"
        Write-Output ">> Type: $($i.InstanceType)"
        Write-Output ">> Shutdown reason: $($i.StateTransitionReason)"
        $Date = $($i.StateTransitionReason).Split(" ",3).Replace("GMT","").Replace("(","").Replace(")","")[2].Split(" ").Split("-").Split(":")
        $StoppedSinceDateObject = (New-Object System.DateTime $Date[0], $Date[1], $Date[2], $Date[3], $Date[4], $Date[5])
        #$StoppedSinceHours =  $([math]::Ceiling((Get-Date).Subtract($StoppedSinceDateObject).TotalHours))
        $StoppedSinceDays =  $([math]::Round($((Get-Date).Subtract($StoppedSinceDateObject)).TotalDays,2))
        Write-Output ">> Days since shutdown: $StoppedSinceDays day(s) since shutdown (rounded)"
        
        # Volumes
        foreach($v in $AllVolumeObjects)
        {
            if($v.Attachments.InstanceId -eq $i.InstanceId)
            {
                ">> Volume attached to stopped instance: $($v.VolumeId) (Type:$($v.VolumeType)/Size:$($v.Size)GB)"
            }
        }
        #Write-Output ">> Hours billed : $StoppedSinceHours (rounded up)"        
        Write-Output ">>>>"    
    }

    # Volumes
    if($($AllVolumeObjects | Where-Object -Property State -eq "available").Count -ne 0)
    {
        Write-Output "`n>>>>>> EBS Volumes (unattached)"     
        foreach($v in $($AllVolumeObjects | Where-Object -Property State -eq "available"))
        {
            Write-Output ">> Region: $($v.Region)"         
            Write-Output ">> Volume not attached to any instance: $($v.VolumeId) (Type:$($v.VolumeType)/Size:$($v.Size)GB)"        
            Write-Output ">>>>"
        }        
    }
    else 
    {
        Write-Output "`n>>>>>> All EBS Volumes are attached"
    }

    #Addresses
    if($($AllAddressObjects | Where-Object -Property AssociationId -eq $NULL).Count -ne 0)
    {
        Write-Output "`n>>>>>> Elastic IP"         
        foreach($i in $($AllAddressObjects | Where-Object {($_.Region -eq $Region) -and ($_.AssociationId -eq $NULL)}))
        {
            Write-Output ">> Region: $($i.Region)"         
            Write-Output ">> EIP: $($i.AllocationId) is not attached to any instance"
            Write-Output ">>>>"             
        }
    }
    else 
    {
        Write-Output "`n>>>>>> All Elastic IPs are assigned"
    }

    #Snapshots
    if($($AllSnapshotObjects).Count -ne 0)
    {
        Write-Output "`n>>>>>> Snapshots older than a week"         
        foreach($s in $($AllSnapshotObjects))
        {
            #$Delay = $([datetime]::Now).AddDays(-7)
            #$SnapshotStartTime = $($s.StartTime)
            if(($s.StartTime) -lt ($([datetime]::Now).AddDays(-7)))
            { 
                Write-Output ">> Region: $($s.Region)"         
                Write-Output ">> SnapshotId: $($s.SnapshotId)"
                Write-Output ">> StartTime: $($s.StartTime)"
                #Write-Output ">> State: $($s.State)"
                #Write-Output ">> StateMessage: $($s.StateMessage)"
                #Write-Output ">> Tags: $($s.Tags)"
                Write-Output ">> VolumeId: $($s.VolumeId)"
                Write-Output ">> VolumeSize: $($s.VolumeSize)GB"
                Write-Output ">>>>" 
            }            
        }
    }
    else 
    {
        Write-Output "`n>>>>>> No existing snapshots"
    }    
}

function Show-GlobalTable
{
    param
    (
        $AllVolumeObjects,
        $AllReservedInstanceObjects,
        $AllInstanceObjects,
        $AllAddressObjects,
        $AllSnapshotObjects      
    )

    Write-Output "`n>>>>>> Grand totals and summary"     
    Write-Output "Total number of instances/volumes/EIP/Snapshots per region (total/stopped/unattached/old):"
    Write-Output ">> Region`t`tEC2-Total`tEC2-Off`t`tEBS-Total`tEBS-Unass.`tEIP-Total`tEIP-Unass.`tSnaps-Total`tSnaps-Old"

    foreach($Region in $AWSRegions)
    {

        $InstanceCountTotal = 0
        $InstanceCountStopped = 0
        $VolumeCountTotal = 0
        $VolumeCountAvail = 0
        $EIPCountTotal = 0
        $EIPCountAvail = 0
        $SnapshotsTotal = 0
        $SnapshotsOld = 0

        $InstanceCountTotal   = ($AllInstanceObjects | Where-Object { $_.Region -eq $Region}).Count
        $InstanceCountStopped = ($AllInstanceObjects | Where-Object {($_.Region -eq $Region) -and ($_.State -eq "stopped")}).Count
        $VolumeCountTotal     = ($AllVolumeObjects   | Where-Object { $_.Region -eq $Region}).Count
        $VolumeCountAvail     = ($AllVolumeObjects   | Where-Object {($_.Region -eq $Region) -and ($_.State -eq "available")}).Count
        $EIPCountTotal        = ($AllAddressObjects  | Where-Object { $_.Region -eq $Region}).Count
        $EIPCountAvail        = ($AllAddressObjects  | Where-Object {($_.Region -eq $Region) -and ($_.AssociationId -eq $NULL)}).Count
        $SnapshotsTotal       = ($AllSnapshotObjects | Where-Object { $_.Region -eq $Region}).Count
        $SnapshotsOld         = ($AllSnapshotObjects | Where-Object {($_.Region -eq $Region) -and (($_.StartTime) -lt ($([datetime]::Now).AddDays(-7)))}).Count

        if($InstanceCountStopped+$VolumeCountAvail+$EIPCountAvail+$SnapshotsOld -ge 1)
        {
            $Highlight = "Red"
        }
        else
        {
            $Highlight = "White"
        }
        if($Region.ToString().Length -gt 12)
        {
            Write-Host -ForeGroundColor $HighLight ">> $Region`t$InstanceCountTotal`t`t$InstanceCountStopped`t`t$VolumeCountTotal`t`t$VolumeCountAvail`t`t$EIPCountTotal`t`t$EIPCountAvail`t`t$SnapshotsTotal`t`t$SnapshotsOld"
        }
        else {
            Write-Host -ForeGroundColor $HighLight ">> $Region`t`t$InstanceCountTotal`t`t$InstanceCountStopped`t`t$VolumeCountTotal`t`t$VolumeCountAvail`t`t$EIPCountTotal`t`t$EIPCountAvail`t`t$SnapshotsTotal`t`t$SnapshotsOld"
        }
    }
}

$AWSCredentialsProfile = 'default'
$OwnerId = ''
$AWSRegions = (Get-AWSRegion).Region
#$AWSRegions = 'eu-central-1','us-east-1','ap-northeast-1'

# function Get-OwnerId
# {
#     param
#     (
#         $Region
#     )

#     if($OwnerId -eq $NULL)
#     {
#         $OwnerId = ((Get-EC2Instance -Region $Region) | Select-Object -ExpandProperty OwnerId -Unique)
#     }

#     return $OwnerId
# }
function Start-Main
{
    # Fetching information on the AWS account
    foreach($Region in $AWSRegions)
    {
        Write-Output "Fetching info from Region: $Region"
        #EC2        
        $AllVolumeObjects += Get-OziAuditEBSVolumes($Region)
        #EC2RI
        $AllReservedInstanceObjects += Get-OziAuditEC2ReservedInstances($Region)
        #EBS  
        $AllInstanceObjects += Get-OziAuditEC2Instances($Region)
        #EIP
        $AllAddressObjects += Get-OziAuditEIPAddresses($Region)     
        #Snapshots
        $AllSnapshotObjects += Get-OziAuditEC2Snapshots $Region $OwnerId
    } 
    Write-Output "`n"
    Show-Summary $AllVolumeObjects $AllReservedInstanceObjects $AllInstanceObjects $AllAddressObjects $AllSnapshotObjects
    Show-GlobalTable $AllVolumeObjects $AllReservedInstanceObjects $AllInstanceObjects $AllAddressObjects $AllSnapshotObjects 
    # foreach($Instance in $AllInstanceObjects)
    # {
    #     Write-Output $Instance.InstanceId
    # }
    # foreach($Volume in $AllVolumeObjects)
    # {
    #     Write-Output $Volume.VolumeId
    # }
    # foreach($ReservedInstance in $AllReservedInstanceObjects)
    # {
    #     Write-Output $ReservedInstance.State
    # }
    # foreach($EIPAddress in $AllAddressObjects)
    # {
    #     Write-Output $EIPAddress.AllocationId
    # }
    # foreach($Snapshot in $AllSnapshotObjects)
    # {
    #     Write-Output $Snapshot.SnapshotId
    # }             
}
Start-Main
