#! /bin/bash

# DO NOT FORGET TO OPEN TCP PORTS 9990, 9991, 9992 IN ANY FIREWALLS

# ffplay reads the input stream to figure out what encoding and container is in use, so we do not have to specify them here

# Command breakdown:
#--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# eval <snip> &                                                 | Run the snipped command in a subshell in the background (nonblocking)
# while [ 1 ]; do <snip> echo Restarting camera0; sleep 2; done | Repeat forever, printing a message between attempts and sleeping for 2 seconds before retrying
# nc -l 9990 |                                                  | Set up a netcat "sudo apt install ncat" tcp listener on port 9990 and send any received data to stdout
# ffplay                                                        | Use ffplay to display the video.  Creates a new SDL window to display the stream
# -fflags +nobuffer -flags +low_delay                           | Tell ffplay to not use an internal buffer and to prioritize getting the frames out to the screen
# -framedrop                                                    | Drop frames as necessary to get back to realtime
# -infbuf                                                       | Use an infinite input buffer to take frames from the input as fast as possible (prevents frames from building up in the sending-side output buffer)
# -vf setpts=0                                                  | Set the presentation timestamp of the video so it starts playing as soon as possible, and counteracts any initial lag
# - 2> camera0Log.txt                                           | Use stdin as the video input (piped from netcat), and send the output (which is sent over stderr) to a logfile for each camera

# start the reciever of camera 0, 1, 2
eval "while [ 1 ]; do nc -l 9990 | ffplay -fflags +nobuffer -flags +low_delay -framedrop -infbuf -vf setpts=0 - 2> camera0Log.txt; echo Restarting camera0; sleep 2; done" &
eval "while [ 1 ]; do nc -l 9991 | ffplay -fflags +nobuffer -flags +low_delay -framedrop -infbuf -vf setpts=0 - 2> camera1Log.txt; echo Restarting camera1; sleep 2; done" &
eval "while [ 1 ]; do nc -l 9992 | ffplay -fflags +nobuffer -flags +low_delay -framedrop -infbuf -vf setpts=0 - 2> camera2Log.txt; echo Restarting camera2; sleep 2; done"
