# SwitchJDK
Quick and dirty Windows Powershell script to switch between different Java JDK versions

As I searched for a decent JDK manager for Windows (jenv for Mac works perfectly), I couldn't seem to find one that was easy to implement and/or use. All I needed to do was change the environment Path to the path of the bin folder for the JDK that I want to switch to, and also change the JAVA_HOME environment variable to the parent of the bin folder.

This script does exactly that and does it well. 

To use the script, click on it above, then click on RAW and then copy it into notepad and save it as any name you like with the .ps1 file extension.

The script picks up the name that you give it and uses that name in all of the feedback resulting from its use.

You can run the script with the ? as the first argument to get a complete set of instructions for it's use, but it is VERY easy to use and it simply works.

You will need to run it from a PowerShell as Administrator. If this bothers you, then you can remove each line above where you find the command ```[Environment]::SetEnvironmentVariable``` and that command has the ```'Machine'``` option at the end of it. Since that command modifies the registry, the script should work fine with thos lines removed without requiring Administrator privileges, but the changes it makes will not persist through reboots.
