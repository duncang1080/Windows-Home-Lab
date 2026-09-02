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
<br>
Taking a look at Event 7040 to see what the BITS was doing. 
BITS went from a automatic start to a demand start. Which seems like it triggered when the automatic update did not go through. 
Next step is to check what did get successfully installed by checking event 19. 
<img width="620" height="433" alt="image" src="https://github.com/user-attachments/assets/6cd07002-3e9b-4572-be5b-129c05a5e8be" />
<br>
Which is a calculator update not the web experience. 
This makes event 20 more interesting now, since it is a failed update event. 
### Event 20
<br>
<img width="622" height="431" alt="image" src="https://github.com/user-attachments/assets/119ee374-21a3-44f5-a1d0-efe9b072fbb4" />
<br>
There is an error code in this message `0x80073D02`. Windows could not update because the resources required for it were already in use. 
Next step is in powershell, to run command: `Get-WinEvent -FilterHashtable @{LogName='System'; Id=20} -MaxEvents 10 |
Select-Object TimeCreated, Message` to find out how many times this has failed. 
<img width="1097" height="414" alt="image" src="https://github.com/user-attachments/assets/0bec61df-0657-4978-8439-76a82eb06ffa" />
<br> 
So it's happened 4 times over the past few days, Next step is to try and find out what is holding it up. 
Going back to Event Viewer and looking at the details of Event 20, it doesn't give any additional useful info. 
<img width="622" height="432" alt="image" src="https://github.com/user-attachments/assets/74feead9-5575-4b84-ab57-5f73e2aa663f" />
<br>
Next step is in Event Viewer, go to: Applications and Services Logs > Microsoft > Windows > AppXDeploymentServer > Operational
<img width="1917" height="963" alt="image" src="https://github.com/user-attachments/assets/0aef060f-e044-4a93-af32-464c73dc21d9" />
<br> 
What I'm looking for here is events that triggered around the same time as the log I ran in powershell so around 9:30 AM
<img width="1584" height="1026" alt="image" src="https://github.com/user-attachments/assets/1682caef-796d-49ba-9ad4-87e4b5246eb7" />
<br>
Nothing Pops up in the 9:30 AM timeframe
Looking back at the log, I filter the timeframe for the events that happened between 9:30 and 9:45 AM on 8/31/26.  
<br>
<img width="537" height="548" alt="image" src="https://github.com/user-attachments/assets/b3b0eca8-45a8-4690-b25d-4a910abbb879" />
<br>
This will give me the timeline of the Events again. 
<img width="1220" height="914" alt="image" src="https://github.com/user-attachments/assets/c6adfc23-9815-4e4e-8d2c-95a2d6f0adf4" />
<br>
Going to now look at the Windows Store and see what events show up there. In event viewer go: Applications and Services Logs > Microsoft > Windows > Store > Operational
<img width="1422" height="908" alt="image" src="https://github.com/user-attachments/assets/72291e52-88c7-4f6e-a0ce-eb3256001cb4" />
<br>
Looking at the events in this timeframe I can see what was trying to happen. There are only two different types of events, 2005 and 2006 I'm currently only interested in events that happened at 9:36:36 AM as that is when I got Event 20. 
All of the three event 2006s had different messages. In conclusion what happened in this timeframe was 3 working updates with 2 idling. 
<img width="1197" height="900" alt="image" src="https://github.com/user-attachments/assets/991c69b3-c864-4efe-91c1-3aa950210863" />
I know that one had failed after two attempts with the error code: `0x80073D02` 

### Event 7011
In Event Viewer, I look for Event 7011 in Windows Logs > System. 
<img width="622" height="430" alt="image" src="https://github.com/user-attachments/assets/ae04aa8f-0129-491a-a4a0-7be3389494d5" />
<br>
<img width="1220" height="180" alt="image" src="https://github.com/user-attachments/assets/2dbbf138-b821-4a1d-a7e0-e2e1546c1c07" />
<br>
Looking at the Events, This one was only recurring earlier in the month, before I updated drivers.  
I run the command: `Get-CimInstance Win32_Service | Where-Object {\(_.Name -like "*PIE*" -or \)_.DisplayName -like "PIE"} | Select-Object Name, DisplayName, State, StartMode, PathName | Format-List` 
<img width="1663" height="223" alt="image" src="https://github.com/user-attachments/assets/8f84577d-99a5-4b2a-9d7c-3e7ae5323b96" />
<br>
The service is running and given that it has not reoccurred since, I'd call this a historical event. 

### Event 7022
<img width="628" height="433" alt="image" src="https://github.com/user-attachments/assets/e4971fe2-fa94-4191-977b-028a836c7e1d" />
<br>
There's been some more reoccurring instances with this one as recently as today. 
<img width="1160" height="100" alt="image" src="https://github.com/user-attachments/assets/ee8828c6-580c-44c8-ab10-df018e3c0685" />
<br>
To check the status of DoSvc, run the command in powershell: `Get-Service DoSvc | Select-Object Name,Status,StartType`
<img width="694" height="133" alt="image" src="https://github.com/user-attachments/assets/d5307bdf-9968-43e0-a86b-49a06be9cd45" />
<br>
Despite having a hang up, it is currently running 
Next step is to see what other events happened around 9/2/26 at 8:32:36 AM
<img width="1260" height="280" alt="image" src="https://github.com/user-attachments/assets/b68e9e26-d5a1-4a5a-8bf6-4f7c4f86a353" />
<br>
Checking the 10016 event right below the 7022 event to see if they are related. 
<img width="1434" height="433" alt="image" src="https://github.com/user-attachments/assets/d341d166-008a-4462-9298-09f34b23af66" />
<br> 
They are not. So going forward given that DoSvc was hung up but is now running, it does not warrant further investigation. 

## Time Service Event 34
<img width="627" height="433" alt="image" src="https://github.com/user-attachments/assets/7a15b627-ac77-4695-93b8-f16fcbcd037c" />
<br>
The clock on the Laptop is giving an incorrect time, but the date is correct. 
I go to clock settings and see that when I setup Windows, either it was me or windows that set the laptop to Pacific Standard Time.
<img width="876" height="718" alt="image" src="https://github.com/user-attachments/assets/f19a97ff-36a6-4ea2-a257-c08d54367418" />
<br>
Change the time to Eastern Standard Time as I am on the east coast, and sync the laptop when done. This event has not popped up in 22 days. It would be worth periodically monitering if it occurs again. 
## Conclusion
Before I continue further with diagnosing the unresolved events, I will clear the event viewer and over the next couple days check to see what comes back.  
