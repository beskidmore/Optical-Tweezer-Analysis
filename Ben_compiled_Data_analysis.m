%ForceData
clear all;
%% Load calibration data
Laser_power = 4.0;
Power_at_objective = 0.131;
%%stiffness is 0.9246*power at objective
Stiffness = 0.121;
Xb = 0.00024;
Time_constant = NaN;
cell_numb = 2035;
%% Otherwise use these
Originalfname = 'C:\Users\skidmore\Desktop\OT_data\2-10-2020\cell2\tether1_100pt_avg.txt';
almost_path = strsplit(Originalfname, '\tether');
path = almost_path(1:1);
path_s = strsplit(Originalfname, '\');
date = path_s(6:6);
cell_numb = path_s(7:7);
tether_numb = strsplit(string(path_s(8:8)), '_');
tether_numb = strsplit(tether_numb(1:1), 'ether');
tether_numb = tether_numb(1,2);


%ForceData.CellInfo = 'C:\Users\skidmore\Desktop\OT_data\7-31-2019\cell1';
delimiter = '\t';
startRow = 2;
formatSpec = '%f%f%f%[^\n\r]';
fileID = fopen(Originalfname,'r');
QPD = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'EmptyValue', NaN, 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
fclose(fileID);
QPD_array = [QPD{1:end-1}];
clearvars filename delimiter startRow formatSpec fileID dataArray ans;

filename2 = 'C:\Users\skidmore\Desktop\OT_data\7-1-2020\cell1\tether1_properties2.txt';
%Use this if you load properties into matlab manually. Would have to change
%pointers in the code...
%ForceData = table2struct(x3experimentpropertiesv2);

delimiter = '\t';
startRow = 2;
formatSpec = '%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%[^\n\r]';
fileID2 = fopen(filename2,'r');
dataArray = textscan(fileID2, formatSpec, 'Delimiter', delimiter, 'TextType', 'string', 'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
%ForceData.Properties = [dataArray{1:end-1}];
fdo.Properties = [dataArray{1:end-1}];
fclose(fileID2);

%load('C:\Users\skidmore\Desktop\OT_data\3-28-2019\Calibration_data_8-28-2019.mat')
%add to fdo (force data output)
fdo.Stiffness = abs(Stiffness);
%%fdo.Time_constant = abs(Time_constant);
fdo.Slope = Xb;

fdo.OriginalFname = Originalfname;
fdo.Dofexp = date;
fdo.Researcher = 'Benjamin Skidmore';
fdo.Cellnumber = cell_numb;
fdo.tether_numb = tether_numb;
fdo.ForceData = QPD_array;
fdo.PropertiesFname = filename2;
fdo.Power_at_objective = Power_at_objective;
fdo.Laser_power = Laser_power;
% filename3 = 'C:\Users\skidmore\Desktop\OT_data\7-29-2019\Compiled Calibration data.xlsx';
% 
% % Make sure these positions are right!
% stif=xlsread(filename3, 'C10:C10');
% slop=xlsread(filename3, 'D10:D10');
% ForceData.Stiffness = abs(stif);
% ForceData.Slope = abs(slop);
% 
% ForceData.Filename = 'tether1_100pt_avg';
% ForceData.ForceData =  QPD_array;
% ForceData.Properties = [dataArray{1:end-1}];
% ForceData.PropertiesFileName = 'x3_experiment_properties.txt';


clearvars  almost_path path_s fileID2 filename2 fname delimiter startRow formatSpec  dataArray ans stif slop;
clearvars  delimiter startRow formatSpec  QPD_table teather2rightbullabasiltry1 QPD;
clearvars  delimiter startRow formatSpec  dataArray ans raw col numericData rawData row regexstr result numbers invalidThousandsSeparator thousandsRegExp;

%% %% Transform OT data to nm after checking sum and normalizing it
num=1;
inv1=1;
fdo.inv1 = inv1;
period1=0.0005;
L=length(fdo(1,num).ForceData);
[QPDnmX,QPDnmY,RampEndT,RampStT] = TransformOTD_ben(fdo,num,inv1);
fdo.RampStT = RampStT;
fdo.RampEndT = RampEndT;

%QPDsignalX=ForceData(1,num).ForceData(1:L,2)./(10*ForceData(1,num).ForceData(1:L,3));
%QPDsignalY=ForceData(1,num).ForceData(1:L,1)./(10.*ForceData(1,num).ForceData(1:L,3)); % signal in volts
%QPDnmX=QPDsignalX./(inv1*ForceData(1,num).Slope); % signal in nm
%QPDnmY=QPDsignalY./(inv1*ForceData(1,num).Slope); % signal in nm
%% Plot data
close all;
%hold on;
Stime=0;
% For force multiply by fdo.Stiffness
%PLOTXnm_Ynm_vs_time(QPDnmX,QPDnmY,period1,Stime);
PLOTXnm_Ynm_vs_time(QPDnmX*fdo.Stiffness,QPDnmY*fdo.Stiffness,period1, Stime);

%[Theta,Rho] = cart2pol(QPDnmX,QPDnmY);

%PLOTXnm_Ynm_vs_time(QPDnmX,QPDnmY,period1,Stime);
%plot(rho*fdo.Stiffness)
%hold on;
%plot(QPDnmXc*ForceData.Stiffness)
%% Correct for drift
prompt = 'Enter tube break time in seconds if no break enter NaN  ';
TubeBreak=input(prompt);
Z=isnan(TubeBreak);
if(Z==1)
  ND=0;
  QPDnmXc= QPDnmX;
  QPDnmYc= QPDnmY;
  [Theta,Rho] = cart2pol(QPDnmXc(:,1),QPDnmYc(:,1));
  %clear QPDnmX QPDnmY;
else
 ND=1;
 numbs=12000;    
[QPDnmXc,QPDnmYc, Theta, Rho] = Determine_drift(TubeBreak,QPDnmX,QPDnmY,period1,numbs,ND);
%clear QPDnmX QPDnmY;
end
fdo.rho = Rho;
fdo.theta = Theta;
%% Added for later variables
fdo.QPDnmXc = QPDnmXc;
fdo.QPDnmYc = QPDnmYc;
%fdo.RampStT = RampStT;
%fdo.RampEndT = RampEndT;
%fdo.Stiffness = ForceData.Stiffness;
%Control_data=fdo.QPDnmYc;

%anumb=1;

%save to path directory calling it 'Cell#_'tether#_fdo.mat'
cell_number = num2str(cell_numb)

save(strcat('C:\Users\skidmore\Desktop\OT_data\Saved-data-params\','OHC','_',cell_number, '_', tether_numb,'_','fdo.mat'), 'fdo');
%% Plot data after correcting for drift
close all;
Stime=0;
period1=0.0005;
%PLOTXnm_Ynm_vs_time(QPDnmXc*ForceData.Stiffness,QPDnmYc*ForceData.Stiffness,period1,Stime);
%PLOTXnm_Ynm_vs_time(QPDnmXc,QPDnmYc,period1,Stime);
%PLOTXnm_Ynm_vs_time(QPDnmXc,rho,period1,Stime);

%%NOISE FILTER (Smoothing, NOT FOR SCIENTIFIC MEASUREMENTS)
%For force
%X
%smoothd = smooth(QPDnmXc, period1);
%PLOTXnm_Ynm_vs_time(smoothd*ForceData.Stiffness,
%QPDnmXc*ForceData.Stiffness, period1, Stime);
%Y
smoothd = smooth(fdo.QPDnmYc, period1);
PLOTXnm_Ynm_vs_time(smoothd*fdo.Stiffness, fdo.QPDnmYc*fdo.Stiffness, period1, Stime-fdo.RampStT);
%PLOTXnm_Ynm_vs_time(smoothd, QPDnmYc, period1, Stime)

%For displacement
%X
%smoothd = smooth(QPDnmXc, period1);
%PLOTXnm_Ynm_vs_time(smoothd, QPDnmXc, period1, Stime);
%Y
%smoothd2= smooth(QPDnmYc, period1);
%PLOTXnm_Ynm_vs_time(smoothd2, QPDnmYc, period1, Stime);
%% Select points on plateau for averaging %% 
prompt = 'Enter plateau start X coord  ';
plat_xcoord=input(prompt);
prompt = 'Enter plateau end X coord  ';
plat_x2coord = input(prompt);

plateau_mean_force = mean(QPDnmX((plat_xcoord/.0005):(plat_x2coord/.0005)))*fdo.Stiffness

 %% %% Calculate sectional or jump-slope slope for four times averaging 100 to 2000 points, 

%%%%% FOR SIGNAL IN Y
%eventname=fdo.QPDnmYc(1:1:length(fdo.QPDnmYc));
%%%%% FOR SIGNAL IN X
eventname=fdo.QPDnmXc(1:1:length(fdo.QPDnmXc));

mbslope = zeros(length(eventname)/100,39);
initialtime=0;
 for k=1:1:39
     %%%%% MUST SET THIS!
     delta=100:50:2000;
     delta=delta';
     delta;    
for i=1:1:(length(eventname))/(delta(k))
tb= (i*delta(k)-(delta(k)-1):1:delta(k)*i)./delta(k)+initialtime;
tb=tb';
i;
   p=polyfit(tb*period1*delta(k),eventname(i*delta(k)-(delta(k)-1):1:delta(k)*i),1);
mbslope(i,k)=p(1);
end
 end
fdo.mbslope = mbslope;
fdo.jump_slope_p = p(1);
%% plot sectional slope to visualize regions and repeat for all rupture events usually less than 10
 % Make the average number as small as possible
 
hold on
close all;
 
i=menu('Choose rupture number','1','2','3','4','5','6','7','8','9','10');
figure2 = figure('NumberTitle','On','Name','HN31jumpslope','Color',[1 1 1]);
axes('Parent',figure2,'FontSize',16,'FontName','Arial');
h=figure(1);
 
hold('all');
grid('on');
% xlabel('time, s','FontSize',18,'FontName','Arial');
% ylabel('nm/s', 'FontSize',18,'FontName','Arial');
dcm_obj = datacursormode(figure2);
set(dcm_obj,'DisplayStyle','datatip',...
'SnapToDataVertex','off','Enable','on')

RampStT=fdo.RampStT;
mx=39;
nm=5; %this is one U save
%make the second eventname negative to reverse positive or negative
%plot((1:length(eventname))*0.0005-(fdo.RampStT), eventname*fdo.Stiffness,'color','b')
plot((1:length(eventname))*0.0005, eventname*fdo.Stiffness,'color','b')
hold on
PLOTXnm_Ynm_vs_time(smoothd*fdo.Stiffness, fdo.QPDnmXc*fdo.Stiffness, period1, Stime);
hold on
  plot((1:1:size(fdo.mbslope(:,nm)))*(((nm-1)*50+100)*period1),fdo.mbslope(1:1:size(mbslope(:,nm)),nm)*fdo.Stiffness,'color',[0.85 0.33 0],'LineWidth', 1,'marker','o','markersize',6,'MarkerEdgeColor','k','MarkerFaceColor','r');
  %plot((1:1:size(mbslope(:,mx)))*(((mx-1)*50+100)*period1),mbslope(1:1:size(mbslope(:,mx)),mx)*fdo.Stiffness,'color',[0.3 0.75 .75],'LineWidth', 1,'marker','o','markersize',6,'MarkerEdgeColor','k','MarkerFaceColor','g');
xlim ([0 60])
ylim ([-40 100])
%
disp('Click on a line to display a data tip, then press Return.')
pause                            % Wait while the user does this.

Cursorposition = getCursorInfo(dcm_obj);
%
Pstartp(i)=Cursorposition(1,2).DataIndex ;
Pstartt(i)=Cursorposition(1,2).Position(1);

Pstopp(i)=Cursorposition(1,1).DataIndex;
%stopt(i)=Cursorposition(1,1).Position(1)+((k+1)*50/2000);
Pstopt(i)=Cursorposition(1,1).Position(1);

disp([ num2str(Pstartp(i)) '  ' num2str(Pstopp(i))  ])
disp([ num2str(Pstartt(i)) ' ' num2str(Pstopt(i))  ])


%% determine force, slope and time
%This just holds the sloping region's points
MBNUM=nm;
delta=((MBNUM-1)*50+100);
if Pstartp == Pstopp
    Pstopp + .1;
    Pstopp = ans;
end
PSloperf=[];
for j=1:1:length(find(Pstartp))
    PSloper=eventname((Pstartp(j))*delta:(Pstopp(j))*delta); %range of force
    PSloperf{j}=PSloper;
end
%% %%
disp(PSloperf)
PFt=zeros(length(PSloperf),2);
disp(PFt)
for j=1:length(PSloperf)
    disp(j)
    Ls=length(PSloperf{j});
    disp(Ls)
    PFt(j,1)=mean(PSloperf{j}(1:100)); %take first 100 points measure mean displacement
    PFt(j,2)=mean(PSloperf{j}(Ls-100:Ls)); %take last 100 points measure mean displacement
end

%timespan of the region between the selected points
PdT=(Pstopt-Pstartt)'; % delta time
%force of the region between the selected points
PdF=(PFt(:,2)- PFt(:,1))*fdo.Stiffness; %delta force

%This is the force before rupture. NOT the rupture force (difference before
%and after rupture)
PdF_2=(PFt(:,2))*fdo.Stiffness; %rupture force begining and end points
meanlr=[];

% get the slope of the sine between selected points??
for j=1:length(PSloperf)
    L=length(PSloperf{j});
    time1=(1:L).*period1;
    time1=time1';
    [p,S]=polyfit(time1,PSloperf{j}*fdo.Stiffness,1);
    meanlr(j)=p(1);
    
    FIT=polyval(p,time1);
    plot (PSloperf{j}), hold on, plot(FIT)
end
fdo.FIT = FIT; 
% calculate compression force before pull
FSC=mean(fdo.QPDnmYc(round(fdo.RampStT/0.0005)-2000:1:round(fdo.RampStT/0.0005)))*fdo.Stiffness;

%%%%%%%%%%%%%%%%%%%%%%%%%%delay?? like machine delay? I dont think this is
%%%%%%%%%%%%%%%%%%%%%%%%%%right
fdo.dTpull = PdT;
fdo.dFPull = PdF;
fdo.FmaxPull = PdF_2;
delay=Pstartt;
fdo.delay = delay;
fdo.MCompF_b_Pull = FSC;
fdo.L_rate = meanlr;
prompt = 'Enter number of tubes, if no tubes enter NaN  ';
fdo.Number_Tubes=input(prompt);
%fdo.StartTPull = Pstartt+fdo.RampStT;
fdo.StartTPull = Pstartt
%fdo.StopTPull = Pstopt+fdo.RampStT;
fdo.StopTPull = Pstopt
fdo.Slope_Number = i;

%%fdo.Number_Tubes=3; % This may require to be examined every time to ensure
%%what is Type? Is it always 1?
%fdo.Type=1;
%it is correc


%% Identify pleateau's 
close all
i=menu('Choose plateau number','1','2','3','4','5');
figure2 = figure('NumberTitle','On','Name','HN31jumpslope','Color',[1 1 1]);
axes('Parent',figure2,'FontSize',16,'FontName','Arial');
h=figure(1);
hold('all');
grid('on');
% xlabel('time, s','FontSize',18,'FontName','Arial');
% ylabel('nm/s', 'FontSize',18,'FontName','Arial');
dcm_obj = datacursormode(figure2);
set(dcm_obj,'DisplayStyle','datatip',...
'SnapToDataVertex','off','Enable','on')

RampStT=fdo.RampStT;
%mx=2;
nm=4;%fdo_p1.mblopeusedrupt; %this is one U save
plot((1:length(eventname))*0.0005, eventname*fdo.Stiffness*fdo.inv1,'color','b')
hold on
  plot((1:1:size(mbslope(:,nm)))*(((nm-1)*50+100)*period1),mbslope(1:1:size(mbslope(:,nm)),nm)*fdo.Stiffness*fdo.inv1,'color',[0.85 0.33 0],'LineWidth', 1,'marker','o','markersize',6,'MarkerEdgeColor','k','MarkerFaceColor','r');
 % plot((1:1:size(mbslope(:,mx)))*(((mx-1)*50+100)*period1)-(RampStT),mbslope(1:1:size(mbslope(:,mx)),mx)*fdo.Stiffness,'color',[0.3 0.75 .75],'LineWidth', 1,'marker','o','markersize',6,'MarkerEdgeColor','k','MarkerFaceColor','g');
%xlim ([(fdo_p1.StopTPull(1,1)-fdo.RampStT),20])
xlim ([0,58])

ylim ([-40 100])
%
disp('Click on a line to display a data tip, then press Return.')
pause                            % Wait while the user does this.

Cursorposition = getCursorInfo(dcm_obj);
%
Pstartp(i)=Cursorposition(1,2).DataIndex ;
Pstartt(i)=Cursorposition(1,2).Position(1);

Pstopp(i)=Cursorposition(1,1).DataIndex;
%stopt(i)=Cursorposition(1,1).Position(1)+((k+1)*50/2000);
Pstopt(i)=Cursorposition(1,1).Position(1);

disp([ num2str(Pstartp(i)) '  ' num2str(Pstopp(i))  ])
disp([ num2str(Pstartt(i)) ' ' num2str(Pstopt(i))  ])
MBNUM=nm;
delta=((MBNUM-1)*50+100);

PSloperf=[];
for j=1:1:length(find (Pstartp))
    PSloper=eventname((Pstartp(j))*delta:(Pstopp(j))*delta); %range of force
    PSloperf{j}=PSloper;
end
%% create plateau variable
plateau(i,1)=i;
plateau(i,2)=mean(PSloper(:,1))*fdo.Stiffness*fdo.inv1;
plateau(i,3)=std(PSloper(:,1))*fdo.Stiffness*fdo.inv1;
plateau(i,4)=Pstartt(i);
%plateau(1,4)=Pstartt(i)+fdo.RampStT;
plateau(i,5)=Pstopt(i);
%plateau(1,5)=Pstopt(i)+fdo.RampStT;
[fdo.plateau]=deal(plateau);
% [fdo.FSC]=deal(FSC);
%% find time constant for relaxation
clear frelax t;
options = optimoptions('lsqcurvefit','MaxFunctionEvaluations',90000,'MaxIterations',90000,'TolFun', 1E-7,'Display','final','FunctionTolerance', 1E-15,'StepTolerance',1E-8,'FiniteDifferenceType','forward','OptimalityTolerance',1E-20);
%this t has from the end of ramping up to the end of plateau. This takes
%StopTPull which is a selected point from rupture events.Plateaus are
%before these ruptures tho??
t=fdo.StopTPull(fdo.plateau(i,1)):0.0005:(fdo.plateau(i,5));
%t=59.7:0.0005:61.03;
t=t';
%%%%frelax=eventname(round(fdo.plateau(i,1)/0.0005):1:round(fdo.plateau(i,5)/0.0005))*Stiffness; 
frelax=eventname(round(fdo.StopTPull(fdo.plateau(i,1))/0.0005):1:round(fdo.plateau(i,5)/0.0005))*fdo.Stiffness; 
%frelax=eventname(round(59.7/0.0005):1:round(61.03/0.0005))*Stiffness; 

%range of force
% Is this preset???????????????????????
 to=0.5;
 lb=0.2;
 ub=10;

 %MUST INDICATE WHICH PLATEAU WE ARE LOOKING AT! : fdo.plateau(1,1) OR fdo.plateau(1,2), fdo.FmaxPull(2)
fun = @(to,t) (fdo.plateau(i,2))-((fdo.plateau(i,2))-(fdo.FmaxPull(i))).*exp(-(t-(fdo.StopTPull(fdo.plateau(i,1))))/to);
%fun = fdo_p1.plateau(1,2)-(fdo_p1.plateau(1,2)-(fdo.FmaxPULL(1))).*exp((-(t-fdo_p1.StopTPull(1)))/to)
%fun = @(to,t) 88-(88-(fdo.FmaxPull(2))).*exp((-(t-59.7))/to);

%to = lsqcurvefit(fun,to,t,frelax(1:1:length(t),1),lb,ub,options);
[to,resnorm,residual,exitflag,output] = lsqcurvefit(fun,to,t,frelax(1:1:length(t),1),lb,ub,options);
%% plot
close all

plot(t,-frelax(1:1:size(t),1),'-k',t,fun(to,t),'-b');

hold on;
%% %% Determine delay with cumslope;
Stime_cslope = fdo.RampStT-3;
Etime_cslope = fdo.RampStT+2;
%newFolder=strcat('C:\Users\bfarrell\Documents\M files\OT analysis');
%genpath('newfolder');
%cd(newFolder);
[cslope] = cumslope(fdo.QPDnmXc,Stime_cslope,Etime_cslope,period1,initialtime);
[dcm_obj,StartTrise]= plot_cslope(cslope, period1,Stime_cslope,Etime_cslope);
Delay_Actual=StartTrise.Position(1,1)-fdo.RampStT;
TStartrise=StartTrise.Position(1,1);

fdo.cslope = cslope
fdo.Delay_Actual = Delay_Actual;
fdo.Rise_Actual = TStartrise;

save(strcat('C:\Users\skidmore\Desktop\OT_data\Saved-data-params\','OHC','_',cell_number, '_', tether_numb,'_','fdo.mat'), 'fdo');


%% %% Get Rayleigh data this is needed if not originally calculated

%why use these numbers???
start=4;
start2=6;
start3=2;
bin=400;
j=1;
%k(1,j)=numb;

[B2,h2,MR] =Calculate_Rayleigh_Scale_factor(start,start2,start3,fdo.rho,period1,k,fdo.Slope,fdo.Stiffness,bin,j);
%%Rayleigh scale factor 1???????
%fdo.Rayleigh_B2 = B2;
%%Rayleigh scale factor 2???????
%fdo.Rayleigh_h2 = h2;

fdo.Rayleigh_Scale_Factor = MR(1,5:6);
%% %%
%plot data
figure1 = figure('NumberTitle','off','Color',[1 1 1]);
ax1=axes('Parent',figure1,...
'FontSize',16,'FontName','Times New Roman','Xticklabel',{'-150','-100','-50','0','50','100','150'},...
'Xtick',[ -150 -100 -50 0 50 100 150 ],'Ylim',([0 0.05]),'Xlim',([-19 550]),'XColor', 'k','TickDir', 'out');
hold(ax1,'on');
histogram(B2(:,1),200,'normalization', 'probability','Facecolor',[0.8 0.8 0.8],'Edgecolor',[0.8 0.8 0.8]);
hold (ax1,'on')
plot(ax1,0:1:400,h2*1,'LineStyle', '--','LineWidth',2,'color','k');
MRayleigh(1,1:1:6)=MR(j,1:1:6);
fdo.MRayleigh = MRayleigh;

%% Save fdo again now that Rayleigh, cumslope, FSC, etc. are added.
cell_number = num2str(fdo.Cellnumber)


save(strcat('C:\Users\skidmore\Desktop\OT_data\Saved-data-params\','OHC','_',cell_number, '_', fdo.tether_numb,'_','fdo.mat'), 'fdo');




















%% Select points at top and bottom of event to calculate change in force
hold on
close all;
 
%i=menu('Choose rupture number','1','2','3','4','5','6','7','8','9','10');
figure3 = figure('NumberTitle','On','Name','HN31jumpslope','Color',[1 1 1]);
axes('Parent',figure3,'FontSize',16,'FontName','Arial');
h=figure(1);
 
hold('all');
grid('on');
% xlabel('time, s','FontSize',18,'FontName','Arial');
% ylabel('nm/s', 'FontSize',18,'FontName','Arial');
dcm_obj = datacursormode(figure3);
set(dcm_obj,'DisplayStyle','datatip',...
'SnapToDataVertex','off','Enable','on')

%PLOTXnm_Ynm_vs_time(smoothd, QPDnmXc, period1, 0)
plot((1:length(eventname))*0.0005, eventname*fdo.Stiffness,'color','b')
hold on
%PLOTXnm_Ynm_vs_time(smoothd*ForceData.Stiffness, QPDnmYc*ForceData.Stiffness, period1, 0)
%PLOTXnm_Ynm_vs_time(smoothd, eventname, period1, 0)
%If needed use the following to identify events
nm =9
mx =10
hold on
  plot((1:1:size(mbslope(:,nm)))*(((nm-1)*50+100)*period1),mbslope(1:1:size(mbslope(:,nm)),nm)*fdo.Stiffness,'color',[0.85 0.33 0],'LineWidth', 1,'marker','o','markersize',6,'MarkerEdgeColor','k','MarkerFaceColor','r');
  plot((1:1:size(mbslope(:,mx)))*(((mx-1)*50+100)*period1),mbslope(1:1:size(mbslope(:,mx)),mx)*fdo.Stiffness,'color',[0.3 0.75 .75],'LineWidth', 1,'marker','o','markersize',6,'MarkerEdgeColor','k','MarkerFaceColor','g');

xlim ([0 60])
ylim ([-20 50])

disp('Click two points on the "top" of the force, then press Return.')
pause                            % Wait while the user does this.

Cursorposition = getCursorInfo(dcm_obj);

top1(i)=Cursorposition(1,2).DataIndex ;
top1_time(i)=Cursorposition(1,2).Position(1);

top2(i)=Cursorposition(1,1).DataIndex;
top2_time(i)=Cursorposition(1,1).Position(1);
disp(top1(i))
top_mean = mean(QPDnmYc(top1(i):1:top2(i)));

disp('Click two points on the "bottom" of the force, then press Return.')
pause                            % Wait while the user does this.

Cursorposition = getCursorInfo(dcm_obj);

bot1(i)=Cursorposition(1,2).DataIndex ;
bot1_time(i)=Cursorposition(1,2).Position(1);

bot2(i)=Cursorposition(1,1).DataIndex;
bot2_time(i)=Cursorposition(1,1).Position(1);


bot_mean = mean(QPDnmYc(bot1(i):1:bot2(i)));

force_change = (bot_mean-top_mean)*fdo.Stiffness

%Write force_change to fdo
fdo.force_change = force_change
%save force_change to fdo
save(strcat(path,cell_numb, '_', tether_numb,'_','fdo.mat'), 'fdo');

%%
%%DONT USE NO NEED TO USE
figure2 = figure('NumberTitle','On','Name','HN31jumpslope','Color',[1 1 1]);
axes('Parent',figure2,'FontSize',16,'FontName','Arial');
h=figure(1);
hold('all');
grid('on');
% xlabel('time, s','FontSize',18,'FontName','Arial');
% ylabel('nm/s', 'FontSize',18,'FontName','Arial');
dcm_obj = datacursormode(figure2);
set(dcm_obj,'DisplayStyle','datatip',...
'SnapToDataVertex','off','Enable','on')

RampStT=fdo.RampStT;
%mx=2;
nm=4;%fdo_p1.mblopeusedrupt; %this is one U save
plot((1:length(eventname))*0.0005, eventname*fdo.Stiffness,'color','b')
hold on
  plot((1:1:size(mbslope(:,nm)))*(((nm-1)*50+100)*period1),mbslope(1:1:size(mbslope(:,nm)),nm)*fdo.Stiffness,'color',[0.85 0.33 0],'LineWidth', 1,'marker','o','markersize',6,'MarkerEdgeColor','k','MarkerFaceColor','r');
 % plot((1:1:size(mbslope(:,mx)))*(((mx-1)*50+100)*period1)-(RampStT),mbslope(1:1:size(mbslope(:,mx)),mx)*fdo.Stiffness,'color',[0.3 0.75 .75],'LineWidth', 1,'marker','o','markersize',6,'MarkerEdgeColor','k','MarkerFaceColor','g');
%xlim ([(fdo_p1.StopTPull(1,1)-fdo.RampStT),20])
xlim ([30,80])

ylim ([-40 100])
%
disp('Click on a line to display a data tip, then press Return.')
pause                            % Wait while the user does this.

Cursorposition = getCursorInfo(dcm_obj);
%
Pstartp(i)=Cursorposition(1,2).DataIndex ;
Pstartt(i)=Cursorposition(1,2).Position(1);

Pstopp(i)=Cursorposition(1,1).DataIndex;
%stopt(i)=Cursorposition(1,1).Position(1)+((k+1)*50/2000);
Pstopt(i)=Cursorposition(1,1).Position(1);

disp([ num2str(Pstartp(i)) '  ' num2str(Pstopp(i))  ])
disp([ num2str(Pstartt(i)) ' ' num2str(Pstopt(i))  ])
MBNUM=nm;
delta=((MBNUM-1)*50+100);

PSloperf=[];
for j=1:1:length(find (Pstartp))
    PSloper=eventname((Pstartp(j))*delta:(Pstopp(j))*delta); %range of force
    PSloperf{j}=PSloper;
end
%create plateau variable
p_relax(i,1)=i;
p_relax(i,2)=mean(PSloper(:,1))*fdo.Stiffness;
p_relax(i,3)=std(PSloper(:,1))*fdo.Stiffness;
p_relax(i,4)=Pstartt(i);
%plateau(1,4)=Pstartt(i)+fdo.RampStT;
p_relax(i,5)=Pstopt(i);
%plateau(1,5)=Pstopt(i)+fdo.RampStT;
[fdo.p_relax]=deal(p_relax);
% [fdo.FSC]=deal(FSC);

