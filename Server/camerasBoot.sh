#! /bin/bahs

sudo modprobe v4l2loopback

# video 0
sudo v4l2loopback-ctl add 100
sudo v4l2loopback-ctl add 101
sudo v4l2loopback-ctl add 102

# video 1
sudo v4l2loopback-ctl add 110
sudo v4l2loopback-ctl add 111
sudo v4l2loopback-ctl add 112

# video 2
sudo v4l2loopback-ctl add 120
sudo v4l2loopback-ctl add 121
sudo v4l2loopback-ctl add 122
