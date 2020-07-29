%% Transform OT data to nm after checking sum and normalizing it
num=1;
inv1=-1;
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
fdo.QPDnmXc = QPDnmXc;
fdo.QPDnmYc = QPDnmYc;
fdo.RampStT = RampStT;
fdo.RampEndT = RampEndT;
save('fdo.mat', 'fdo')
 %0.
 %m = matfile(filename,'Writable',true);
 %m.device = [m.device,newdata];
%% Plot data after correcting for drift
close all;
Stime=0;
PLOTXnm_Ynm_vs_time(QPDnmXc,QPDnmYc,period1,Stime);
%[theta,rho] = cart2pol(QPDnmXc,QPDnmYc);
%PLOTXnm_Ynm_vs_time(QPDnmXc,rho,period1,Stime);

%% Calculate cumslope;
% When did the program start?
Stime = 1;
% When did ramping end?
Etime= 75;
initialtime=0;
%%%%%[cslope] = cumslope(QPDnmXc,Stime,Etime,period1,initialtime);
%%[cslope] = cumslope(QPDnmYc,Stime,Etime,period1,initialtime);
%% function [cslope] = cumslope(QPDnmXc,Stime,Etime,period1, initialtime )
clear eventname; clear cslope;
eventname=QPDnmYc(Stime*1/period1:1:Etime*1/period1,1); % Just look at section
%translating from time to counter period 1 was 0.0005 here 

cslope = zeros(200000-1,1); % set up matrix this was for 20 seconds may need larger array

    for i=1:1:size(eventname)-1;
        t= (1:1:i+1)./2000+initialtime-1/period1; % calculate time
        t=t';
        q=polyfit(t,eventname(1:1:i+1,1),1);  % fit to linear function polyfit is function in Matlab
        cslope(i,1)=q(1);
    end
    clear q;

%% Plot time when force is zero This uses interactive object 
%Stime=25;
%Etime=50;
close all;
plot(period1, cslope, Stime)
%[dcm_obj,zeroforcetime]= plot_cslope(cslope, period1,Stime,Etime);
%zeroTime=zeroforcetime.Position(1,1);

%% function [ ] = PLOTXnm_Ynm_vs_time_first10(QPDnmXc,QPDnmYc,period1)
figure1 = figure('NumberTitle','off','Color',[1 1 1]);
 axes('Parent',figure1,...
     'FontSize',18,'FontName','Times New Roman');
plot((1:1:round(10/period1))*period1,QPDnmXc(1:1:round(10/period1)),'linestyle', '-','color',[0.5 0.5 0.5]);
set(gca, 'Yl  im',([-90 90]),'Xlim',([-1 11]),'linewidth',1,'FontSize',18,'FontName','Helvetica','Xticklabel',{'0','5','10'},...
'Xtick',[0 5 10 ],'Ytick',[-90 -60 -30 0 30 60 90],'Yticklabel',{'-90','-60','-30','0','30','60','90'},'box','off');
hold on 
plot((1:1:round(10/period1))*period1,QPDnmYc(1:1:round(10/period1)),'color',[0.8 0.8 0.8],'linestyle', '-');

%   Detailed explanation goes here



%% NOISE FILTER (All pass filter)
smoothd = smooth(QPDnmYc, period1)
PLOTXnm_Ynm_vs_time(smoothd, QPDnmYc, period1, Stime)
%% 

out = reshape(QPDnmYc, [], 5)
noise_reduceY = mean(out, 2)

PLOTXnm_Ynm_vs_time(noise_reduceY, QPDnmYc, (period1),Stime)
