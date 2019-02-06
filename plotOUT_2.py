#Plots .out file from gaussian run
import argparse
import os
import os.path
import csv
import matplotlib
import matplotlib.pyplot as plt

# Receive command line input for test case number
#parser = argparse.ArgumentParser(description='Create CSV File for Max Force and Max Displacement')
#parser.add_argument('filePath',type=str,help='path of the .out file (i.e. Run1/HAN.out')
#parser.add_argument('fileDestination',type=str,help='destination of CSV path (i.e. Run1/data.csv')
#args = parser.parse_args()
path = 'Run1/HAN_Opt_GIL.out'#args.filePath
dest = 'Run1/data.csv' #args.fileDestination

outDir = "C:/Users/Shehan Parmar/Desktop/CHAFFDesktop/CHAFF/gaussian/" + path
table = [[]]

with open(outDir,'r') as out:

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
            stepDone = True
        if stepDone:
            table.append([step,Fmax,Xmax])
            stepDone = False
csvPath = "C:/Users/Shehan Parmar/Desktop/CHAFFDesktop/CHAFF/gaussian/" + dest

if os.path.isfile(csvPath):
    os.remove(csvPath)
    print('Removing current csv file')

with open(csvPath,'w') as csvfile:
    writer = csv.writer(csvfile)
    [writer.writerow(r) for r in table]

# Create plot image and save to directory
fig = plt.figure()
ax = plt.subplot(111)
x = []
y = []
for val in table:
    if not val:
        continue
    x.append(val[0])
    y.append(val[1])
ax.semilogy(x,y)
fig.savefig('C:/Users/Shehan Parmar/Desktop/CHAFFDesktop/CHAFF/gaussian/Run1/graph.png')





