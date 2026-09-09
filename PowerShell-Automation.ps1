# Windows Startup Health Check # Phase 2 - Automation 
Write-Host "========================================" 
Write-Host " WINDOWS STARTUP HEALTH CHECK" 
Write-Host "========================================" 
Write-Host "" 

# System Information 
$system = Get-ComputerInfo | 
Select-Object WindowsProductName, WindowsVersion, OsBuildNumber, CsName 

$lastBoot = (Get-CimInstance Win32_OperatingSystem).LastBootUpTime 
$uptime = (Get-Date) - $lastBoot 
Write-Host "SYSTEM" 
Write-Host "----------------------------------------" 
Write-Host "OS: $($system.WindowsProductName)" 
Write-Host "Build: $($system.OsBuildNumber)" 
Write-Host "Computer: $($system.CsName)" 
Write-Host "Last Boot: $lastBoot" 
Write-Host "Uptime: $($uptime.Days)d $($uptime.Hours)h $($uptime.Minutes)m" 
Write-Host "" 


# CPU Information
$cpu = Get-CimInstance Win32_Processor | 
    Select-Object Name, NumberOfCores, NumberOfLogicalProcessors, LoadPercentage

# Memory Information
$memory = Get-CimInstance Win32_OperatingSystem | 
    Select-Object TotalVisibleMemorySize, FreePhysicalMemory

$totalMemoryGB = [math]::Round($memory.TotalVisibleMemorySize / 1MB, 2)
$freeMemoryGB = [math]::Round($memory.FreePhysicalMemory / 1MB, 2)
$usedMemoryGB = [math]::Round($totalMemoryGB - $freeMemoryGB, 2)

$memoryUsagePercent = [math]::Round(
    ($usedMemoryGB / $totalMemoryGB) * 100, 1)

Write-Host "CPU & MEMORY"
Write-Host "----------------------------------------"
Write-Host "CPU:          $($cpu.Name)"
Write-Host "Cores:        $($cpu.NumberOfCores)"
Write-Host "Threads:      $($cpu.NumberOfLogicalProcessors)"
Write-Host "CPU Load:     $($cpu.LoadPercentage)%"
Write-Host "Total RAM:    $totalMemoryGB GB"
Write-Host "Used RAM:     $usedMemoryGB GB"
Write-Host "Free RAM:     $freeMemoryGB GB"
Write-Host "RAM Usage:    $memoryUsagePercent%"
Write-Host ""
