# MSHV_Config_Swapper
A simple utility to manage configuration files used by the amateur radio program [MSHV](http://lz2hv.org/mshv) by LZ2HV.

**MSHV CONFIGURATION SWAPPER**                                      v1.00  
by Jim Varney, K6OK
  
![image](https://github.com/K6OK/MSHV_Config_Swapper/assets/116767386/41b371f0-3185-4003-8cf3-ef808c228506)



Program allows the user to store and load up to 6 different MSHV 
configurations. Each saved configuration includes all of the settings in effect when 
saved.

**DOWNLOAD.** Click on "Releases" on the right and download MSHV_Config_Swapper.exe.
This is a single portable Win32 desktop application file. Place just about 
anywhere on your PC hard drive.  

**INSTALL.**  Run Swapper. Click Setup. Follow the instructions: Step 1 creates the 
storage folders on your drive (in {USER}\AppData\Local). Step 2 asks you to 
show Swapper where your MSHV folder is.

**SAVE A CONFIG.** In MSHV, set all desired options. In Swapper, select Configuration, 
write a short description into one of the 6 memory slots.  Click Save.

**LOAD A CONFIG.** Close MSHV. On the main Swapper screen, click one of the 6 
buttons to load that previously saved configuration. Restart MSHV.  Hovering your 
mouse over the button will display your description for that configuration.

NOTE: You must shut down MSHV before loading a saved configuration.

---------------------

**Example of Typical Usage:**  
You wish to use MSHV for normal FT-8 DXing (HF) but also be able to switch to meteor scatter on 6 meters.

Prepare and Load the Memories:
1. Set all MSHV options for normal FT-8 DXing as you like them. Go to Swapper, select Configuration, and put "Normal HF FT8" in the entry box for Memory 1.  Click Save.
2. Set all MSHV options for meteor scatter. Go to Swapper/Configuration, put "Meteor Scatter" in the entry box for Memory 2. Click Save.

Normal Use: 
  
You decide to start operating in meteor scatter mode. Start Swapper first, click on Memory button 2. Now start MSHV.  It's ready for meteor scatter work.
Later you wish to do regular HF FT-8.  Close MSHV. Go to Swapper, click on Memory button 1. Restart MSHV. It's now ready for HF FT-8.

---------------------

WHY IS SWAPPER SO SMALL?  It's small on purpose because I wanted to be able 
to tuck it into a screen corner and not use up very much monitor real estate.

Tested on Windows 10 with MSHV 2.71. -- 73 gud DX!

