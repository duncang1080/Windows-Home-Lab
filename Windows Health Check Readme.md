# General Comprehesive Check
After installing windows successfully, I undergo a comprehensive health check of the Asus laptop to see if there are any issues with the software or hardware.
First step is open CMD and use `PowerShell` to get every relevant piece of information.
Then type `systeminfo` to pull the information about the laptop 
mainly looking for: 
BIOS 
CPU, 
RAM, 
Model of Storage and amount it has,
Network adapter, 
and device manager status. 
<img width="1258" height="952" alt="image" src="https://github.com/user-attachments/assets/6facaf2f-f8af-438c-9745-2e25ad37bf9a" />
Using the command `Get-ComputerInfo` on CMD with powershell, I was able to find info on the windows OS. 
<img width="1629" height="971" alt="image" src="https://github.com/user-attachments/assets/95e1044c-ee3d-486a-ac48-5f0177aab272" />
## Device Manager
Next I checked the status of device manager and found some errors.
<img width="1903" height="1000" alt="image" src="https://github.com/user-attachments/assets/d2062592-0a2a-42a0-8e72-e7d8620280b1" />
Many of the errors are consistently related to drivers on the motherboard.
See ["PCE Device Driver Installation Read.me"](https://github.com/duncang1080/Windows-Home-Lab/blob/main/PCE%20Device%20Driver%20Installation%20Readme.md) for how I reslove this issue
Next step is in CMD type `sfc /scannow` I am checking all protected operating files, and the system will repair or replace any missing, damaged, or changed files with a cached copy.
<img width="975" height="501" alt="image" src="https://github.com/user-attachments/assets/9849b861-b96d-4a21-a385-2d9ea1252d9e" />
Scan took 5 minutes and came up with nothing. 
Next I run `DISM /Online /Cleanup-Image /RestoreHealth` in CMD to scan for and repair corrupt system files.
<img width="958" height="501" alt="image" src="https://github.com/user-attachments/assets/9a1a1489-ae55-4e24-b280-d725d1d52099" />
<br>
No issues found.
## Storage
Next I checked the C drive while it was recently wiped when installing Windows, and appears to be functioning it is good to double check for issues.
Especially since there was an issue with it when initially booting Windows.
<img width="664" height="751" alt="image" src="https://github.com/user-attachments/assets/1c1c7c81-5617-4c4d-bdb4-3d538ad9d9f5" />
<br>
No Issues

## Event Viewer
Next I check Event Viewer to see if there are any boot problems.
In Event Viewer I check "System" and sort the level of the errors so that I can see them sorted.
<img width="1356" height="544" alt="image" src="https://github.com/user-attachments/assets/5773d935-aaec-4e01-a0fa-9ce7ada2f3c7" />
<br>  
These are the Events and the IDs I found:
<br>
<img width="585" height="301" alt="image" src="https://github.com/user-attachments/assets/efe0c566-59ff-46e4-88b6-0edcf1d5ff02" />
<br>
I will show how I resolve these in ["Event Viewer Investigation Readme.md"](https://github.com/duncang1080/Windows-Home-Lab/blob/main/Event%20Viewer%20Investigation%20Readme.md)

## Startup Check

### General Info
In Powershell I run the commands: `Get-ComputerInfo | Select-Object WindowsProductName, WindowsVersion, OsBuildNumber, CsName` `(Get-CimInstance Win32_OperatingSystem).LastBootUpTime` `(Get-Date) - (Get-CimInstance Win32_OperatingSystem).LastBootUpTime`
<img width="1125" height="736" alt="image" src="https://github.com/user-attachments/assets/207b7770-a115-46cc-b37f-4f268b296c7e" />
<br>
This establishes the basic info of the system

### CPU and RAM
Next is to check the CPU and memory
I run commands `Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors` and `Get-CimInstance Win32_OperatingSystem | Select-Object TotalVisibleMemorySize, FreePhysicalMemory`
This will show what CPU and how many cores/threads the PC has. The second command will tell how much available RAM there is and how much is currently being used. 
<img width="1139" height="263" alt="image" src="https://github.com/user-attachments/assets/28625afc-5996-4ee4-8339-ce5b14ccadaa" />
<br>
Lastly for CPU, I run command: `Get-CimInstance Win32_Processor | Select-Object Name, LoadPercentage` to assess if there is anything loading the CPU that I am unaware of. 
<img width="912" height="136" alt="image" src="https://github.com/user-attachments/assets/e11db8a7-ff6e-4c85-aae0-b27121afa99a" />
<br>
### Storage
Next is to check the capacity and health of the storage. 
I run command: `Get-PSDrive -PSProvider FileSystem` 
<img width="852" height="165" alt="image" src="https://github.com/user-attachments/assets/84a7cde1-f822-48dd-9938-3e4c2079c901" />
<br>
Now to check the health of the drives I run command: `Get-PhysicalDisk | Select-Object FriendlyName, MediaType, HealthStatus, OperationalStatus, Size`
<img width="1015" height="244" alt="image" src="https://github.com/user-attachments/assets/2ec661ca-7352-4519-bb53-cd6d3de5585d" />
<br>
### Windows Services 
Specifically Windows Update, Background Intelligent Transfer Service (BITS), Microsoft Defender Antivirus
Still in powershell, I run the command: `Get-Service wuauserv, BITS, WinDefend | Select-Object Name, DisplayName, Status, StartType` to see the status of these programs.
<img width="950" height="138" alt="image" src="https://github.com/user-attachments/assets/cbcc717b-d457-4b0d-b11f-273709faa381" />
<br>
BITS and Windows Update, are stopped and on manual activation. That does not mean that they are broken as they are on demand type services. So I will check to see if they are disabled in powershell. 
To check if they are disabled I run command: `sc.exe qc BITS` and `sc.exe qc wuauserv`
<br>
<img width="780" height="512" alt="image" src="https://github.com/user-attachments/assets/6a52ea8f-a4f7-4af2-8a4c-d38481db2c66" />
<br>
This confirms that they are not disabled, and are on "Demand Start" or when they are needed they will run. 
