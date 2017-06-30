# Monitoring

function Get-OziAuditMonitoring
{
    $AWSCredentialsProfile = 'default'

    #Initializing objects and variables
    $AllInstanceObjects = @()
    $InstanceObject = @()

    $AWSRegions = (Get-AWSRegion).Region
    #$AllRegions = 'eu-central-1'
    #$AllRegions = 'us-east-1'

    # Filling in the AllInstanceObjects object with all of the instances existing in the account
    # Going through each region
    ForEach ($Region in $AWSRegions)
    {
        
        #$RegionName = 'eu-central-1'
        # Fetching all instances
        $Instances = (Get-EC2Instance -Region $Region -ProfileName $AWSCredentialsProfile)

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
                $InstanceObject | Add-Member -type NoteProperty -name StateTransitionReason -value $i.Instances.StateTransitionReason     
                $InstanceObject | Add-Member -type NoteProperty -name LaunchTime -value $i.Instances.LaunchTime
                $InstanceObject | Add-Member -type NoteProperty -name PrivateDnsName -value $i.Instances.PrivateDnsName
                $InstanceObject | Add-Member -type NoteProperty -name PrivateIpAddress -value $i.Instances.PrivateIpAddress
                $InstanceObject | Add-Member -type NoteProperty -name PublicDnsName -value $i.Instances.PublicDnsName
                $InstanceObject | Add-Member -type NoteProperty -name PublicIpAddress -value $i.Instances.PublicIpAddress
                $InstanceObject | Add-Member -type NoteProperty -name SpotInstanceRequestId -value $i.Instances.SpotInstanceRequestId

                # Adding each instanceobject to the grand total variable :-)
                $AllInstanceObjects += $InstanceObject
            }            
        }
    }
    Write-Output "`n>>>>>> EC2 Running Instances list:"     
    $RunningInstances = ($AllInstanceObjects| Where-Object -Property State -eq "running")

    foreach($i in $RunningInstances)
    {
        $Dimension = New-Object Amazon.CloudWatch.Model.Dimension
        $Dimension.set_Name("InstanceId")
        $Dimension.set_Value($i.InstanceId)  

        $Now = ([DateTime]::Now.ToString("yyyy-MM-ddTHH:mm:ss")).ToString()
        $OneDayAgo = ([DateTime]::Now.AddDays(-1).ToString("yyyy-MM-ddTHH:mm:ss")).ToString()
        $OneWeekAgo = ([DateTime]::Now.AddDays(-7).ToString("yyyy-MM-ddTHH:mm:ss")).ToString()
        $OneMonthAgo = ([DateTime]::Now.AddMonths(-1).ToString("yyyy-MM-ddTHH:mm:ss")).ToString()        
        #$OneYearAgo = ([DateTime]::Now.AddYears(-1).ToString("yyyy-MM-ddTHH:mm:ss")).ToString()
        
        $LastDayAvg = (Get-OziCWCPUAverageUse "$($i.InstanceId)" "$($i.Region)" "$($OneDayAgo)" "$($Now)")        
        $LastWeekAvg = (Get-OziCWCPUAverageUse "$($i.InstanceId)" "$($i.Region)" "$($OneWeekAgo)" "$($Now)")        
        $LastMonthAvg = (Get-OziCWCPUAverageUse "$($i.InstanceId)" "$($i.Region)" "$($OneMonthAgo)" "$($Now)")
        #$LastYearAvg = (Get-OziCWCPUAverageUse "$($i.InstanceId)" "$($i.Region)" "$($OneYearAgo)" "$($Now)")

        if(($LastDayAvg -le 5) -or ($LastWeekAvg -le 5) -or ($LastMonthAvg -le 5))# -or ($LastYearAvg -le 5) )
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
        Write-Host -ForeGroundColor $HighLight ">> Last day average : $([math]::Round($LastDayAvg,2))"  
        Write-Host -ForeGroundColor $HighLight ">> Last week average : $([math]::Round($LastWeekAvg,2))"  
        Write-Host -ForeGroundColor $HighLight ">> Last month average : $([math]::Round($LastMonthAvg,2))"       
        #Write-Host -ForeGroundColor $HighLight ">> Last year average : $([math]::Round($LastYearAvg,2))"          
        Write-Output ">>>>"
    }
}

function Get-OziCWCPUAverageUse()
{
    param(
        $Instance,
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
    $Dimension.set_Name("InstanceId")
    $Dimension.set_Value($i.InstanceId)    

    $Usage = (Get-CWMetricStatistic -ProfileName $AWSCredentialsProfile -MetricName CPUUtilization -StartTime $StartTime -EndTime $EndTime -Period 3600 -Namespace AWS/EC2 -Statistics "Average" -Dimension $Dimension -Region $Region)
    if($Usage -ne $NULL)
    {
        foreach($Datapoint in $Usage.Datapoints)
        {
	        $GrandTotal += $Datapoint.Average
        }
        $Average = $GrandTotal/$Usage.Datapoints.Count
    }
    else
    {
        $Average = "Could not fetch information"
    }

    return $Average
}
Get-OziAuditMonitoring
