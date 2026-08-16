# Initial Findings
In the Device manager status check I noticed that there were several driver related errors so one by one I resolved them. 
Went to device manager and noticed the errors and looked to update the drivers.
<br>
<img width="527" height="752" alt="image" src="https://github.com/user-attachments/assets/9c018727-7b64-4c86-b6fb-8c0407d6532a" />
<p align=left>Selected "Search automatically for drivers".
  <br>
 <img width="613" height="446" alt="image" src="https://github.com/user-attachments/assets/cb419d8e-bfa6-4235-b061-c9282e48f5c1" />
<br>
  Which was unsuccessful
  <br>
  <img width="611" height="243" alt="image" src="https://github.com/user-attachments/assets/26f6742c-ae79-47f9-8118-31824ba320f2" />

 ## Finding Hardware IDs 
 ### Base System
Starting with the Base System
<br>
<img width="357" height="493" alt="image" src="https://github.com/user-attachments/assets/dab0af84-65fd-4210-a8fa-50acc6aed37d" />

<img width="408" height="459" alt="image" src="https://github.com/user-attachments/assets/9ba0b4e2-a3a0-49e2-91cf-38da8c62aadd" />
<br>
Going into the properties of the base system device to find hardware ids so I can update them with the proper one.
On [ASUS's Support page](https://www.asus.com/supportonly/gl703gs/helpdesk_download/), you can find different drivers to download.
<img width="1320" height="194" alt="image" src="https://github.com/user-attachments/assets/fba53438-8f91-4729-96ff-d0ae35b641eb" />
Downloaded that driver and installed
<br>
<img width="506" height="397" alt="image" src="https://github.com/user-attachments/assets/8d8f87e7-907a-4957-9fce-2ea72e8b6266" />
<img width="498" height="371" alt="image" src="https://github.com/user-attachments/assets/4add4ea0-5e6a-43e7-8105-f72b1d0d9420" />
<br>
Base system device no longer listed after installation. 
<br> <br>

### PCI Data Acquisition and Signal Processing Controller

<img width="893" height="661" alt="image" src="https://github.com/user-attachments/assets/6f4d6a46-a25e-4bb4-b33c-bb5589469b03" />
<br><br><br>
<p align=left>Open Properties of the device and find the hardware IDs. "Dev_1903" Tells me that this is a driver corresponding with the thermal framework of the processor. 
<br>
<img width="396" height="448" alt="image" src="https://github.com/user-attachments/assets/cef1ddc7-74bc-4390-8131-00d750ac23f7" />
<br><br>
  Download the Driver
<img width="1942" height="223" alt="image" src="https://github.com/user-attachments/assets/8243888a-e17c-4a90-92e3-e298731b9cf0" />
<br><br>
  Open the setup within the file
<img width="1123" height="624" alt="image" src="https://github.com/user-attachments/assets/d87d99d9-3ed7-4b8c-85f1-87513fa3da0d" />
<br><br>
  Once complete hit "Next" and then "Finish" 
<br>
  <img width="500" height="397" alt="image" src="https://github.com/user-attachments/assets/6b76ae42-d970-4d7b-9c54-09d717726f41" />
<br>
 "PCI Data Acquisition and Signal Processing Controller" as well as the several "Unknown device" Errors are now gone.
<br>

  ### PCI Simple Communications Controller
  <br>
  <img width="519" height="380" alt="image" src="https://github.com/user-attachments/assets/617184ba-4d18-499c-a366-f4498f64b10d" />

<img width="395" height="450" alt="image" src="https://github.com/user-attachments/assets/eda43bd9-2976-4d25-b55c-4a0eda6341e2" /> 
Same Process, find the device IDs to be able to find the correct driver to install.
"Dev_A360" Tells me that this driver is for Management and Engine Components 
<img width="1307" height="172" alt="image" src="https://github.com/user-attachments/assets/a5f66dc4-60e7-4328-888f-3f0769b36282" />
Download the driver
<img width="1129" height="623" alt="image" src="https://github.com/user-attachments/assets/d00d2c2e-f234-4513-acaa-252baec8f8c9" />
Run the setup
<img width="480" height="394" alt="image" src="https://github.com/user-attachments/assets/17150c49-d2c0-4cf0-8896-ed0ae087d1af" />
Go through the prompts and close other programs
<img width="489" height="397" alt="image" src="https://github.com/user-attachments/assets/638aecfb-4063-4bec-9bf5-a2029fb4b7cd" />
Driver installed
<img width="332" height="474" alt="image" src="https://github.com/user-attachments/assets/c064ed8f-dbca-404f-8e18-788ab41db439" />



No more driver errors
