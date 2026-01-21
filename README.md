**Oklahoma State University Mercury Robotics Club 2026 STORM Challange Camera Feed**
------------------------------------------------------------------------------------

This project attempts to document and store all information realted to the live unencrypted camera feed from the robot to a remote viewer's computer.

To use, copy the "Camera" folder to the home directory of the robot's computer, change the ip address and video stream inputs in each .service file, copy the .service files to "/etc/systemd/system/", reboot the Pi, copy the "Viewer" folder to the viewer's computer at the ip address indicated earlier.  The camera feeds should be accessible using the script in the "Viewer" folder.

MAKE SURE TO CHANGE THE IP AND VIDEO INPUT PATH FOR ALL THREE .service FILES!

**WARNING: NONE OF THE CODE HEREIN HAS BEEN TESTED.  USE AT YOUR OWN RISK!!!**

_Please remove this warning once code has been tested._
