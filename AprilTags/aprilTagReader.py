#! /usr/bin/python3
from apriltag import apriltag
import cv2
import time

detector = apriltag("tag36h11")

def main():
    #open webcam
    while True:
        cap = cv2.VideoCapture("/dev/stdin")
        if not cap.isOpened():
            print("Error: could not open camera")
            time.sleep(0.5)
        else:
            break
    
    # read and detect
    while True:
        ret, frame = cap.read()
        if not ret:
            print("Can't receive frame.")
            cap.release()
            return
        
        grayscale_frame = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
        detections = detector.detect(grayscale_frame)

        if len(detections) > 0:
            for d in detections: # print out a tab-separated list of detected tags
                print(f"{d["id"]},{int(d["lb-rb-rt-lt"][0][0])},{int(d["lb-rb-rt-lt"][0][1])},{int(d["lb-rb-rt-lt"][1][0])}," \
                        f"{int(d["lb-rb-rt-lt"][1][1])},{int(d["lb-rb-rt-lt"][2][0])},{int(d["lb-rb-rt-lt"][2][1])},{int(d["lb-rb-rt-lt"][3][0])},{int(d["lb-rb-rt-lt"][3][1])}", end="\t")
        print(flush=True)

if   __name__ == "__main__":
    main()
