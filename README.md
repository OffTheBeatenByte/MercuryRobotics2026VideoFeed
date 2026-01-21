**Oklahoma State University Mercury Robotics Club 2026 STORM Challange Camera Feed**
------------------------------------------------------------------------------------

This project attempts to document and store all information realted to the live unencrypted camera feed from the robot to a remote viewer's computer.

To use, copy the "Camera" folder to the home directory of the robot's computer, change the ip address and video stream inputs in each .service file, and copy the .service files to /etc/systemd/system/ and reboot the Pi.  The camera feeds should be accessable using the script in the "Viewer" folder, running on the computer with the ip address used earlier.
MAKE SURE TO CHANGE THE IP AND VIDEO INPUT PATH FOR ALL THREE .service FILES!

**WARNING: NONE OF THE CODE HEREIN HAS BEEN TESTED.  USE AT YOUR OWN RISK!!!**
_Please remove this warning once code has been tested._
