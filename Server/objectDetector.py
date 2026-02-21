#! /usr/bin/python3
print("begin")
import cv2
import sys
import time
from ultralytics import YOLO
import torch.nn.utils.prune as prune


INPUT = "yolo_fifo" # we pull from a named pipe

print("start", flush=True) # status

model = YOLO("yolo26n_ncnn_model", task="detect")
prune.random_unstructured(model.model, name='weight', amount=0.3) #TODO TEST THIS
cap = cv2.VideoCapture(INPUT)
i = 0
while not cap.isOpened():
    cap = cv2.VideoCapture(INPUT)
    i += 1
    print(f"loading capture failed... Retrying {i}", flush=True) # keep printing with increasing numbers so we can see that it is still alive
    time.sleep(0.02)

print("rolling", flush=True)
with open(sys.argv[1], "w") as f: # output file, supplied from args
    while cap.isOpened():
        # Read six frames from the video
        # This is to attempt to decrease CPU load
        _, _ = cap.read()
        _, _ = cap.read()
        _, _ = cap.read()
        _, _ = cap.read()
        _, _ = cap.read()
        success, frame = cap.read()

        if success:
            results = model.predict(frame,  classes=[65,41], conf=0.2)
            for result in results:
                for box in result.boxes:
                    print(f"{int(box.cls)},{int(box.conf*100)},{int(box.xywh[0][0])},{int(box.xywh[0][1])},{int(box.xywh[0][2])},{int(box.xywh[0][3])}", end="\t", file=f)
            print(file=f, flush=True)
        else:
            # Break the loop if the video stream breaks
            break

cap.release()