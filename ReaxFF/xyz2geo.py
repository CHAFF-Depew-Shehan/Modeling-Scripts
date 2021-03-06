#!/usr/bin/env python
# Write a GEO file using a preexisting XYZ file
import argparse
import os
import os.path

# Receive command line input for test case number
parser = argparse.ArgumentParser(description='Turn XYZ into GEO')
parser.add_argument('testNumber',type=int,help='an integer representing the test number')
#parser.add_argument('molecule',type=str,help='molecule being used in tests')
args = parser.parse_args()
test = args.testNumber
mol = 'HNO3'

# Locate XYZ file
xyzDir = "/mnt/c/Users/Shehan Parmar/Desktop/CHAFFDesktop/CHAFF/REAXFF/xyzFiles/" + str(test)
files = os.listdir(xyzDir)
if len(files) > 1:
    raise ValueError('Too many XYZ files in test directory!')
xyzFile = xyzDir + '/' + files[0]

# Store trajectory variables based on xyz format
with open(xyzFile,'r') as xyz:
    info = {'Symbol':[],'xPos':[],'yPos':[],'zPos':[]}
    line = xyz.readline()
    cnt = 1
    while (line) or (cnt < 3):
        line = xyz.readline().split()
        if not line:
            continue
        info['Symbol'].append(line[0])
        info['xPos'].append(line[1])
        info['yPos'].append(line[2])
        info['zPos'].append(line[3])
        cnt += 1
numAtoms = len(info['Symbol'])

# Write geo file
geoPath = '/mnt/c/Users/Shehan Parmar/Desktop/CHAFFDesktop/CHAFF/REAXFF/RUNS/' + str(test) + '_test_' + mol + '/geo'
if os.path.isfile(geoPath):
    os.remove(geoPath)
    print('Removing current geo file')
with open(geoPath,'w') as geo:
    geo.write('BIOGRF 200\n')
    geo.write('DESCRP ' + mol + '\n')
    #geo.write('DESCRIP ' + mol + '_test' + str(test) + '\n')
    geo.write('REMARK .bgf-file generated by xtob-script\n')
    #geo.write('RUTYPE NORMAL RUN\n')
    #geo.write('FORMAT ATOM  (a6,1x,i5,1x,a5,1x,a3,1x,a1,1x,a5,3f10.5,1x,a5,i3,i2,1x,f8.5)\n')
    for i in range(1,numAtoms+1):
        geo.write("{:7}".format('HETATM ')) # Occupies 6 characters plus addition space (a6,1x)
        geo.write('%5s ' % (str(i))) # Occupies 6 characters plus additional space (i5,1x)
        geo.write('%-5s ' % (info['Symbol'][i-1])) # Occupies 6 characters plus additional space (a5,1x)
        geo.write("{:11}".format(' ')) # Occupies 11 characters (a3,1x,a1,1x,a5)
        geo.write('%10.5f%10.5f%10.5f' % (float(info['xPos'][i-1]), float(info['yPos'][i-1]), float(info['zPos'][i-1]))) # Occupies 30 characters (3f10.5)
        geo.write('%5s ' % (info['Symbol'][i-1])) # Occupies 6 characters (1x,a5)
        geo.write('%3s%2s  %-7.5f\n' % (0,0,0)) # Occupies 14 characters (i3,i2,1x,f8.5)
        #geo.write('\n') # With this format, should take 79-80 characters (=6+6+6+11+30+6+14)
    #geo.write('FORMAT CONECT  (a6,12i6)\n')
    geo.write('END\n\n')

print('Geo file updated.')
