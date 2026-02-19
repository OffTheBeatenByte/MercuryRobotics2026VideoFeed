import cv2
import numpy as np
from pathlib import Path
import pickle
import sys
from pupil_apriltags import Detector

GRAPHICAL = True
OUTPUT_PATH = "/home/pi/MercuryRobotics2026VideoFeed/Camera/Server/Live/aprilTags"

pkl_path = Path("./output/calibration_data.pkl") #path for the data package

with pkl_path.open("rb") as f:
    calibration_data = pickle.load(f)
    
# Define the 3D object points of the tag in its own coordinate system
# The size is the length of the inner edge (e.g., 0.1 meters for a 10cm tag)
tag_size = 0.0508 #placeholder and in meters
tag_half_size = tag_size / 2.0
object_points = np.array([
        [-tag_half_size, tag_half_size, 0],
        [tag_half_size, tag_half_size, 0],
        [tag_half_size, -tag_half_size, 0],
        [-tag_half_size, -tag_half_size, 0]
    ], dtype=np.float32)

detector = Detector(families='tag36h11')

cam = cv2.VideoCapture(sys.argv[1])

ret, frame = cam.read()
while (cam.isOpened()):  
    _,frame = cam.read()
    
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    if GRAPHICAL:
        cv2.imshow("Apriltags", frame)
        
    detected_tags = detector.detect(gray)

    for tag in detected_tags:   
        dist_coeffs = np.array(
            calibration_data["distortion_coefficients"],
            dtype=np.float64
        )
        camera_matrix = np.array(
            calibration_data["camera_matrix"],
            dtype=np.float64
        )
        image_points = tag.corners.astype(np.float64) 

    # Use solvePnP to get rotation and translation vectors
    success, rvec, tvec = cv2.solvePnP(object_points, image_points, camera_matrix, dist_coeffs)

    if success:
        # Calculate the distance (magnitude of the translation vector) (can just use the Z distance to speed it up, at a loss of accuracy)
        distance = np.sqrt(tvec[0]**2 + tvec[1]**2 + tvec[2]**2) *100

        # write the output file
        # we rewrite the output file every iteration so only the newest tag data is available
        with open(OUTPUT_PATH, 'w') as f:
            s = f"{tag.tag_id},{tvec[0]},{tvec[1]},{tvec[2]},{distance}"
            f.write(s)
            print(s)

    if GRAPHICAL:
        key = cv2.waitKey(1) & 0xFF
        if key == ord('q'):
            break   