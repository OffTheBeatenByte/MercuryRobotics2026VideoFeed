#! /bin/bash

# THIS FILE IS JUST FOR REFERENCE!!!!!
# DO NOT USE IN PRODUCTION!!!!




















input=${1:-/dev/video2} # take argv[1] if it exists, otherwise /dev/video2
port=${2:-9990}
ip=${3:-192.168.0.103}
tags=${4:-tags}
detection_file=${5:-detected}

# Explanation of all commands
# NOTE: all lines are technically one line.  "\" is the line continuation character in bash

# Line 1:
#   ./objectDetector.py    | Run the object detection program
#   $detection_file &      | Use the supplied file to write data to

# Line 2:
#   sleep 2           | Give objectDetector time to load the model

# Line 3:
#   ffmpeg            | Use ffmpeg to read the video from the raw camera device
#   -re               | Read at the same framerate as the source
#   -s 640x480        | Output at 640x480 pixels
#   -i $input         | Use $input as the input file (typically one of /dev/video*)
#   -fflags +nobuffer | Don't use an input buffer.  This helps reduce latency
#   -flags +low_delay | Attempt to get the video piped out as fast as possible
#   -c:v rawvideo     | Use the 'rawvideo' codec, which is the same as the camera's output
#   -f matroska       | Use the 'matroska' output format.  This is the lowest latency format that I could find.
#   - | \             | Output the video to stdout and pipe it to the next command

# Line 4:
#   tee                       | Take a input stream and dump it to stdout as well as any files specified.  THIS COMMAND BLOCKS ON FILE WRITE ERRORS!
#   >(                        | A shell file-to-command redirect.  This redirects what would usually be going to a file and sends it to the stdin of the following command.  Closed with ")"
#   sudo ./aprilTagReader.py  | Run the AprilTag reading program.  Sends the position of tags to stdout.  The detector creates a subprocess, which requires root privileges, which "sudo" provides. TODO: Find a better way to do this without "sudo"
#   > $tags                   | Redirect the tag data to file $tags
#   &) | \                    | Run the preceding command in a background process (nonblocking), close the file-to-command redirect, and pipe the output of "tee" to the next line.

# Lines 5 & 6:
#   tee >(ffmpeg         | Use ffmpeg to read from
#   -re                  | Use the same framerate as the input footage
#   -s 640x480           | Sets the input frame size
#   -i /dev/stdin        | Uses /dev/stdin as the input (from "tee").  It seems to prefer this over "-" (which should be the same thing...)
#   -fflags nobuffer     | Don't buffer the input footage (reduces lag)
#   -flags +low_delay    | Prioritize getting the footage out the door, not compressing it as well as possible
#   -b:v 0               | Set video buffer size to 0 (somehow it is different than the -fflags nobuffer)
#   -c:v libx264         | Use libx264 to compress the video.  This is the fastest (lowest latency) compression technique that I could find.  Use -c:v copy to simply use the source compression (which would be no compression, and would require so much bandwidth that it is unusuable)
#   -preset superfast    | Tell libx264 to use the superfast preset.  Generally prioritizes speed/throughput over compression quality and efficiency, but some compression density is taken into account
#   -tune zerolatency    | Tell lib264 to prioritize reducing latency over reducing CPU time
#   -rc-lookahead 0      | Look ahead 0 frames to solve for motion (Used in compression, but disabled here to reduce latency)
#   -intra-refresh 1     | Something to do with -g 1
#   -slice-max-size 1500 | The maximum size to slice the image into when using multiple threads
#   -g 1                 | Use I-frames (full image) every frame (See libx264 docs for details)
#   -keyint_min 1        | Minimum number of frames to include in each Group Of Pictures (in this case, 1, as in 1 I-frame)
#   -crf 30              | Suggest using quality level 30.  Ranges from 0-52, with lower numbers giving better images, but worse compute time.  Here, we set it fairly high, as we are running on a fairly weak CPU, and evaluation time is at a premium
#   -crf-max 35          | Maximum crf allowed (lowest quality of compressed image)
#   -f matroska          | Use the Matroska format as the video container.  This is the fastest container I could find (next best was 'flv', at about half the speed).
#   -                    | Send the encoded video frames to stdout
#   2> encoded_log       | Send our console output (on stderr) to the file "encoded_log"
#   |                    | Pipe the encoded video to the next command
#   nc                   | Netcat (also may be called "netcat" or "ncat" depending on distro).  Install with "sudo apt install ncat".
#   $ip                  | Destination IP.  In this case, the viewer's computer.
#   $port) \             | Destination Port.  MAKE SURE TO CHANGE THIS FOR EACH CAMERA!!!  Also closes the file-to-command redirect

# Line 7:
# stdbuf -i 500M         | Use the output of the previous tee and insert a 500MB buffer.  This is because objectDetector takes images in batches, so we need to buffer them in-between pulls.
# cat > yolo_fifo            | And send it to the named pipe

#./objectDetector.py $detection_file & # we need to start this first, as it takes a while to start up
#sleep 4

ffmpeg -re -s 640x480 -i $input -fflags +nobuffer -flags +low_delay -c:v rawvideo -f matroska - | \
#tee >(./aprilTagReader.py > $tags &) | \
tee >(ffmpeg -re -i /dev/stdin -fflags +nobuffer -flags +low_delay -b:v 0 -c:v libx264 -preset superfast \
  -tune zerolatency -rc-lookahead 0 -intra-refresh 1 -slice-max-size 1500 -g 1 -keyint_min 1 -crf 30 -crf_max 35 -f matroska - 2> encoded_log | nc $ip $port &) | \
#stdbuf -i 500M cat > yolo_fifo 
tee /dev/null > /dev/null



# stream from the camera to the v4l2loopback spots
sudo modprobe v4l2loopback video_nr=10,11,12 card_label="video0_copy"
ffmpeg -r 40 -s 640x480 -i /dev/video0 -fflags +nobuffer -flags +low_delay -f v4l2 /dev/video10 -f v4l2 /dev/video11 -f v4l2 /dev/video12
