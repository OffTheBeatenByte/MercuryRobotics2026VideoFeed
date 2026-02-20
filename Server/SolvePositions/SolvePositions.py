# SolvePositions.py
from collections import namedtuple
import socket
import sys
from typing import List, Tuple

Tag = namedtuple("Tag", "id x y z".split(" "))

class AprilTagReader:
    def __init__(self, tag_file: str, offset_pos: tuple, offset_rot: float):
        self.file = tag_file
        self.offset_pos = offset_pos
        self.offset_rot = offset_rot
    
    def readTag(self):
        with open(self.file, "r") as f:
            data = f.readline()
        # attempt to parse the data
        tags_str = [x.split(",") for x in data.split("\t")]
        tags = []
        for tag in tags_str:
            if len(tag) != 5:
                continue # Malformed tag data.  Ignore
            id = int(tag[0])
            y = float(tag[2])
            x = float(tag[1])
            z = float(tag[3])
            if self.offset_rot == 1:
                x, z = z, -x
            elif self.offset_rot == 2:
                x, z = -x, -z
            elif self.offset_rot == 3:
                x, z = -z, x
            
            # Camera uses a y-up, left-handed coordinate system,
            # but the robot uses a z-up, left-handed coordinate system.
            # So we swap Z and Y
            tags.append(Tag[id, x+self.offset_pos[0], z+self.offset_pos[2], y+self.offset_pos[1]])
        return tags

class AprilTagSolver:
    KNOWN_POSITIONS = [
        Tag(0, ),#####################################################################################################################################
        ]
    def __init__(self, *readers: List[str, Tuple[int], int]):
        self.tag_readers = [AprilTagReader(file, pos, rot) for file, pos, rot in readers]
        
    def solvePosition(self):
        tags = []
        for reader in self.tag_readers:
            tags.extend(reader.readTag()) # offsets are already applied
            

def main():
    with open("./IP", "r") as f:
        IP = f.readline()
    client_sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    
    # rotations:
    # 0 = front, 1 = left, 2 = back, 3 = right
    april_tag_solve = AprilTagSolver(["./tags", (0, 0, 0), 0])
    
    while True:
        # solve positions
        april_tag_position = april_tag_solve.solvePosition()
        
        # combine positions
        
        # write output
        
        # send debug info
        client_sock.sendto(data, IP)

if __name__ == "__main__":
    main()