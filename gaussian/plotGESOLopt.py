#Plots .out file from gaussian run
import argparse
import os
import os.path
import csv
import matplotlib
import matplotlib.pyplot as plt

# Receive command line input for test case number
parser = argparse.ArgumentParser(description='Create CSV File for Max Force and Max Displacement')
#parser.add_argument('filePath',type=str,help='path of the .out file (i.e. Run1/HAN.out')
#parser.add_argument('fileDestination',type=str,help='destination of CSV path (i.e. Run1/data.csv')
parser.add_argument('currentDirectory',type=str,help='top-level working directory')
parser.add_argument('targetDirectory',type=str,help='subdirectory containing Gaussian output (e.g. [currentDirectory]/R4)')
args = parser.parse_args()
path = args.currentDirectory + '/' + args.targetDirectory + '/TS_GIL.out'
dest = args.currentDirectory + '/' + args.targetDirectory + '/optData.csv'

#outDir = "C:/Users/Shehan Parmar/Desktop/CHAFFDesktop/CHAFF/gaussian/" + path
table = [[]]

#with open(outDir,'r') as out:
with open(path,'r') as out:

    stepDone = False
    line = out.readline()
    while line:
        line = out.readline()
        if 'STEP #' in line:
            step = int(line.split()[-1])
        if 'Maximum Force' in line:
            try:
                Fmax = float(line.split()[2])
            except ValueError:
                Fmax = 9.9999
        if 'Maximum Displacement' in line:
            try:
                Xmax = float(line.split()[2])
            except ValueError:
                Xmax = 9.9999
        if 'RMS     Force' in line:
            try:
                Frms = float(line.split()[2])
            except ValueError:
                Frms = 9.9999
        if 'RMS     Displacement' in line:
            try:
                Xrms = float(line.split()[2])
            except ValueError:
                Xrms = 9.9999
            stepDone = True
        if stepDone:
            table.append([step,Fmax,Frms,Xmax,Xrms])
            stepDone = False
#csvPath = "C:/Users/Shehan Parmar/Desktop/CHAFFDesktop/CHAFF/gaussian/" + dest

if os.path.isfile(dest):
    os.remove(dest)
    print('Removing current csv file')

with open(dest,'w') as csvfile:
    writer = csv.writer(csvfile)
    [writer.writerow(r) for r in table]

print('Creating plot')
# Create plot image and save to directory
fig = plt.figure(figsize=(6,6))
ax = plt.subplot(211)
x = []
y1 = []
y2 = []
z1 = []
z2 = []
limy1 = []
limy2 = []
limz1 = []
limz2 = []
for val in table:
    if not val:
        continue
    x.append(val[0])
    y1.append(val[1])
    y2.append(val[2])
    z1.append(val[3])
    z2.append(val[4])
    limy1.append(4.5e-4)
    limy2.append(3.0e-4)
    limz1.append(1.8e-3)
    limz2.append(1.2e-3)
ax.semilogy(x,y1, linestyle='-', color='C0')
ax.semilogy(x,z1, linestyle='-', color='C1')
ax.semilogy(x,limy1, linestyle=':', color='C0')
ax.semilogy(x,limz1, linestyle=':', color='C1')
ax.legend(['Max Force','Max Displacement'], loc='lower left')
ax2 = plt.subplot(212)
ax2.semilogy(x,y2, linestyle='-', color='C0')
ax2.semilogy(x,z2, linestyle='-', color='C1')
ax2.semilogy(x,limy2, linestyle=':', color='C0')
ax2.semilogy(x,limz2, linestyle=':', color='C1')
ax2.legend(['RMS Force','RMS Displacement'], loc='lower left')
fig.suptitle(args.targetDirectory)
fig.savefig(args.currentDirectory + '/' + args.targetDirectory + '/optProfile.png')
plt.show()
