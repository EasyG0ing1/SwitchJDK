# SwitchJDK
Quick and dirty Windows Powershell script to switch between different Java JDK versions

As I searched for a decent JDK manager for Windows (jenv for Mac works perfectly), I couldn't seem to find one that was easy to implement and/or use. All I needed to do was change the environment Path to the path of the bin folder for the JDK that I want to switch to, and also change the JAVA_HOME environment variable to the parent of the bin folder.

This script does exactly that and does it well. 

To use the script, click on it above, then click on RAW and then copy it into notepad and save it as any name you like with the .ps1 file extension.

The script picks up the name that you give it and uses that name in all of the feedback resulting from its use.

You can run the script with the ? as the first option to get a complete set of instructions for it's use, but its stupid easy to use and it simply works.
