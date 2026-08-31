## Initial Event Log Findings
Off the bat, this laptop has a nonfunctioning battery which likely solves the Kernel-Power Error
The second one is the TPM-WMI which is related to the boot process will be investigated
Next would be the numerous BitLocker-Driver Events, which is likely the BitLocker Drive Encryption.
Then I will investigate the Service Control Manager telling me that Widows services on the boot up are having problems. The computer is slow on start up so Investigating this could help that. Lastly are WindowsUpdateClient 20, and Time-Service 34. I will see if there is any issues with the recent update I did on the computer, and the Time service is likely linked the the improper shut down due to the battery. The time on the laptop is currently wrong.  

 <img width="585" height="301" alt="image" src="https://github.com/user-attachments/assets/e9f47199-17d4-4db6-80ef-193139c9a26e" />

## TPM-WMI Event 1041 and 1801
<p align="left">TPM-WMI 1041: A critical component failed a pre-attestation health check.
I open File Explorer and type this path into the address bar: `C:\Windows\Logs\Measured Boot` Looking for the JSON File described in the message. 
<br><br>
 <img width="617" height="426" alt="image" src="https://github.com/user-attachments/assets/606172d1-2fb4-496b-a270-e3b6b5d6628f" />
<img width="1118" height="293" alt="image" src="https://github.com/user-attachments/assets/c69dab19-3e17-42c0-97bc-3eb226aaab66" />
<br> <br> 
 <br> <br> 
 Opening the JSON file, there are messages giving the status of the TPM (Trusted Platform Module) and see if it is failing or not. It tells me that the system is recognizing the TPM and communicating with it. The issue is that EK certificate is not available. 
 <img width="1422" height="292" alt="image" src="https://github.com/user-attachments/assets/b4b38bdb-1c25-42e5-994e-746444682727" />
<br> <br> <br>

<p align="left">Taking a look at 1801 now, it says that secure boot certificates are available but were not applied. 
Checking the state of the BIOS and secure boot with the run box typing `msinfo32` to check this.
<br> <br>
<img width="615" height="430" alt="image" src="https://github.com/user-attachments/assets/11be246b-8ba8-4655-82d5-70aba4c20681" />


<br> <br>
 <img width="399" height="197" alt="image" src="https://github.com/user-attachments/assets/3a559ea3-b6b3-43b7-a3ff-fbe4ffc64ceb" />
<img width="1547" height="824" alt="image" src="https://github.com/user-attachments/assets/142409a8-1e72-4756-bbbf-b1dbf3ab9d63" />
Can see that BIOS is normal and secure boot is on

Next, I check the heath of the TPM. Going to run and typing `tpm.msc` I am able to see the TPM management menu
<img width="391" height="197" alt="image" src="https://github.com/user-attachments/assets/764c8676-5a3e-4367-948c-36982e649e5f" />
<br><br>
<img width="543" height="407" alt="image" src="https://github.com/user-attachments/assets/ea2c12d8-cb61-4a6b-84e7-096cff5bed0c" />
<br><br>
TPM is healthy and I can focus on resolving the certificate issue.
Going into command prompt using powershell, I retrieve the certificate info typing `Get-TpmEndorsementKeyInfo`

<img width="948" height="454" alt="image" src="https://github.com/user-attachments/assets/b01ae597-e4b9-4322-bb25-8500261e2370" />
<br>
Turns out there is a certificate accessible but is not currently available at the time it needs to be investigated. But the TPM is perfectly fine. 
Switching to event 1801, I go powershell and type `Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot`
<img width="810" height="325" alt="image" src="https://github.com/user-attachments/assets/deb7fec7-93ce-437b-a919-a8cc484af800" />
<br>
Next in powershell, I run this command: `Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\SecureBoot\Servicing" |
Select-Object UEFICA2023Status, WindowsUEFICA2023Capable, UEFICA2023Error, UEFICA2023ErrorEvent`
<img width="885" height="191" alt="image" src="https://github.com/user-attachments/assets/857e946c-c8a9-4e4c-ba29-aca2f258835d" />
<br>
That command shows that the event error has been fixed and this was just a historical event, I concluded that the TPM is functioning properly and that the boot is running the 2023 system. 

