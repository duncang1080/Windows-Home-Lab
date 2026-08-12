After installing windows successfully, I undergo a comprehensive health check of the Asus laptop to see if there are any issues with the software or hardware.
First step is open CMD and use "PowerShell" to get every relevant piece of information.
Then type "systeminfo" to pull the information about the laptop 
mainly looking for: 
BIOS 
CPU, 
RAM, 
Model of Storage and amount it has,
Network adapter, 
and device manager status. 
<img width="1258" height="952" alt="image" src="https://github.com/user-attachments/assets/6facaf2f-f8af-438c-9745-2e25ad37bf9a" />
Using the command "Get-ComputerInfo" on CMD with powershell, I was able to find info on the windows OS. 
<img width="1629" height="971" alt="image" src="https://github.com/user-attachments/assets/95e1044c-ee3d-486a-ac48-5f0177aab272" />
Next I checked the status of device manager and found some errors.
<img width="1903" height="1000" alt="image" src="https://github.com/user-attachments/assets/d2062592-0a2a-42a0-8e72-e7d8620280b1" />
Many of the errors are consistently related to drivers on the motherboard.
See "PCE Device Driver Installation Read.me" for how I reslove this issue
Next step is in CMD type "sfc /scannow" I am checking all protected operating files, and the system will repair or replace any missing, damaged, or changed files with a cached copy.
<img width="975" height="501" alt="image" src="https://github.com/user-attachments/assets/9849b861-b96d-4a21-a385-2d9ea1252d9e" />
Scan took 5 minutes and came up with nothing. 
Next I run "DISM /Online /Cleanup-Image /RestoreHealth" in CMD to scan for and repair corrupt system files
<img width="958" height="501" alt="image" src="https://github.com/user-attachments/assets/9a1a1489-ae55-4e24-b280-d725d1d52099" />
No issues found
Next I checked the C drive while it was recently wiped when installing Windows, and appears to be functioning it is good to double check for issues
Especially since there was an issue with it when initially booting Windows
<img width="664" height="751" alt="image" src="https://github.com/user-attachments/assets/1c1c7c81-5617-4c4d-bdb4-3d538ad9d9f5" />
No Issues
Next I check Event Viewer to see if there are any boot problems

In Event Viewer I check "System" and sort the level of the errors so that I can see them sorted.
<img width="1356" height="544" alt="image" src="https://github.com/user-attachments/assets/5773d935-aaec-4e01-a0fa-9ce7ada2f3c7" />
This computer's battery is not functioning and if it is unplugged it power will cut immediately.  
These are the Events and the IDs I found:
<img width="585" height="301" alt="image" src="https://github.com/user-attachments/assets/efe0c566-59ff-46e4-88b6-0edcf1d5ff02" />
