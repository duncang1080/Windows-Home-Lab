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
Many of the errors are consistently related to the PCI slot on the motherboard.
Went to device manager and noticed the errors and looked to update the drivers.
<img width="527" height="752" alt="image" src="https://github.com/user-attachments/assets/9c018727-7b64-4c86-b6fb-8c0407d6532a" />
<img width="613" height="446" alt="image" src="https://github.com/user-attachments/assets/cb419d8e-bfa6-4235-b061-c9282e48f5c1" />
Clicked "Search automatically for drivers"
<img width="611" height="243" alt="image" src="https://github.com/user-attachments/assets/26f6742c-ae79-47f9-8118-31824ba320f2" />
Which was unsuccessful. 
<img width="408" height="459" alt="image" src="https://github.com/user-attachments/assets/9ba0b4e2-a3a0-49e2-91cf-38da8c62aadd" />
Going into the properties of the base system device to find hardware ids so I can update them with the proper one.
On ASUS's Support page, you can find different drivers to download.
<img width="1320" height="194" alt="image" src="https://github.com/user-attachments/assets/fba53438-8f91-4729-96ff-d0ae35b641eb" />
Downloaded that driver and installed
<img width="506" height="397" alt="image" src="https://github.com/user-attachments/assets/8d8f87e7-907a-4957-9fce-2ea72e8b6266" />
<img width="498" height="371" alt="image" src="https://github.com/user-attachments/assets/4add4ea0-5e6a-43e7-8105-f72b1d0d9420" />
<img width="771" height="564" alt="image" src="https://github.com/user-attachments/assets/979bfe94-9ac5-4b51-b961-9a62659f17f9" />
Base system device no longer listed after installation. 
