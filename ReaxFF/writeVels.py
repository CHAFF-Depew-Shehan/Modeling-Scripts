# Takes a LAMMPS data input file and converts it to a restart file for
# standalone ReaxFF as a vels file with initial positions and velocities.
# Currently HARD CODED

def main():
    with open('data.restart_N2H4_Pt_07-18-18','r') as fin, open('vels_restart','w') as fout:
        for i in range(17):
            fin.readline()

        print("\n\n 330 Atom coordinates (Angstrom):",file=fout)
        for i in range(330):
            line = fin.readline().strip().split()
            pos = [float(x) for x in line[-3:]]
            if line[1] == "1":
                el = "H"
            elif line[1] == "2":
                el = "N"
            elif line[1] == "3":
                el = "Pt"
            print("{0[0]:24.15E}{0[1]:24.15E}{0[2]:24.15E} {1}".format(pos,el), file=fout)
        for i in range(3):
            fin.readline()
        print(" Atom velocities (Angstrom/s):",file=fout)
        for i in range(330):
            line = fin.readline().strip().split()
            vel = [float(x)*1.e15 for x in line[-3:]]
            print("{0[0]:24.15E}{0[1]:24.15E}{0[2]:24.15E}".format(vel), file=fout)

main()
