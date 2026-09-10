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


# System File Integrity
Write-Host "SYSTEM FILE INTEGRITY"
Write-Host "----------------------------------------"

$sfcResult = sfc /verifyonly 2>&1

$sfcResult | ForEach-Object {
    Write-Host $_
}

Write-Host ""


# Network Connectivity
$pingResult = Test-Connection 8.8.8.8 -Count 4

$successfulPings = $pingResult.Count
$averagePing = [math]::Round(
    ($pingResult | Measure-Object ResponseTime -Average).Average,
    1
)

$packetLoss = [math]::Round(
    ((4 - $successfulPings) / 4) * 100,
    0
)

Write-Host "NETWORK CONNECTIVITY"
Write-Host "----------------------------------------"
Write-Host "Target:       8.8.8.8"
Write-Host "Successful:   $successfulPings / 4"
Write-Host "Packet Loss:  $packetLoss%"
Write-Host "Average Ping: $averagePing ms"
Write-Host ""


# Security
$secureBoot = Confirm-SecureBootUEFI

Write-Host "SECURITY"
Write-Host "----------------------------------------"
Write-Host "Secure Boot:  $secureBoot"
Write-Host ""

# Storage Information
$drives = Get-PSDrive -PSProvider FileSystem

$disks = Get-PhysicalDisk |
    Select-Object FriendlyName, MediaType, HealthStatus, OperationalStatus, Size

Write-Host "STORAGE"
Write-Host "----------------------------------------"

foreach ($drive in $drives) {
    $totalGB = [math]::Round(($drive.Used + $drive.Free) / 1GB, 2)
    $freeGB = [math]::Round($drive.Free / 1GB, 2)
    $freePercent = [math]::Round(($drive.Free / ($drive.Used + $drive.Free)) * 100, 1)

    Write-Host "$($drive.Name):"
    Write-Host "  Total:      $totalGB GB"
    Write-Host "  Free:       $freeGB GB"
    Write-Host "  Free Space: $freePercent%"
}

Write-Host ""
Write-Host "PHYSICAL DISKS"
Write-Host "----------------------------------------"

foreach ($disk in $disks) {
    $sizeGB = [math]::Round($disk.Size / 1GB, 2)

    Write-Host "Disk:        $($disk.FriendlyName)"
    Write-Host "  Type:        $($disk.MediaType)"
    Write-Host "  Size:        $sizeGB GB"
    Write-Host "  Health:      $($disk.HealthStatus)"
    Write-Host "  Operational: $($disk.OperationalStatus)"
}

Write-Host ""


# Windows Services
$services = Get-Service wuauserv, BITS, WinDefend |
    Select-Object Name, DisplayName, Status, StartType

Write-Host "IMPORTANT WINDOWS SERVICES"
Write-Host "----------------------------------------"

foreach ($service in $services) {
    Write-Host "$($service.DisplayName)"
    Write-Host "  Name:       $($service.Name)"
    Write-Host "  Status:     $($service.Status)"
    Write-Host "  Start Type: $($service.StartType)"
}

Write-Host ""


# Windows Update
$updateEvents = Get-WinEvent -FilterHashtable @{
    LogName = "System"
    ProviderName = "Microsoft-Windows-WindowsUpdateClient"
    StartTime = (Get-Date).AddDays(-7)
} -ErrorAction SilentlyContinue

Write-Host "WINDOWS UPDATE"
Write-Host "--------------------------------------------------"


