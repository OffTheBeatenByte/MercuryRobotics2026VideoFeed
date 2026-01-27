#! /usr/bin/python3
print("begin")
import cv2
import sys
import time
from ultralytics import YOLO
INPUT = "yolo_fifo"

print("start", flush=True)
model = YOLO("yolo26n_ncnn_model", task="detect")

cap = cv2.VideoCapture(INPUT)
i = 0
while not cap.isOpened():
    cap = cv2.VideoCapture(INPUT)
    i += 1
    print(f"loading capture failed... Retrying {i}", flush=True)
    time.sleep(0.02)

print("rolling", flush=True)
with open("detected", "w") as f:
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
            results = model.predict(frame)
            for result in results:
                for box in result.boxes:
                    print(f"{int(box.cls)},{int(box.conf*100)},{int(box.xywh[0][0])},{int(box.xywh[0][1])},{int(box.xywh[0][2])},{int(box.xywh[0][3])}", end=" ", file=f)
            print(file=f, flush=True)
            #print("\t".join(result.boxes.xywh[][] for result in results), file=f, flush=True)
        else:
            # Break the loop if the end of the video is reached
            break

cap.release()