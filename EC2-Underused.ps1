# Monitoring

function Get-OziAuditMonitoring
{
    $AWSCredentialsProfile = 'default'

    #Initializing objects and variables
    $AllInstanceObjects = @()
    $InstanceObject = @()
    $AllRDSDBInstanceObjects = @()
    $RDSDBInstanceObject = @()    

    $AWSRegions = (Get-AWSRegion).Region

    # Filling in the AllInstanceObjects object with all of the instances existing in the account
    # Going through each region
    ForEach ($Region in $AWSRegions)
    {
        
        # Fetching all instances
        $Instances = (Get-EC2Instance -Region $Region -ProfileName $AWSCredentialsProfile)
        $RDSDBInstances = (Get-RDSDBInstance -Region $Region -ProfileName $AWSCredentialsProfile)

        #If there's at least one EC2 instance in the current region
        if($Instances.Count -ge 1)
        {
            $DimensionName = "InstanceId"
            $Namespace = "AWS/EC2"            

            foreach($i in $Instances)
            {    

                $DimensionValue = $i.Instances.InstanceId
                $Now = ([DateTime]::Now.ToString("yyyy-MM-ddTHH:mm:ss")).ToString()
                $OneDayAgo = ([DateTime]::Now.AddDays(-1).ToString("yyyy-MM-ddTHH:mm:ss")).ToString()
                $OneWeekAgo = ([DateTime]::Now.AddDays(-7).ToString("yyyy-MM-ddTHH:mm:ss")).ToString()
                $OneMonthAgo = ([DateTime]::Now.AddMonths(-1).ToString("yyyy-MM-ddTHH:mm:ss")).ToString()  

                # Building the InstanceObject with information coming from the AWS EC2 API
                # http://docs.aws.amazon.com/powershell/latest/reference/items/Get-EC2Instance.html                
                $InstanceObject = New-Object System.Object
                $InstanceObject | Add-Member -type NoteProperty -name Region -value $Region                    
                $InstanceObject | Add-Member -type NoteProperty -name NameTagValue -value ($i.Instances.Tags.Value | Where-Object { $_.Instances.Tags.Key -eq "Name"})
                $InstanceObject | Add-Member -type NoteProperty -name InstanceId -value $i.Instances.InstanceId
                $InstanceObject | Add-Member -type NoteProperty -name InstanceType -value $i.Instances.InstanceType
                $InstanceObject | Add-Member -type NoteProperty -name State -value $i.Instances.State.Name      
                $InstanceObject | Add-Member -type NoteProperty -name StateTransitionReason -value $i.Instances.StateTransitionReason     
                $InstanceObject | Add-Member -type NoteProperty -name LaunchTime -value $i.Instances.LaunchTime
                $InstanceObject | Add-Member -type NoteProperty -name PrivateDnsName -value $i.Instances.PrivateDnsName
                $InstanceObject | Add-Member -type NoteProperty -name PrivateIpAddress -value $i.Instances.PrivateIpAddress
                $InstanceObject | Add-Member -type NoteProperty -name PublicDnsName -value $i.Instances.PublicDnsName
                $InstanceObject | Add-Member -type NoteProperty -name PublicIpAddress -value $i.Instances.PublicIpAddress
                $InstanceObject | Add-Member -type NoteProperty -name SpotInstanceRequestId -value $i.Instances.SpotInstanceRequestId
                $InstanceObject | Add-Member -type NoteProperty -name MonitoringLastDay -value $(Get-OziCWCPUAverageUse "$($DimensionName)" "$($DimensionValue)" "$($Namespace)" "$($Region)" "$($OneDayAgo)" "$($Now)")
                $InstanceObject | Add-Member -type NoteProperty -name MonitoringLastWeek -value $(Get-OziCWCPUAverageUse "$($DimensionName)" "$($DimensionValue)" "$($Namespace)" "$($Region)" "$($OneWeekAgo)" "$($Now)")
                $InstanceObject | Add-Member -type NoteProperty -name MonitoringLastMonth -value $(Get-OziCWCPUAverageUse "$($DimensionName)" "$($DimensionValue)" "$($Namespace)" "$($Region)" "$($OneMonthAgo)" "$($Now)")                

                # Adding each instanceobject to the grand total variable :-)
                $AllInstanceObjects += $InstanceObject
            }            
        }
        
        # If there's at least one RDS DB instance in the current region
        if($RDSDBInstances.Count -ge 1)
        {

            $DimensionName = "DBInstanceIdentifier"
            $Namespace = "AWS/RDS"

            foreach($rds in $RDSDBInstances)
            {    
            # Building the RDSDBInstanceObject with information coming from the AWS RDS API
            # http://docs.aws.amazon.com/powershell/latest/reference/items/Get-RDSDBInstance.html
                $DimensionValue = $rds.DBInstanceIdentifier
                $Now = ([DateTime]::Now.ToString("yyyy-MM-ddTHH:mm:ss")).ToString()
                $OneDayAgo = ([DateTime]::Now.AddDays(-1).ToString("yyyy-MM-ddTHH:mm:ss")).ToString()
                $OneWeekAgo = ([DateTime]::Now.AddDays(-7).ToString("yyyy-MM-ddTHH:mm:ss")).ToString()
                $OneMonthAgo = ([DateTime]::Now.AddMonths(-1).ToString("yyyy-MM-ddTHH:mm:ss")).ToString()        

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
                $RDSDBInstanceObject | Add-Member -type NoteProperty -name MonitoringLastDay -value $(Get-OziCWCPUAverageUse "$($DimensionName)" "$($DimensionValue)" "$($Namespace)" "$($Region)" "$($OneDayAgo)" "$($Now)")
                $RDSDBInstanceObject | Add-Member -type NoteProperty -name MonitoringLastWeek -value $(Get-OziCWCPUAverageUse "$($DimensionName)" "$($DimensionValue)" "$($Namespace)" "$($Region)" "$($OneWeekAgo)" "$($Now)")
                $RDSDBInstanceObject | Add-Member -type NoteProperty -name MonitoringLastMonth -value $(Get-OziCWCPUAverageUse "$($DimensionName)" "$($DimensionValue)" "$($Namespace)" "$($Region)" "$($OneMonthAgo)" "$($Now)")
                $AllRDSDBInstanceObjects += $RDSDBInstanceObject
            }            
        }
    }
    Write-Output "`n>>>>>> EC2 Instance list:"     
    #$RunningInstances = ($AllInstanceObjects | Where-Object -Property State -eq "running")

    foreach($i in $AllInstanceObjects)
    {
        if(($LastDayAvg -le 5) -or ($LastWeekAvg -le 5) -or ($LastMonthAvg -le 5))
        {
            $Highlight = "Red"
        }
        else
        {
            $Highlight = "White"
        }            
        
		Write-Output ">> Region: $($i.Region)"
		Write-Output ">> NameTagValue: $($i.NameTagValue)"
		Write-Output ">> InstanceId: $($i.InstanceId)"
		Write-Output ">> InstanceType: $($i.InstanceType)"
		Write-Output ">> State: $($i.State)"
		Write-Output ">> StateTransitionReason: $($i.StateTransitionReason)"
		Write-Output ">> LaunchTime: $($i.LaunchTime)"
		Write-Output ">> PrivateDnsName: $($i.PrivateDnsName)"
		Write-Output ">> PrivateIpAddress: $($i.PrivateIpAddress)"
		Write-Output ">> PublicDnsName: $($i.PublicDnsName)"
		Write-Output ">> PublicIpAddress: $($i.PublicIpAddress)"
		Write-Output ">> SpotInstanceRequestId: $($i.SpotInstanceRequestId)"
        Write-Output ">> Monitoring"                   
        Write-Host -ForeGroundColor $HighLight ">> Last day average : $($i.MonitoringLastDay)"   
        Write-Host -ForeGroundColor $HighLight ">> Last week average : $($i.MonitoringLastWeek)"  
        Write-Host -ForeGroundColor $HighLight ">> Last month average : $($i.MonitoringLastMonth)"  
        Write-Output ">>>>"
    }

    Write-Output "`n>>>>>> RDS DB Instance list:"     

    foreach($i in $AllRDSDBInstanceObjects)
    {
        if(($LastDayAvg -le 5) -or ($LastWeekAvg -le 5) -or ($LastMonthAvg -le 5))
        {
            $Highlight = "Red"
        }
        else
        {
            $Highlight = "White"
        }            
        Write-Output ">> Region: $($i.Region)"
        Write-Output ">> Endpoint: $($i.Endpoint)"
        Write-Output ">> AllocatedStorage: $($i.AllocatedStorage)GB"
        Write-Output ">> AvailabilityZone: $($i.AvailabilityZone)"
        Write-Output ">> DBInstanceClass: $($i.DBInstanceClass)"
        Write-Output ">> DBInstanceIdentifier: $($i.DBInstanceIdentifier)"
        Write-Output ">> DbiResourceId: $($i.DbiResourceId)"
        Write-Output ">> DBName: $($i.DBName)"
        Write-Output ">> DBInstanceStatus: $($i.DBInstanceStatus)"
        Write-Output ">> Engine: $($i.Engine) $($i.EngineVersion)"        
        Write-Output ">> InstanceCreateTime: $($i.InstanceCreateTime)"
        Write-Output ">> Iops: $($i.Iops)"
        Write-Output ">> MultiAZ: $($i.MultiAZ)"
        Write-Output ">> StorageType: $($i.StorageType)"
        Write-Output ">> LastShutdownTime: $($i.LastShutdownTime)"
        Write-Output ">> Monitoring:"
        Write-Host -ForeGroundColor $HighLight ">> Last day average : $($i.MonitoringLastDay)"   
        Write-Host -ForeGroundColor $HighLight ">> Last week average : $($i.MonitoringLastWeek)"  
        Write-Host -ForeGroundColor $HighLight ">> Last month average : $($i.MonitoringLastMonth)"  
        Write-Output ">>>>"
    }
}