## Service Control Manager Events 7000,7009,7011,7022
### Event 7000
Open Event Viewer go to Windows Logs > System
<img width="838" height="280" alt="image" src="https://github.com/user-attachments/assets/61dc74f4-6a67-4ebe-9905-1989b792fe2d" />
<br>
Look for "7000" under event ID 
<img width="1365" height="624" alt="image" src="https://github.com/user-attachments/assets/6c784cc0-43b9-4eff-bf9a-77a8ecf7eac7" />
<br>
Issue is related to the Background Intelligent Transfer Service (BITS)  
<br> 
In powershell, run `Get-Service BITS` 
<br>
<img width="634" height="264" alt="image" src="https://github.com/user-attachments/assets/05395889-626d-4c95-bf8f-ee655f14f401" />
<br>
Its status is stopped
Run the command `Get-Service BITS` to get windows to run it.
<br>
<img width="970" height="344" alt="image" src="https://github.com/user-attachments/assets/09b58a87-689a-4e66-a631-77b02cccc97b" />
I let it sit for about 5 minutes with no message confirming BITS had an error or is running. 
I once again run `Get-Service BITS` and it is now running
<img width="962" height="499" alt="image" src="https://github.com/user-attachments/assets/28228533-7820-439b-81d3-e9687d8aacb2" />
Run the command `Get-WinEvent -FilterHashtable @{LogName= 'System'; ID=7000} -MaxEvents 5 | Select-Object TimeCreated, ID, ProviderName, Message` 
This will show the last 5 7000 Event IDs Made
<img width="1258" height="205" alt="image" src="https://github.com/user-attachments/assets/42f8ce40-067f-4ef0-bb82-5439a2652fb9" />
<br>
Despite not running initially, there was no new event made. 
Run command `Stop-Service BITS` and then `Measure-Command { Start-Service BITS }`
<br>
<img width="889" height="275" alt="image" src="https://github.com/user-attachments/assets/070c2cbd-c05e-4d87-b7d8-3feb36a311b3" />
<br>
BITS started in 4.3 seconds which is normal.
<br>
**Conclusion:** Given that BITS will start at a normal time and is not being hung up. There are also no additional event ID 7000 codes appearing on event ID, this is a historical issues that needs no further investigation.  
### Event 7009
Go to Event Viewer > Windows Logs > System > Event ID 7009
<img width="1251" height="594" alt="image" src="https://github.com/user-attachments/assets/098d51aa-135b-46e9-8ec4-cf4861e0b45f" />
<br>
In powershell, run command `Get-Service InstallService` followed by `sc.exe qc InstallService` to first find the status of the system and then the Startup type, Dependency, and Service account. 
<img width="910" height="541" alt="image" src="https://github.com/user-attachments/assets/5fda3ff3-e9a5-4a25-89d3-9832989a744d" />
<br>
Next is to find out how recent this event has been reoccurring, I run command `Get-WinEvent -FilterHastable @{LogName= 'System'; ID=7009} -Max Events 5 | Select-Object Time Created, ID, ProvideName, Message` This will tell me the last 5 7009 EventIDs that happened. 
<img width="1103" height="628" alt="image" src="https://github.com/user-attachments/assets/c04df235-e4ce-43f7-ab00-37354ca64432" />
<br> 
Need to get more info on what is causing these events so I run the code: `Get-WinEvent -FilterHashtable @{LogName='System'; Id=7009} -MaxEvents 10 |
Select-Object TimeCreated, Message` This will zoom out to the last 10 events and give more details as to what is causing each delay. 
<img width="1224" height="283" alt="image" src="https://github.com/user-attachments/assets/a8bd02d6-03f2-40b3-a920-22c07e251ed8" />
<br> The events are unrelated which doesn't necessarily point to each service being broken but possibly a background issue. Next step is to find out what else is going on with the computer to trigger these events using the timestamps that the event occurs. 
Running command `Get-WinEvent -FilterHashtable @{LogName='System'; StartTime=(Get-Date '8/31/2026 9:40 AM')} | Select-Object TimeCreated, ID, ProviderName, Message` I can see what goes on that triggers these events. 
<img width="1913" height="849" alt="image" src="https://github.com/user-attachments/assets/8ed22b47-4519-4742-8065-68b84d998c75" />
<br>
This shows three distinct events with additional context of what was happening before event 7009 was triggered.
The second sequence draws my attention more because I see Event 20 in there which was part of my initial list. So there could be a possible link here. 
Taking a look at event 43, the message will say what update Windows was trying to install. 
<img width="626" height="435" alt="image" src="https://github.com/user-attachments/assets/bb707af9-b8cd-43de-905f-79affdefd317" />
