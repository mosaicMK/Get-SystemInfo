Function Get-SystemInfo{
<#
    .SYNOPSIS
    Gether system inforamtion
    .DESCRIPTION
    Gather information such as the Computer Name, OS, Memory Information, Disk Information and CPU Information.
    .PARAMETER Computer
    The local or remote computer you want to run the script on
    .NOTES
    Created By: Kris Gross
    Email: contact@mosaicMK.com
    Twitter: @kmgamd
    Version: 2.0.1
    .LINK
    http://www.mosaicMK.com
#>

param([string]$ComputerName = $env:computername)

$Computer = $ComputerName
#Gets the OS info
$GetOS = Get-WmiObject -class Win32_OperatingSystem -computername $Computer
$OS = $GetOS.Caption
$OSArchitecture = $GetOS.OSArchitecture
$OSBuildNumber = $GetOS.BuildNumber
#Gets memory information
$Getmemoryslot = Get-WmiObject Win32_PhysicalMemoryArray -ComputerName $computer
$Getmemory = Get-WMIObject Win32_PhysicalMemory -ComputerName $computer
$Getmemorymeasure = Get-WMIObject Win32_PhysicalMemory -ComputerName $computer | Measure-Object -Property Capacity -Sum
$MemorySlot = $Getmemoryslot.MemoryDevices
$MaxMemory = $($Getmemoryslot.MaxCapacity/1024/1024)
$TotalMemSticks = $Getmemorymeasure.count
$TotalMemSize = $($Getmemorymeasure.sum/1024/1024/1024)
#Get the disk info
$GetDiskInfo = Get-WmiObject Win32_logicaldisk -ComputerName $computer -Filter "DeviceID='C:'"
$DiskSize = $([math]::Round($GetDiskInfo.Size/1GB))
$FreeSpace = $([math]::Round($GetDiskInfo.FreeSpace/1GB))
$UsedSapce =$([math]::Round($DiskSize-$FreeSpace))
#Gets CPU info
$GetCPU = Get-wmiobject win32_processor -ComputerName $Computer
$CPUName = $GetCPU.Name
$CPUManufacturer = $GetCPU.Manufacturer
$CPUMaxClockSpeed = $GetCPU.MaxClockSpeed
#Computer Model
$ComputerModel = (Get-WmiObject Win32_ComputerSystem -ComputerName $Computer).Model
#account status
$LoggedOnUser = (Get-WmiObject win32_computersystem -ComputerName $Computer).Username
$getLockedStart = If (Get-Process logonui -ComputerName $Computer -ErrorAction SilentlyContinue) {$Locked = "Yes"} Else {$Locked = "No"}
#Serial Number
$SerialNumber = (Get-WmiObject win32_bios -ComputerName $Computer).SerialNumber
#get IP address
$IPAddress = (Get-WmiObject win32_NetworkadapterConfiguration -ComputerName $Computer | Where-Object IPAddress -ne $null).IPAddress
#Gets BIOS info
$BIOSName = (Get-WmiObject win32_bios -ComputerName $Computer ).Name
$BIOSManufacturer = (Get-WmiObject win32_bios -ComputerName $Computer).Manufacturer
$BIOSVersion = (Get-WmiObject win32_bios -ComputerName $Computer).Version
#Gets Motherboard info
$MotherBoardName = (Get-WmiObject Win32_BaseBoard -ComputerName $Computer).Name
$MotherBoardManufacturet = (Get-WmiObject Win32_BaseBoard -ComputerName $Computer).Manufacturer
$MotherBoardModel = (Get-WmiObject Win32_BaseBoard -ComputerName $Computer).Model
$MotherBoardProduct = (Get-WmiObject Win32_BaseBoard -ComputerName $Computer).Product
$MotherBoardSerial = (Get-WmiObject Win32_BaseBoard -ComputerName $Computer).SerialNumber

$ComputerInfo = New-Object -TypeName psobject
$ComputerInfo | Add-Member -MemberType NoteProperty -Name OperatingSystem -Value $os
$ComputerInfo | Add-Member -MemberType NoteProperty -Name OSArchitecture -Value $OSArchitecture
$ComputerInfo | Add-Member -MemberType NoteProperty -Name OSBuild -Value $OSBuildNumber
$ComputerInfo | Add-Member -MemberType NoteProperty -Name ComputerName -Value $ComputerName
$ComputerInfo | Add-Member -MemberType NoteProperty -Name SerialNumber -Value $SerialNumber
$ComputerInfo | Add-Member -MemberType NoteProperty -Name IPAddress -Value $IPAddress
$ComputerInfo | Add-Member -MemberType NoteProperty -Name LoggedInUsers -Value $LoggedOnUser
$ComputerInfo | Add-Member -MemberType NoteProperty -Name ComputerIsLocked -Value $Locked
$ComputerInfo | Add-Member -MemberType NoteProperty -Name MemorySlots -Value $MemorySlot
$ComputerInfo | Add-Member -MemberType NoteProperty -Name MaxMemory -Value "$MaxMemory GB"
$ComputerInfo | Add-Member -MemberType NoteProperty -Name MemorySlotsUsed -Value $TotalMemSticks
$ComputerInfo | Add-Member -MemberType NoteProperty -Name MemoryInstalled -Value "$TotalMemSize GB"
$ComputerInfo | Add-Member -MemberType NoteProperty -Name SystemDrive -Value $ENV:SystemDrive
$ComputerInfo | Add-Member -MemberType NoteProperty -Name DiskSize -Value "$DiskSize GB"
$ComputerInfo | Add-Member -MemberType NoteProperty -Name FreeSpace -Value "$FreeSpace GB"
$ComputerInfo | Add-Member -MemberType NoteProperty -Name UsedSpace -Value "$UsedSapce GB"
$ComputerInfo | Add-Member -MemberType NoteProperty -Name CPU -Value $CPUName
$ComputerInfo | Add-Member -MemberType NoteProperty -Name CPUManufacturer -Value $CPUManufacturer
$ComputerInfo | Add-Member -MemberType NoteProperty -Name CPUMaxClockSpeed -Value $CPUMaxClockSpeed
$ComputerInfo | Add-Member -MemberType NoteProperty -Name MotherBoard -Value $MotherBoardName
$ComputerInfo | Add-Member -MemberType NoteProperty -Name MotherBoardManufacturer -Value $MotherBoardManufacturet
$ComputerInfo | Add-Member -MemberType NoteProperty -Name MotherBoardModel -Value $MotherBoardModel
$ComputerInfo | Add-Member -MemberType NoteProperty -Name MotherBoardSerialNumber -Value $MotherBoardSerial
$ComputerInfo | Add-Member -MemberType NoteProperty -Name MotherBoardProduct -Value $MotherBoardProduct
$ComputerInfo | Add-Member -MemberType NoteProperty -Name BIOSName -Value $BIOSName
$ComputerInfo | Add-Member -MemberType NoteProperty -Name BIOSManufacturer -Value $BIOSManufacturer
$ComputerInfo | Add-Member -MemberType NoteProperty -Name BIOSVersion -Value $BIOSVersion
$ComputerInfo
}
