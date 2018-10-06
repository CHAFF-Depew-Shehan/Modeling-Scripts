%{ 
Shehan Parmar 
CHAFF - Fall 2018
Geometry Optimization Code
smparmar@usc.edu
Revision History
Date            Changes          Programmer
-----------------------------------------------
09/11/2018      Original         Shehan Parmar
%}

clc;
clear all;
mol = 'HNO3';
testNum = '16';     

% FORT.57 FILE VARIABLES
filename = strcat('C:\Users\Shehan Parmar\Desktop\CHAFFDesktop\CHAFF\REAXFF\RUNS\',testNum,'_test_',mol,'\fort.57');
startRow = 3;
formatSpec = '%6f%22f%13f%13f%13f%f%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
iter = dataArray{:, 1};
Epot = dataArray{:, 2};
Temp = dataArray{:, 3};
Tset = dataArray{:, 4};
RMSG = dataArray{:, 5};
nfc = dataArray{:, 6};
clearvars filename startRow formatSpec fileID dataArray ans;
% Plot Variables
plot(iter,Epot);
ylabel('{\fontname{Times New Roman}\fontsize{12} \itE_{pot}} [kcal/mol]'); 
xlabel('{\fontname{Times New Roman}\fontsize{12} \itIteration} [#]');

% GEO/XYZ FILE INITIAL POSITIONS
% filename = strcat('C:\Users\Shehan Parmar\Desktop\CHAFFDesktop\CHAFF\REAXFF\xyzFiles\',testNum,'\HNO3_09_11_18.xyz');
% formatSpec = '%1s%17s%15s%s%[^\n\r]';
% fileID = fopen(filename,'r');
% dataArray = textscan(fileID, formatSpec, 'Delimiter', '', 'WhiteSpace', '',  'ReturnOnError', false);
% dataArray{1} = strtrim(dataArray{1});
% fclose(fileID);
% raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
% for col=1:length(dataArray)-1
%     raw(1:length(dataArray{col}),col) = dataArray{col};
% end
% numericData = NaN(size(dataArray{1},1),size(dataArray,2));
% for col=[2,3,4]
%     % Converts text in the input cell array to numbers. Replaced non-numeric
%     % text with NaN.
%     rawData = dataArray{col};
%     for row=1:size(rawData, 1);
%         % Create a regular expression to detect and remove non-numeric prefixes and
%         % suffixes.
%         regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
%         try
%             result = regexp(rawData{row}, regexstr, 'names');
%             numbers = result.numbers;
%             
%             % Detected commas in non-thousand locations.
%             invalidThousandsSeparator = false;
%             if any(numbers==',');
%                 thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
%                 if isempty(regexp(numbers, thousandsRegExp, 'once'));
%                     numbers = NaN;
%                     invalidThousandsSeparator = true;
%                 end
%             end
%             % Convert numeric text to numbers.
%             if ~invalidThousandsSeparator;
%                 numbers = textscan(strrep(numbers, ',', ''), '%f');
%                 numericData(row, col) = numbers{1};
%                 raw{row, col} = numbers{1};
%             end
%         catch me
%         end
%     end
% end
% rawNumericColumns = raw(:, [2,3,4]);
% rawCellColumns = raw(:, 1);
% R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),rawNumericColumns); % Find non-numeric cells
% rawNumericColumns(R) = {NaN}; % Replace non-numeric cells
% xi = cell2mat(rawNumericColumns(2:end, 1));
% yi = cell2mat(rawNumericColumns(2:end, 2));
% zi = cell2mat(rawNumericColumns(2:end, 3));
% clearvars filename formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me rawNumericColumns rawCellColumns R;

% XMOLOUT FINAL POSITIONS
filename = strcat('C:\Users\Shehan Parmar\Desktop\CHAFFDesktop\CHAFF\REAXFF\RUNS\',testNum,'_test_',mol,'\xmolout');
delimiter = ' ';
formatSpec = '%s%s%s%s%s%s%s%s%s%[^\n\r]';
fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true,  'ReturnOnError', false);
fclose(fileID);
raw = repmat({''},length(dataArray{1}),length(dataArray)-1);
for col=1:length(dataArray)-1
    raw(1:length(dataArray{col}),col) = dataArray{col};
end
numericData = NaN(size(dataArray{1},1),size(dataArray,2));
for col=[1,2,3,4,5,6,7,8,9]
    % Converts text in the input cell array to numbers. Replaced non-numeric
    % text with NaN.
    rawData = dataArray{col};
    for row=1:size(rawData, 1)
        % Create a regular expression to detect and remove non-numeric prefixes and
        % suffixes.
        regexstr = '(?<prefix>.*?)(?<numbers>([-]*(\d+[\,]*)+[\.]{0,1}\d*[eEdD]{0,1}[-+]*\d*[i]{0,1})|([-]*(\d+[\,]*)*[\.]{1,1}\d+[eEdD]{0,1}[-+]*\d*[i]{0,1}))(?<suffix>.*)';
        try
            result = regexp(rawData{row}, regexstr, 'names');
            numbers = result.numbers;
            
            % Detected commas in non-thousand locations.
            invalidThousandsSeparator = false;
            if any(numbers==',')
                thousandsRegExp = '^\d+?(\,\d{3})*\.{0,1}\d*$';
                if isempty(regexp(numbers, thousandsRegExp, 'once'));
                    numbers = NaN;
                    invalidThousandsSeparator = true;
                end
            end
            % Convert numeric text to numbers.
            if ~invalidThousandsSeparator
                numbers = textscan(strrep(numbers, ',', ''), '%f');
                numericData(row, col) = numbers{1};
                raw{row, col} = numbers{1};
            end
        catch me
        end
    end
