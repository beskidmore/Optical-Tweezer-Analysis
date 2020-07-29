%ForceData

clear all;
%% Otherwise use these
filename = 'C:\Users\skidmore\Desktop\OT_data\3-28-2018\Lbulla\apical\cell4\tether3_100pt_avg.txt';
ForceData.CellInfo = 'C:\Users\skidmore\Desktop\OT_data\3-28-2018\Lbulla\apical\cell4';
delimiter = '\t';
startRow = 2;
formatSpec = '%f%f%f%[^\n\r]';
fileID = fopen(filename,'r');
QPD = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
QPD_array = [QPD{1:end-1}];
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

filename = 'C:\Users\skidmore\Desktop\OT_data\3-28-2018\Lbulla\apical\cell4\tether1_properties2.txt';
%Use this if you load properties into matlab manually. Would have to change
%pointers in the code...
%ForceData = table2struct(x3experimentpropertiesv2);

delimiter = '\t';
startRow = 2;
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID2 = fopen(filename,'r');
dataArray = textscan(fileID2, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
ForceData.Properties = [dataArray{1:end-1}];
fclose(fileID2);

ForceData.Stiffness = 0.0909;
ForceData.Slope = 0.000220623261279178;

ForceData.Filename = 'tether1_100pt_avg';
ForceData.QPDdata =  QPD_array;
ForceData.Properties = [dataArray{1:end-1}];
%ForceData.PropertiesFileName = 'x3_experiment_properties.txt';


clearvars filename delimiter startRow formatSpec fileID dataArray ans;
clearvars filename delimiter startRow formatSpec fileID QPD_table teather2rightbullabasiltry1 QPD;
clearvars filename delimiter startRow formatSpec fileID dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp;



%clear all;
%Datafile = 'D:\BCM_post_doc\OT_experiments\3-14-2019\R-bulla-cell3\x3_100pt_avg.txt'
%fid = fopen(Datafile)
%dfRead_text = textscan(fid, '%s', 3, 'Delimiter', '\t');
%dfRead_data = textscan(fid,'%f32 %f32 %f32');
%fclose(fid);


%Datafile2 = 'D:\BCM_post_doc\OT_experiments\3-14-2019\R-bulla-cell3\x3_experiment_properties.txt'
%fid2 = fopen(Datafile2)
%delimiterIn ='\t'
%headerlinesIn = 1
%Read2 = importdata(Datafile2,delimiterIn,headerlinesIn);
%dfRead2_text = textscan(fid2, '%s', 'Delimiter', '\t', linenum-1);
%formatSpec2 = '%s %f';
%sizeRead2 = [2 Inf];
%Read2 = fscanf(fid2, formatSpec2, sizeRead2)
%dfRead2_text = textscan(fid2,'%s%f','HeaderLines',2,'CollectOutput',1)
%dfRead2_text = dfRead2_text{:};

%fclose(fid2);

%fid = fopen('mydata.txt');
%C = textscan(fid, '%s %d8 %f32');
%fclose(fid);
%f = {'Title','Time','Dist'};
%s = cell2struct(C,f,2);
%C = textscan(fid, '%s%d8%*s%f32');




