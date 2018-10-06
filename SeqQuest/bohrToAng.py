import argparse

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("bohrFile", help="File name of geometry file with positions in bohr")
    args = parser.parse_args()
    with open(args.bohrFile,'r') as bf:
        line = bf.readline().strip()
        print(line)
        line = bf.readline().strip()
        print(line)
        for line in bf:
            lineList = line.strip().split()
            xAng = float(lineList[-3]) * 0.529177249
            yAng = float(lineList[-2]) * 0.529177249
            zAng = float(lineList[-1]) * 0.529177249
            print("{:>2s}{:>10.5f}{:>10.5f}{:>10.5f}".format(lineList[0],xAng,yAng,zAng))

main()