end
R = cellfun(@(x) ~isnumeric(x) && ~islogical(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells
xmolout = cell2mat(raw);
clearvars filename delimiter formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp me R;

% Data Structure for SPECIFIC Molecule 
positions = struct('N1',[], 'O2', [], 'O3', [], 'O4', [], 'H5', []);
numAtoms = length(fieldnames(positions));
xmolFileSize = size(xmolout);
headerLines = 2;
numIter = floor(xmolFileSize(1)/(headerLines+numAtoms));
iter = zeros(1,numIter);

for i = 1:numIter
     count = i-1;
     skpLines = numAtoms+headerLines;
     positions(i).N1 = xmolout(3+count*skpLines,2:4);
     positions(i).O2 = xmolout(4+count*skpLines,2:4);
     positions(i).O3 = xmolout(5+count*skpLines,2:4);
     positions(i).O4 = xmolout(6+count*skpLines,2:4);
     positions(i).H5 = xmolout(7+count*skpLines,2:4);

     iter(i) = xmolout(2+count*skpLines,2);
end

% Atom Distances & Angles - Experimental 
atDist_ex = [0,1.4060,1.2110,1.1990,1.8646;1.4060,0,2.2107,2.1858,0.9640;1.2110,2.2107,0,2.1936,2.1279;1.1990,2.1858,2.1936,0,2.9225;1.8646,0.9640,2.1279,2.9225,0];
%atDist_ex = [0,1.2110,1.1990,1.4060,1.8646;1.2110,0,2.1936,2.2107,2.1279;1.1990,2.1936,0,2.1858,2.9225;1.4060,2.2107,2.1858,0,0.9640;1.8646,2.1279,2.9225,0.964,0];
atAngle_ex = [102.15,115.083;113.850, 131.067];

% Atom Distances - Based on Initial XYZ Geometry
atDist_sim = zeros(size(atDist_ex));
atDistCell_sim = cell(1, numIter);
atoms = fieldnames(positions);

for i = 1:numIter    
  for j = 1:numAtoms     
      pii = positions(i).(atoms{j}); %initial positions
      for k = 1:numAtoms
            p = positions(i).(atoms{k});
            dist = sqrt(sum((p-pii).^2));
            atDist_sim(j,k) = dist;
            atDist_sim(k,j) = dist;
      end
  end
  atDistCell_sim{i} = atDist_sim./atDist_ex;
  atDist_sim = zeros(size(atDist_ex));
end

% Atom Distances
atAngle_sim = zeros(size(atAngle_ex));
atAngleCell_sim = cell(1, numIter);
    
for m = 1:numIter 
    % N1-O2-H5 Angle
    v1 = positions(m).(atoms{1});
    O = positions(m).(atoms{2});
    v2 = positions(m).(atoms{5});
    atAngle_sim(1,1) = findAngle(v1,v2,O);
    
    % O2-N1-O3 Angle
    v1 = positions(m).(atoms{2});
    O = positions(m).(atoms{1});
    v2 = positions(m).(atoms{3});
    atAngle_sim(1,2) = findAngle(v1,v2,O);
    
    % O2-N1-O4 Angle
    v1 = positions(m).(atoms{2});
    O = positions(m).(atoms{1});
    v2 = positions(m).(atoms{4});
    atAngle_sim(2,1) = findAngle(v1,v2,O);
    
    % O3-N1-O4 Angle
    v1 = positions(m).(atoms{3});
    O = positions(m).(atoms{1});
    v2 = positions(m).(atoms{4});
    atAngle_sim(2,2) = findAngle(v1,v2,O);
    
    % Add angles to cell array 
    conv = (180./pi);
    atAngleCell_sim{m} = (conv.*atAngle_sim)./atAngle_ex;
    atAngle_sim = zeros(size(atAngle_ex));
end

printInit = 'Initial';
printFin = 'Final';
for out = 1:numIter
    iteration = iter(out);
    distances = atDistCell_sim{out};
    distances(isnan(distances)) = [];
    angles = atAngleCell_sim{out};
    distances(isnan(angles)) = [];
    
    a = mean(distances);
    b = mean(mean(angles));
    
    if out == 1
        fprintf('%s Positions Matrix Mean: %8.6f \n%s Angles Matrix Mean: %8.6f\n',printInit,a,printInit,b);
        fprintf('Initial Temperature: %8.6f K\nInitial Potential Energy: %8.6f kcal/mol\nInitial RMSG Value: %8.6f\n',Temp(1),Epot(1),RMSG(1));
    elseif out ==2
        fprintf('%s Positions Matrix Mean: %8.6f \n%s Angles Matrix Mean: %8.6f\n',printFin,a,printFin,b);
        fprintf('Final Temperature: %8.6f K\nFinal Potential Energy: %8.6f kcal/mol\nFinal RMSG Value: %8.6f\n',Temp(end),Epot(end),RMSG(end));
        fprintf('Number of Iterations: %d\n',iter(end));
    end
    
end

