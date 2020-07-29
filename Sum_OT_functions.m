%% Load metadata and create fdo structure
clear;
close all;
k=3; %this is number of cell 
a=strcat('cellc',num2str(k));
[~,data,raw]  =xlsread('C:\Users\bfarrell\Documents\Data\HN31\Control\Metadata_HN31.xls', a, 'b1:c27');
metanames=(raw(1:1:27,1));
fdo=cell2struct(raw(1:1:27,2),metanames,1);
newFolder=strcat('C:\Users\bfarrell\Documents\Data\HN31\Control\','cellc',num2str((k)));
genpath('newfolder');
cd(newFolder);
load(fdo.FnOt)
%% Transform OT data to nm after checking sum and normalizing it
num=1;
inv1=1;
period1=0.0005;
L=length(ForceData(1,num).QPDdata);
%newFolder=strcat('D:\BCM_post_doc\OT_experiments\3-14-2019\R-bulla-cell3');
%genpath('newfolder');
%cd(newFolder);
[QPDnmX,QPDnmY,RampEndT,RampStT] = TransformOTD(ForceData,num,inv1);
%% Plot data
close all;
Stime=0;
PLOTXnm_Ynm_vs_time(QPDnmX,QPDnmY,period1,Stime);
%[theta,rho] = cart2pol(QPDnmX,QPDnmY);
%PLOTXnm_Ynm_vs_time(QPDnmX,rho,period1,Stime);
%% Correct for drift
prompt = 'Enter tube break time in seconds if no break enter NaN  ';
TubeBreak=input(prompt);
Z=isnan(TubeBreak);
if(Z==1)
  ND=0;
  QPDnmXc= QPDnmX;
  QPDnmYc= QPDnmY;
  [Theta,Rho] = cart2pol(QPDnmXc(:,1),QPDnmYc(:,1));
  clear QPDnmX QPDnmY;
else
 ND=1;
 numbs=12000;    
[QPDnmXc,QPDnmYc, Theta, Rho] = Determine_drift(TubeBreak,QPDnmX,QPDnmY,period1,numbs,ND);
clear QPDnmX QPDnmY;
end
%% Plot data after correcting for drift
close all;
Stime=0;
PLOTXnm_Ynm_vs_time(QPDnmXc,QPDnmYc,period1,Stime);
%[theta,rho] = cart2pol(QPDnmXc,QPDnmYc);
%PLOTXnm_Ynm_vs_time(QPDnmXc,rho,period1,Stime);
%% Plot angle versus time for first X seconds to determine where angle starts to show less scatter indicates intial force
A1=1; A2=20000;DA=20000;
plotangle_vs_time(Theta,A1,A2,DA,period1)
%% Calculate cumslope;

Stime = 0;

Etime= 60;
initialtime=0;
[cslope] = cumslope(QPDnmXc,Stime,Etime,period1,initialtime);
%% Determine time when force is zero
Stime=10;
Etime=60;
[dcm_obj,zeroforcetime]= plot_cslope(cslope, period1,Stime,Etime);
zeroTime=zeroforcetime.Position(1,1);
%% Determine whether there is a delay
Stime=RampStT-10;
Etime=RampStT+5;

initialtime=0;
[cslope] = cumslope(QPDnmXc,Stime,Etime,period1,initialtime);
%% Determine time when force rises and the delay
Stime=RampStT-10;
Etime=RampStT+5;
plot_cslope_preview(cslope, period1,Stime,Etime)
prompt = 'Stime = ';
Stime = input(prompt);
prompt = 'Etime = ';
Etime = input(prompt);
[cslope] = cumslope(QPDnmXc,Stime,Etime,period1,initialtime);
[dcm_obj,StartTrise]= plot_cslope(cslope, period1,Stime,Etime);
Delay=StartTrise.Position(1,1)-RampStT;
Startrise=StartTrise.Position(1,1);
%% Calculate jump slope
initialtime=0;
D_init=100; %initial number of points
D=50; % change in number of points
D_final=2000; %final number of points to average
period1=0.0005;% time per point in secs
[mbslope] = Calculate_jslope(QPDnmXc,initialtime,D_init,D,D_final, period1);
%% Plot jump slope to see where the range of rupture lies 
D_init=100;
D= 50;
Stime=RampStT-2;
Etime=RampEndT-10;
ks=3:1:5;
period1=0.0005;
plot_jslope(mbslope,period1,D_init,D,Stime,Etime,ks);
%% Determine the range calculate loading rate and dT and dD
D_init=100;
D= 50;
numb=100;
 Stime=RampStT-2;
 Etime=RampEndT;
k=2;

kdeltar=k;
[Rposition]=Det_range(mbslope,period1,D_init,D,Stime,Etime,k);
i=1;
StartP(i)=Rposition(1,2).DataIndex ;
StartT(i)=Rposition(1,2).Position(1);

StopP(i)=Rposition(1,1).DataIndex;
StopT(i)=Rposition(1,1).Position(1);

disp([ num2str(StartP(i)) '  ' num2str(StopP(i))  ])
disp([ num2str(StartT(i)) ' ' num2str(StopT(i))  ])

[ Sloperf ] = determine_disp_of_range(QPDnmXc,D_init,D,k,StartP,StopP);

[ meanlr ] = mean_load_rate(Sloperf, period1);
[Xt,mTheta,DeltaT] = determine_means(Sloperf,Theta,Rposition,StartP,StopP,D_init,D,k,numb);
%% Determine mean angle and plot during first rupture do this to make sure the force is being foccused
D_init=10; %initial number of points
D=10; % change in number of points
D_final=200; %final number of points to average
 Stime=RampStT-1;
 Etime=RampStT+5;
initialtime=0;
[mangle] = cal_mean_angle_of_event(Theta,Stime,Etime,initialtime,period1,D,D_init,D_final);
k=1;
plot_mean_angle(mangle,D,D_init,period1,Stime,Etime,k);

%% Calculate jump slope in Y
initialtime=0;
D_init=100; %initial number of points
D=50; % change in number of points
D_final=2000; %final number of points to average
period1=0.0005;% time per point in secs
[mbslopeY] = Calculate_jslope(QPDnmYc,initialtime,D_init,D,D_final, period1);
%% Plot jump slope to see where the range of rupture lies 
D_init=100;
D= 50;

 Stime=RampStT-2;
 Etime=RampEndT;
ks=5:1:7;
period1=0.0005;
plot_jslope(mbslopeY,period1,D_init,D,Stime,Etime,ks);
%% Y component significant ?
prompt = 'Y component significant type Yes or No  ';
YCS = input(prompt);
%%
D_init=100;
D= 50;
numb=100;
 Stime=RampStT-2;
 Etime=RampEndT-5;
k=7;
kdeltar=k;
[Rposition]=Det_range(mbslopeY,period1,D_init,D,Stime,Etime,k);
i=1;
StartPY(i)=Rposition(1,2).DataIndex ;
StartTY(i)=Rposition(1,2).Position(1);

StopPY(i)=Rposition(1,1).DataIndex;
StopTY(i)=Rposition(1,1).Position(1);

disp([ num2str(StartPY(i)) '  ' num2str(StopPY(i))  ])
disp([ num2str(StartTY(i)) ' ' num2str(StopTY(i))  ])

[ Sloperf ] = determine_disp_of_range(QPDnmYc,D_init,D,k,StartPY,StopPY);

[ meanlry ] = mean_load_rate(Sloperf, period1);
[Yt,~,DeltaTY] = determine_means(Sloperf,Theta,Rposition,StartPY,StopPY,D_init,D,k,numb);
%%
%% Determine whether there is a delay
Stime=RampStT-10;
Etime=RampStT+5;
initialtime=0;
[cslope] = cumslope(QPDnmYc,Stime,Etime,period1,initialtime);
%% Determine time when force rises and the delay
Stime=RampStT-10;
Etime=RampStT+5;
plot_cslope_preview(cslope, period1,Stime,Etime)
prompt = 'Stime = ';
Stime = input(prompt);
prompt = 'Etime = ';
Etime = input(prompt);
[cslope] = cumslope(QPDnmYc,Stime,Etime,period1,initialtime);
[dcm_obj,StartTriseY]= plot_cslope(cslope, period1,Stime,Etime);
DelayY=StartTriseY.Position(1,1)-RampStT;
StartriseY=StartTriseY.Position(1,1);

%%
meanlry=zeros(1,1);
StartTY=zeros(1,1);
StopTY=zeros(1,1);
StartriseY=zeros(1,1);
Yt=zeros(1,4);
DelayY=zeros(1,1);
DeltaTY=zeros(1,1);
%% Determine whether over or undershoot and number of tubes forming
[Overshoot, FTAFR, Numberform ] = plot_2_det_overshoot(QPDnmXc,StopT,RampEndT,period1);

%% If FTAFR=Yes then do the follwing to end 
% Determine plateau 
SP=StopT*1/period1;
EP=RampEndT*1/period1;
Stime=StopT;
PLOTXnm_Ynm_vs_time(QPDnmXc(SP:1:EP,1),QPDnmYc(SP:1:EP,1),period1,Stime);
%% Any active component
prompt = 'Active component during plateau please type Yes or No';
ActComp = input(prompt);
%% Plot jump slope to see where the range of plateua lies
D_init=100;
D= 50;
Stime=StopT;
Etime=RampEndT;
%ka=1:1:39;
ks=7:1:9; %pass the slopes of choice
period1=0.0005;
plot_jslope(mbslope,period1,D_init,D,Stime,Etime,ks);
%% Determine the range of the event dT and mean disp
D_init=100;
D= 50;
Stime=StopT;
Etime=RampEndT;
k=13;
kdeltap=k;
[Plateau]=Det_range(mbslope,period1,D_init,D,Stime,Etime,k);

StartPosPlat(i)=Plateau(1,2).DataIndex ;
StartPlatT(i)=Plateau(1,2).Position(1);

StopPosPlat(i)=Plateau(1,1).DataIndex;
StopPlatT(i)=Plateau(1,1).Position(1);

disp([ num2str(StartPosPlat(i)) '  ' num2str(StopPosPlat(i))])
disp([ num2str(StartPlatT(i)) ' ' num2str(StopPlatT(i))  ])
StartP=StartPlatT/period1;
StopP=StopPlatT/period1;
[Sloperf] = determine_disp_of_range(QPDnmXc,D_init,D,k,StartPosPlat,StopPosPlat);
[DPlat,mThetaPlat,DeltaTPlat] = determine_means(Sloperf,Theta,Plateau,StartPosPlat,StopPosPlat,D_init,D,k,numb);
%% Plot section where tube is forming and see whether it fits to exponential
Stiffness=ForceData.Stiffness;
StopT=61.2;
StartPlatT=64.2;
[FTE,tformfit] = plot_and_fit_tube_form2(QPDnmXc,StopT,StartPlatT,period1,Stiffness,Xt);
%% Save data to output structure

[fdo.QPDnmXc,fdo.QPDnmYc,fdo.Theta,fdo.Rho,fdo.mbslope,fdo.mangle]=deal(QPDnmXc,QPDnmYc,Theta,Rho,mbslope,mangle);% save arrays
[fdo.RampStT,fdo.RampEndT,fdo.zeroTime,fdo.StartT,fdo.StopT,fdo.Startrise,fdo.meanlr,fdo.Xt,fdo.Delay,fdo.DeltaT,fdo.FTAFR,fdo.Overshoot,fdo.kr,fdo.Numberform]=deal(RampStT,RampEndT,zeroTime,StartT,StopT,Startrise,meanlr,Xt,Delay,DeltaT,FTAFR,Overshoot,kdeltar,Numberform);% save positions
[fdo.YCS,fdo.TubeBreak,fdo.Stiffness,fdo.Slope,fdo.mTheta]=deal(YCS,TubeBreak,ForceData.Stiffness,ForceData.Slope,mTheta);
 [fdo.mbslopeY,fdo.StartTY,fdo.StopTY,fdo.StartrisetY,fdo.meanlrY,fdo.Yt,fdo.DelayY,fdo.DeltaTY]=deal(mbslopeY,StartTY,StopTY,StartriseY,meanlry,Yt,DelayY,DeltaTY);% save positions
 [fdo.StartPlatT,fdo.StopPlatT,fdo.Dplat,fdo.mThetaPlat,fdo.DeltaTPlat,fdo.ActComp,fdo.kplat]=deal(StartPlatT,StopPlatT,DPlat,mThetaPlat,DeltaTPlat,ActComp,kdeltap);% save arrays
%[fdo.tformfit,fdo.TFFTE]=deal(tformfit,FTE);
%% Save file of structure
k=fdo.Cellnumber;
newFolder=strcat('C:\Users\bfarrell\Documents\Data\HN31\Control\','cellc',num2str((k)));
genpath('newfolder');
cd(newFolder);
save(strcat('HN31','cellc', num2str(k),'.mat'),'fdo');
newFolder=strcat('C:\Users\bfarrell\Documents\M files');
genpath('newfolder');
cd(newFolder);
%%
clear;
numb=8;
i=1:1:1;
name2=strcat('HN31cellc',num2str(numb(i)),'.mat');
newFolder=strcat('C:\Users\bfarrell\Documents\Data\HN31\Control\','cellc',num2str(numb(i)));
genpath('newfolder')
cd(newFolder);
load(name2);
xlsstring = strcat('cellc'); 
xlsstring1 = strcat('cellcnames'); 

i=fdo.Cellnumber; 
numb2=i+1;
range=strcat('A',num2str(numb2));
newFolder=strcat('C:\Users\bfarrell\Documents\M files');
genpath('newfolder');
cd(newFolder);
extract_force_data( fdo,xlsstring,range,xlsstring1);

%%
  
 