function Get-OziCWCPUAverageUse()
{
    param(
        $DimensionName,
        $DimensionValue,
        $Namespace,
        $Region,
        $StartTime,
        $EndTime
    )

    Clear-Variable -Name Average -ErrorAction SilentlyContinue
    Clear-Variable -Name Usage -ErrorAction SilentlyContinue
    Clear-Variable -Name Datapoint -ErrorAction SilentlyContinue
    Clear-Variable -Name GrandTotal -ErrorAction SilentlyContinue
    Clear-Variable -Name Dimension -ErrorAction SilentlyContinue 

    $Dimension = New-Object Amazon.CloudWatch.Model.Dimension
    $Dimension.set_Name($DimensionName)
    $Dimension.set_Value($DimensionValue)    


    $Usage = (Get-CWMetricStatistic -ProfileName $AWSCredentialsProfile -MetricName CPUUtilization -StartTime $StartTime -EndTime $EndTime -Period 3600 -Namespace $Namespace -Statistics "Average" -Dimension $Dimension -Region $Region)
    if($Usage -ne $NULL)
    {
        foreach($Datapoint in $Usage.Datapoints)
        {
	        $GrandTotal += $Datapoint.Average
        }
        if($Usage.Datapoints.Count -eq 0)
        {
            $Average = "No available datapoints"            
        }
        elseif($Usage.Datapoints.Count -gt 0)
        {
            $Average = $([math]::Round($($GrandTotal/$($Usage.Datapoints.Count)),2))   
        }
    }
    else
    {
        $Average = "Could not fetch information"
    }
    return $Average
}
Get-OziAuditMonitoring
