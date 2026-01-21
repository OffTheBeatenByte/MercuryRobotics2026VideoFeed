**Oklahoma State University Mercury Robotics Club 2026 STORM Challange Camera Feed**
------------------------------------------------------------------------------------

This project attempts to document and store all information realted to the live unencrypted camera feed from the robot to a remote viewer's computer.

To use, copy the "Camera" folder to the home directory of the robot's computer, change the ip address and video stream inputs in each .service file, copy the .service files to "/etc/systemd/system/", reboot the Pi, copy the "Viewer" folder to the viewer's computer at the ip address indicated earlier.  The camera feeds should be accessible using the script in the "Viewer" folder.

Status of Testing:

- 640 x 480 @ 24 fps OR 1280x720 @ 6.4 fps (both capped by webcam),
- Raspberry Pi Zero 2W running latest Raspbian Lite (Debian 12),
- 280 ms latency (measured),
- Network ping stats: min:1ms / max:5600ms / avg:11ms / stddev:87ms 2% packet loss,
- Stable for 55+ min (not tested beyond),
- ~250 Kb/s network usage,
- Only tested with one camera,
- 85% CPU singlecore usage @ 600MHz; 60% CPU singlecore usage @ 1000MHz,
- h.264 encoding inside Matroska container,
- Network packet drops (up to 10s long on my WiFi) causes no video to be transmitted,
- Recovers from network drops with no issues,
- Not the greatest video quality, but completely usable for driving around,
- Camera-side dependencies: ffmpeg, netcat, matroska,
- Viewer-side dependencies: ffmpeg, netcat,
- Currently uses tcp port 9998 (make sure to open this up in any firewalls),
- Unencryped

MAKE SURE TO CHANGE THE IP AND VIDEO INPUT PATH FOR ALL THREE .service FILES!

**WARNING: NONE OF THE CODE HEREIN HAS BEEN TESTED.  USE AT YOUR OWN RISK!!!**

_Please remove this warning once code has been tested._


AUTHORS:
Tyler Blair (github @OffTheBeatenByte)
