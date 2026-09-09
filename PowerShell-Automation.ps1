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

