**Oklahoma State University Mercury Robotics Club 2026 STORM Challenge Camera Feed**
====================================================================================

This project attempts to document and store all information related to the live unencrypted camera feed from the robot to a remote viewer's computer.

To use, copy the AprilTags folder to the home director of the Pi and follow the instructions in AprilTags/README.md .  To set up the Viewer, copy the Viewer folder to the viewer's computer and run the receiveCamera.sh script.  Make sure to start this script before starting the robot's script.

Status of Testing:

- 640 x 480 @ 24 fps OR 1280x720 @ 6.4 fps (both capped by webcam),
- 280 ms latency (measured),
- Network ping stats: min:1ms / max:5600ms / avg:11ms / stddev:87ms 2% packet loss,
- Stable for 55+ min (not tested beyond),
- ~ 1.1-2.0 Mb/s network bandwidth used
- Only tested with one camera,
- h.264 encoding inside Matroska container,
- Network packet drops (up to 10s long on my WiFi) causes no video to be transmitted,
- Recovers from network drops with no issues,
- Not the greatest video quality, but completely usable for driving around,
- Camera-side dependencies: See AprilTags/README.md
- Viewer-side dependencies: ffmpeg, netcat,
- Currently uses tcp port 9990 (make sure to open this up in any firewalls),
- Unencryped


**WARNING: SOME OF THE CODE HEREIN HAS NOT BEEN TESTED.  USE AT YOUR OWN RISK!!!**


AUTHORS:
Tyler Blair (github @OffTheBeatenByte)
