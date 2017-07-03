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
            $VolumeObject | Add-Member -type NoteProperty -name AttachmentState -value $v.Attachments.State      
            $VolumeObject | Add-Member -type NoteProperty -name AttachmentInstance -value $v.Attachments.InstanceId
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
function Get-OziAuditRDSDBInstances
{
    param
    (
        $Region
    )

    #Initializing objects and variables
    $AllRDSDBInstanceObjects = @()
    $RDSDBInstanceObject = @()

    # Fetching all rds db instances
    $RDSDBInstances = (Get-RDSDBInstance -Region $Region -ProfileName $AWSCredentialsProfile)

    # If there's at least one rds db instance in the current region
    if($RDSDBInstances.Count -ge 1)
    {
        foreach($rds in $RDSDBInstances)
        {    
            # Building the RDSDBInstanceObject with information coming from the AWS EC2 API
            # http://docs.aws.amazon.com/powershell/latest/reference/items/Get-RDSDBInstance.html

            $RDSDBInstanceObject = New-Object System.Object
            $RDSDBInstanceObject | Add-Member -type NoteProperty -name Region -value $Region
            $RDSDBInstanceObject | Add-Member -type NoteProperty -name AllocatedStorage -value $rds.AllocatedStorage
            $RDSDBInstanceObject | Add-Member -type NoteProperty -name AvailabilityZone -value $rds.AvailabilityZone
            $RDSDBInstanceObject | Add-Member -type NoteProperty -name DBInstanceClass -value $rds.DBInstanceClass
            $RDSDBInstanceObject | Add-Member -type NoteProperty -name DBInstanceIdentifier -value $rds.DBInstanceIdentifier
            $RDSDBInstanceObject | Add-Member -type NoteProperty -name DbiResourceId -value $rds.DbiResourceId
            $RDSDBInstanceObject | Add-Member -type NoteProperty -name DBName -value $rds.DBName
            $RDSDBInstanceObject | Add-Member -type NoteProperty -name DBInstanceStatus -value $rds.DBInstanceStatus
            $RDSDBInstanceObject | Add-Member -type NoteProperty -name Engine -value $rds.Engine
            $RDSDBInstanceObject | Add-Member -type NoteProperty -name EngineVersion -value $rds.EngineVersion
            $RDSDBInstanceObject | Add-Member -type NoteProperty -name InstanceCreateTime -value $rds.InstanceCreateTime
            $RDSDBInstanceObject | Add-Member -type NoteProperty -name Iops -value $rds.Iops
            $RDSDBInstanceObject | Add-Member -type NoteProperty -name MultiAZ -value $rds.MultiAZ
            $RDSDBInstanceObject | Add-Member -type NoteProperty -name StorageType -value $rds.StorageType
            $RDSDBInstanceObject | Add-Member -type NoteProperty -name Endpoint -value $(($rds).Endpoint | Select-Object -ExpandProperty Address)
            $StateTransitionTime = (Get-RDSEvent -Region $Region -duration 20160 | Where-Object {($_.SourceIdentifier -eq $($rds.DBInstanceIdentifier)) -and ($_.SourceType -eq 'db-instance') -and ( $_.Message -eq 'DB instance stopped')} | Select-Object -Last 1 -ExpandProperty Date)
            $RDSDBInstanceObject | Add-Member -type NoteProperty -name LastShutdownTime -value $StateTransitionTime
            $AllRDSDBInstanceObjects += $RDSDBInstanceObject
        }            
    }
    return $AllRDSDBInstanceObjects
}
function Get-OziAuditRDSDBReservedInstances
{
    param
    (
        $Region
    )

    #Initializing objects and variables
    $AllRDSDBReservedInstanceObjects = @()
    $RDSDBReservedInstanceObject = @()

    # Fetching all rds db instances
    $RDSDBReservedInstances = (Get-RDSReservedDBInstance -Region $Region -ProfileName $AWSCredentialsProfile)

    # If there's at least one rds db instance in the current region
    if($RDSDBReservedInstances.Count -ge 1)
    {
        foreach($rdsri in $RDSDBInstances)
        {    
            # Building the RDSDBInstanceObject with information coming from the AWS EC2 API
            # http://docs.aws.amazon.com/powershell/latest/reference/items/Get-RDSReservedDBInstance.html
            $RDSDBReservedInstanceObject = New-Object System.Object
            $RDSDBReservedInstanceObject | Add-Member -type NoteProperty -name Region -value $Region   
            $RDSDBReservedInstanceObject | Add-Member -type NoteProperty -name ReservedDBInstanceId -value $rdsri.ReservedDBInstanceId
            $RDSDBReservedInstanceObject | Add-Member -type NoteProperty -name Duration -value $rdsri.Duration
            $RDSDBReservedInstanceObject | Add-Member -type NoteProperty -name DBInstanceClass -value $rdsri.DBInstanceClass
            $RDSDBReservedInstanceObject | Add-Member -type NoteProperty -name MultiAZ -value $rdsri.MultiAZ            
            $RDSDBReservedInstanceObject | Add-Member -type NoteProperty -name State -value $rdsri.State 
            $RDSDBReservedInstanceObject | Add-Member -type NoteProperty -name StartTime -value $rdsri.StartTime
            $AllRDSDBReservedInstanceObjects += $RDSDBReservedInstanceObject
        }            
    }
    return $AllRDSDBReservedInstanceObjects
}
function Get-OziAuditRDSDBSnapshots
{
    param
    (
        $Region
    )

    #Initializing objects and variables
    $AllRDSDBSnapshotObjects = @()
    $RDSDBSnapshotObject = @()

    # Fetching all instances
    $RDSDBSnapshots = (Get-RDSDBSnapshot -Region $Region -ProfileName $AWSCredentialsProfile)

    # If there's at least one instance in the current region
    if($RDSDBSnapshots.Count -ge 1)
    {
        foreach($s in $RDSDBSnapshots)
        {    
            # Building the RDSDBSnapshotObject with information coming from the AWS RDS API
            # http://docs.aws.amazon.com/powershell/latest/reference/items/Get-RDSDBSnapshot.html

            $RDSDBSnapshotObject = New-Object System.Object
            $RDSDBSnapshotObject | Add-Member -type NoteProperty -name Region -value $Region            
            $RDSDBSnapshotObject | Add-Member -type NoteProperty -name AllocatedStorage -value $s.AllocatedStorage
            $RDSDBSnapshotObject | Add-Member -type NoteProperty -name AvailabilityZone -value $s.AvailabilityZone            
            $RDSDBSnapshotObject | Add-Member -type NoteProperty -name DBInstanceIdentifier -value $s.DBInstanceIdentifier
            $RDSDBSnapshotObject | Add-Member -type NoteProperty -name DBSnapshotIdentifier -value $s.DBSnapshotIdentifier
            # $RDSDBSnapshotObject | Add-Member -type NoteProperty -name DBName -value $rds.DBName
            # $RDSDBSnapshotObject | Add-Member -type NoteProperty -name DBInstanceStatus -value $rds.DBInstanceStatus
            $RDSDBSnapshotObject | Add-Member -type NoteProperty -name Engine -value $s.Engine
            $RDSDBSnapshotObject | Add-Member -type NoteProperty -name EngineVersion -value $s.EngineVersion
            $RDSDBSnapshotObject | Add-Member -type NoteProperty -name InstanceCreateTime -value $s.InstanceCreateTime
            $RDSDBSnapshotObject | Add-Member -type NoteProperty -name SnapshotCreateTime -value $s.SnapshotCreateTime
            $RDSDBSnapshotObject | Add-Member -type NoteProperty -name SnapshotType -value $s.SnapshotType
            $RDSDBSnapshotObject | Add-Member -type NoteProperty -name Status -value $s.Status
            $RDSDBSnapshotObject | Add-Member -type NoteProperty -name StorageType -value $s.StorageType
            $RDSDBSnapshotObject | Add-Member -type NoteProperty -name Iops -value $s.Iops
            $AllRDSDBSnapshotObjects += $RDSDBSnapshotObject
        }            
    }
    return $AllRDSDBSnapshotObjects
}
function Show-Summary
{
    param
    (
        $AllVolumeObjects,
        $AllReservedInstanceObjects,
        $AllInstanceObjects,
        $AllAddressObjects,
        $AllSnapshotObjects,
        $AllRDSDBInstanceObjects,
        $AllRDSDBSnapshotObjects,
        $AllRDSDBReservedInstanceObjects        
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

    #EC2 Snapshots
    if($($AllSnapshotObjects).Count -ne 0)
    {
        Write-Output "`n>>>>>> EC2 Snapshots older than a week"         
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
        Write-Output "`n>>>>>> No existing EC2 snapshots"
    }    

    # RDS
    Write-Output "`n>>>>>> RDS DB Instances Globals"    
    Write-Output ">> Total number of RDS DB instances: $($AllRDSDBInstanceObjects).Count)"
    Write-Output ">> Total number of RDS DB stopped instances: $(($AllRDSDBInstanceObjects | Where-Object -Property 'DBInstanceStatus' -eq 'stopped').Count)"
    Write-Output ">> Percentage of started instances: $((($AllRDSDBInstanceObjects | Where-Object -Property 'DBInstanceStatus' -eq 'running').Count/($AllRDSDBInstanceObjects.Count)).ToString('P'))"
    Write-Output ">> Percentage of stopped instances: $((($AllRDSDBInstanceObjects | Where-Object -Property 'DBInstanceStatus' -eq 'stopped').Count/($AllRDSDBInstanceObjects.Count)).ToString('P'))"
    Write-Output ">> Total number of active RDS DB reserved instances: $(($AllRDSDBReservedInstanceObjects | Where-Object -Property State -eq 'active').Count)"
    Write-Output ">>>>"  

    Write-Output "`n>>>>>> RDS DB Stopped Instances list"    

    #RDS Instances
    foreach($i in ($AllRDSDBInstanceObjects | Where-Object -Property 'DBInstanceStatus' -eq 'stopped'))
    {
        $Date = ""
        $StoppedSinceDateObject = @()
        #$StoppedSinceHours = ""
        $StoppedSinceDays = ""

        Write-Output ">> Region: $($i.Region)"
        Write-Output ">> RDS DB InstanceId: $($i.DbiResourceId)"        
        Write-Output ">> Name: $($i.DBName)"
        Write-Output ">> Type: $($i.DBInstanceClass)"
        Write-Output ">> Shutdown date: $($i.LastShutdownTime)"
        $StoppedSinceDays =  $([math]::Round($((Get-Date).Subtract($i.LastShutdownTime)).TotalDays,2))
        Write-Output ">> Days since shutdown: $StoppedSinceDays day(s) since shutdown (rounded)"
        Write-Output ">>>>"            
    }
    #RDS Snapshots
    if($($AllRDSDBSnapshotObjects).Count -ge 1)
    {
        Write-Output "`n>>>>>> RDS Snapshots older than a week"         
        foreach($s in $($AllRDSDBSnapshotObjects))
        {
            if(($s.SnapshotCreateTime) -lt ($([datetime]::Now).AddDays(-7)))
            { 
                Write-Output ">> Region: $($s.Region)"         
                Write-Output ">> DBSnapshotIdentifier: $($s.DBSnapshotIdentifier)"
                Write-Output ">> SnapshotCreateTime: $($s.SnapshotCreateTime)"
                Write-Output ">> AllocatedStorage: $($s.AllocatedStorage)GB"
                Write-Output ">>>>" 
            }            
        }
    }
    else 
    {
        Write-Output "`n>>>>>> No existing RDS snapshots"
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
function Get-OwnerId
{
    foreach($Region in $AWSRegions)
    {
        $OwnerIdExists = ((Get-EC2Instance -Region $Region) | Select-Object -ExpandProperty OwnerId -Unique)
        if($OwnerIdExists)
        {
            $OwnerId = $OwnerIdExists
        }        
    }
    return $OwnerId
}

$AWSCredentialsProfile = 'default'
#$AWSRegions = (Get-AWSRegion).Region
$AWSRegions = 'eu-central-1','us-east-1','ap-northeast-1'

function Start-Main
{
    $CurrentTime = $(Get-Date -Format yyyyMMdd-hhmmss)    
    Start-Transcript -Path "$($CurrentTime).txt"
    
    Write-Output "Script started at $CurrentTime"
    $OwnerId = Get-OwnerId
    Write-Output "OwnerId: $OwnerId"
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
        #RDSDB Instances
        $AllRDSDBInstanceObjects += Get-OziAuditRDSDBInstances $Region
        #RDSDB Snapshots
        $AllRDSDBSnapshotObjects += Get-OziAuditRDSDBSnapshots $Region
        #RDSDB Reserved Instances
        $AllRDSDBReservedInstanceObjects += Get-OziAuditRDSDBReservedInstances $Region
    } 
    Write-Output "`n"

    Show-Summary $AllVolumeObjects $AllReservedInstanceObjects $AllInstanceObjects $AllAddressObjects $AllSnapshotObjects $AllRDSDBInstanceObjects $AllRDSDBSnapshotObjects $AllRDSDBReservedInstanceObjects
    # Show-GlobalTable $AllVolumeObjects $AllReservedInstanceObjects $AllInstanceObjects $AllAddressObjects $AllSnapshotObjects 
    
    Write-Output "`n"
    Write-Output "Exporting data to CSV:"

    foreach($Instance in $AllInstanceObjects)
    {
        $Instance | Export-CSV -Path $CurrentTime-Instance.csv -Append -NoTypeInformation -Delimiter ";"
    }
    foreach($Volume in $AllVolumeObjects)
    {
         $Volume | Export-CSV -Path $CurrentTime-Volume.csv -Append -NoTypeInformation -Delimiter ";"
    }
    foreach($ReservedInstance in $AllReservedInstanceObjects)
    {
        $ReservedInstance | Export-CSV -Path $CurrentTime-ReservedInstance.csv -Append -NoTypeInformation -Delimiter ";"
    }
    foreach($EIPAddress in $AllAddressObjects)
    {
        $EIPAddress | Export-CSV -Path $CurrentTime-EIPAddress.csv -Append -NoTypeInformation -Delimiter ";"
    }
    foreach($Snapshot in $AllSnapshotObjects)
    {
        $Snapshot | Export-CSV -Path $CurrentTime-Snapshot.csv -Append -NoTypeInformation -Delimiter ";"
    }    
    foreach($RDSDBInstance in $AllRDSDBInstanceObjects)
    {
        $RDSDBInstance | Export-CSV -Path $CurrentTime-RDSDBInstances.csv -Append -NoTypeInformation -Delimiter ";"
    }   
    foreach($RDSDBSnapshot in $AllRDSDBSnapshotObjects)
    {
        $RDSDBSnapshot | Export-CSV -Path $CurrentTime-RDSDBSnapshots.csv -Append -NoTypeInformation -Delimiter ";"
    }   
    foreach($RDSDBReservedInstance in $AllRDSDBReservedInstanceObjects)
    {
        $RDSDBReservedInstance | Export-CSV -Path $CurrentTime-RDSDBReservedInstance.csv -Append -NoTypeInformation -Delimiter ";"
    }           
    Write-Output "Done."
    Stop-Transcript             
}
Start-Main
