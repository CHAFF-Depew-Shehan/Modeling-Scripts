# Assumes that the format of the file is as produced
# by ReaxFF
import argparse

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("bgfFilename", help="File name of bgf or geo file to convert")
    args = parser.parse_args()
    with open(args.bgfFilename,'r') as bgf:
        moreFiles = True
        while moreFiles:
            end = False
            while not end:
                line = bgf.readline()
                if line == "\n":
                    end = True
                elif line[0:2] == "END":
                    end = True
                    pdb.close()
                elif line == "":
                    end = True
                    moreFiles = False
                elif line[0:6] == "DESCRP":
                    line = line.strip().split()
                    pdbName = line[-1] + ".pdb"
                    pdb = open(pdbName,'w')
                elif line[0:6] == "HETATM":
                    line = line.strip().split()
                    aID = int(line[1])
                    el = line[2]
                    x = float(line[3])
                    y = float(line[4])
                    z = float(line[5])
                    print("HETATM{:5d} {:>4} ALL 1        {:>8.3f}{:>8.3f}{:>8.3f}  1.00  0.00          {:>2} 0".format(
                        aID, el, x, y, z, el), file=pdb)
                elif line[0:6] == "CONECT":
                    line = line.strip().split()
                    # Each of these numbers is going to need to be processed individually and then concatenated
                    nums = "".join(["{:>5}".format(i) for i in line[1:]])
                    print("CONECT{}".format(nums), file=pdb)

main()
