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
<img width="634" height="264" alt="image" src="https://github.com/user-attachments/assets/05395889-626d-4c95-bf8f-ee655f14f401" />
<br>


