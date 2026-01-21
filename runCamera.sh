#! /bin/bash
# Don't forget to configure the video stream, IP address of viewer, and port number!
ip=$1 #192.168.0.2
port=$2 #9998
input=$3 #/dev/video0

echo "Started Camera Auto-restart Program"
# Explanantion of command:
#
# ffmpeg <snip> | netcat <ip> <port>
# We are using ffmpeg to encode the signal from the camera (from the raw /dev/video*) and are piping the encoded video to netcat to send over a tcp port to the viewer
#
# NOTE: video formats (such as h.264) cannnot be sent on their own.  They require a container (such as matroska) to be stored or sent over a network.
#
# Command breakdown:
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# ffmpeg               | The ffmpeg program ( install with "sudo apt install ffmpeg" )
# -re                  | Use the same framerate as the input footage
# -s 640x480           | Sets the input frame size
# -i $input            | Use input stream $input (such as /dev/video0)
# -fflags nobuffer     | Don't buffer the input footage (reduces lag)
# -flags low_delay     | Prioritize getting the footage out the door, not compressing it as well as possible
# -b:v 0               | Set video buffer size to 0 (somehow it is different than the -fflags nobuffer)
# -c:v libx264         | Use libx264 to compress the video.  This is the fastest (lowest latency) compression technique that I could find.  Use -c:v copy to simply use the source compression (which would be no compression, and would require so much bandwidth that it is unusuable)
# -preset ultrafast    | Tell libx264 to use the ultrafast preset.  Prioritizes speed/throughput over compression quality and efficiency
# -tune zerolatency    | Tell lib264 to prioritize reducing latency over reducing CPU time
# -rc-lookahead 0      | Look ahead 0 frames to solve for motion (Used in compression, but disabled here to reduce latency)
# -intra-refreash 1    | Something to do with -g 1
# -slice-max-size 1500 | The maximum size to slice the image into when using multiple threads
# -g 1                 | Use I-frames (full image) every frame (See libx264 docs for details)
# -keyint_min 1        | Minimum number of frames to include in each Group Of Pictures (in this case, 1, as in 1 I-frame)
# -crf 33              | Suggest using quality level 33.  Ranges from 0-52, with lower numbers giving better images, but worse compute time.  Here, we set it fairly high, as we are running on a fairly weak CPU, and evaluation time is at a premium
# -crf-max 35          | Maximum crf allowed (lowest quality of compressed image)
# -flush-packets 1     | Always flush packets when we are done with them
# -f matroska          | Use the Matroska format as the video container.  This is the fastest container I could find (next best was 'flv', at about half the speed).
# - |                  | Send the encoded video frames to stdout and pipe it to the next command
# nc                   | Netcat (also may be called "netcat" or "ncat" depending on distro).  Install with "sudo apt install ncat".
# $ip                  | Destination IP.  In this case, the viewer's computer.
# $port                | Destination Port.  MAKE SURE TO CHANGE THIS FOR EACH CAMERA!!!
echo "Starting Camera Feed Attempts"
while [ 1 ]; do
  ffmpeg -re -s 640x480 -i $input -fflags nobuffer -flags low_delay -b:v 0 -c:v libx264 -preset ultrafast -tune zerolatency -rc-lookahead 0 -intra-refresh 1 -slice-max-size 1500 -g 1 -keyint_min 1 -crf 33 -crf_max 35 -flush_packets 1 -f matroska - | nc $ip $port
  sleep 5 # 5-second timeout between connection attempts
done
