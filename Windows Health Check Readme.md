After installing windows sucessfully, I undergo a comprehensive health check of the Asus laptop to see if there are any issues with the software or hardware.
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
