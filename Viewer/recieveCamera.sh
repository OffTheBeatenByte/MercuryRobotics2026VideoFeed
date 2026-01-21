#! /bin/bash

# DO NOT FORGET TO OPEN TCP PORTS 9990, 9991, 9992 IN ANY FIREWALLS

# start the reciever of camera 0
eval "while [ 1 ]; do nc -l 9990 | ffplay -fflags +nobuffer -flags +low_delay -framedrop -fflags nobuffer -infbuf -vf setpts=0 - 2> camera0Log.txt; echo Restarting camera0; sleep 2; done" &
eval "while [ 1 ]; do nc -l 9991 | ffplay -flags +low_delay -framedrop -fflags nobuffer -infbuf -vf setpts=0 - 2> camera1Log.txt; echo Restarting camera1; sleep 2; done" &
eval "while [ 1 ]; do nc -l 9992 | ffplay -flags +low_delay -framedrop -fflags nobuffer -infbuf -vf setpts=0 - 2> camera2Log.txt; echo Restarting camera2; sleep 2; done"
