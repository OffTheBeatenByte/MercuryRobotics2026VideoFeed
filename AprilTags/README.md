**Camera Server and AprilTag Reader**
=====================================

This gist holds the Camera Server and AprilTag reader for the Oklahoma State University Mercury Robotics STORM 2026 Competition Robot (hereafter referred to as "the robot").  To use, make sure all dependencies are met (see below), and select a unique tcp port for each camera, get the ip address of the viewer's computer, create (if necessary) an output file for the tag detections, and find the correct /dev/video* device for the camera that you wish to use.

It is called like this:

./reader.sh <videostream input> <port> <ip address> <output file>

For example:

./reader.sh /dev/video2 9990 192.168.0.2 tags

**To Operate:**
===============

1. Start your client on the viewer side

nc -l 9990 | ffplay -fflags +nobuffer -flags +low_delay -framedrop -infbuf -vf setpts=0 -

2. Start the server-side script

./reader.sh /dev/video2 9990 192.168.0.103 tags

3. Read out the tag data

watch -n 0.1 cat tags

4. Move AprilTags in and out of frame, and watch as they appear in the "watch cat tags" window

**Protocol for Output File**

One line, with separate tags separated by tabs "\t".  Each tag is comma-separated integers: tagID,LeftBottomCornerX,
LeftBottomCornerY,RightBottomCornerX,RightBottomCornerY,RightTopCornerX,RightTopCornerY,LeftTopCornerX,LeftTopCornerY

**Stats:**
==========

- 640 x 480 @ 24 fps (capped by webcam),
- 1.1 - 2.0 Mb/s network bandwidth used
- UNKNOWN CPU usage on production hardware
- Fails on disconnect from host (more of a bug, see Limitations below)
- h.264 encoding inside Matroska container,
- Not the greatest video quality, but completely usable for driving around,
- As stable as the network carrying it is
- Can recover from multi-second lag spikes / network drops (during which no video is transmitted) with no issues
- No hard limits on number of tags readable simultaneously (other than how many can be reliably read from the video stream)


**Limitations:**
================

This program only runs if a viewer is connected, and fails otherwise.  Putting the command to run this program in an auto-restarting systemd unit is advised.  CPU load is UNTESTED on production hardware.  Performance impact is UNKNOWN.

**Dependencies:**
=============

Some of these may already installed.

sudo apt install python3-opencv

sudo apt install python3-apriltag

sudo apt install ffmpeg

sudo apt install ncat
