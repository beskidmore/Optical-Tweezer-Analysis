%% This file calculates mbslope, plots it 
%clear
% this loads data already processed at 2khz 
%newFolder=strcat('C:\Users\bfarrell\Documents\Data\HN31\lat A\cellla1036');
% newFolder=strcat('C:\Users\bfarrell\Box Sync\Paper_Submission_with_VR\Comments\Data_for_paper\Data_for_paper\DATA_fromVR');
% genpath('newfolder');
% cd(newFolder);
% numb=1;
% A=['HN31cell','c',int2str(numb),'.mat'];
% B=strcat(A); 
% load(B);
Control_data=fdo.QPDnmYc;
QPDnmYc=fdo.QPDnmYc;
dptime=0.0005;
anumb=1;
newFolder=strcat('C:\Users\bfarrell\Box Sync\Documents (bfarrell@bcm.edu)\Benjamin\Benjamin data\Data_for_output_for_portal');
genpath('newfolder');
cd(newFolder);
% numb=6
%  D=['OHC','control',int2str(numb),'.mat'];
%  C=strcat(D); 
% load(C);
Stiffness=fdo.Stiffness;
%% Calculate sectional or jump-slope slope for four times averaging 100 to 2000 points, 
clear mbslope;
eventname=QPDnmYc(1:1:length(QPDnmYc));

mbslope = zeros(length(eventname)/100,39);
initialtime=0;
 for k=1:1:39
     
     delta=100:50:2000;
     delta=delta';
     delta;
 for i=1:1:(length(eventname))/(delta(k))
tb= (i*delta(k)-(delta(k)-1):1:delta(k)*i)./delta(k)+initialtime;
tb=tb';
i;
   p=polyfit(tb*dptime*delta(k),eventname(i*delta(k)-(delta(k)-1):1:delta(k)*i),1);
mbslope(i,k)=p(1);
end
 end
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
mx=2;
nm=3; %this is one U save
plot(((1:length(eventname))*0.0005-(fdo.RampStT)), eventname*fdo.Stiffness,'color','b')
hold on

plot((1:1:size(mbslope(:,nm)))*(((nm-1)*50+100)*dptime)-(fdo.RampStT),mbslope(1:1:size(mbslope(:,nm)),nm)*fdo.Stiffness,'color',[0.85 0.33 0],'LineWidth', 1,'marker','o','markersize',6,'MarkerEdgeColor','k','MarkerFaceColor','r');
% plot((1:1:size(mbslope(:,mx)))*(((mx-1)*50+100)*dptime)-(RampStT),mbslope(1:1:size(mbslope(:,mx)),mx)*fdo.Stiffness,'color',[0.3 0.75 .75],'LineWidth', 1,'marker','o','markersize',6,'MarkerEdgeColor','k','MarkerFaceColor','g');
xlim ([-2 6])
ylim ([-40 120])
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
eventname=QPDnmYc(1:1:length(QPDnmXc));
MBNUM=nm;
delta=((MBNUM-1)*50+100);

PSloperf=[];
for j=1:1:length(find (Pstartp))
    PSloper=eventname((Pstartp(j))*delta:(Pstopp(j))*delta); %range of force
    PSloperf{j}=PSloper;
end
%%
PFt=zeros(length(PSloperf),2);
for j=1:length(PSloperf)
    Ls=length(PSloperf{j});
    PFt(j,1)=mean(PSloperf{j}(1:100)); %take first 100 points measure mean displacement
    PFt(j,2)=mean(PSloperf{j}(Ls-100:Ls)); %take last 100 points measure mean displacement
    
end

PdT=(Pstopt-Pstartt)'; % delta time
PdF=(PFt(:,2)- PFt(:,1))*fdo.Stiffness; %delta force
PdF_2=(PFt(:,2))*fdo.Stiffness; %rupture force beginiing and end points

meanlr=[];

for j=1:length (PSloperf)
    L=length(PSloperf{j});
    time1=(1:L).*dptime;
    time1=time1';
    [p,S]=polyfit(time1,PSloperf{j}*fdo.Stiffness,1);
    meanlr(j)=p(1);
    
    FIT=polyval(p,time1);
    plot (PSloperf{j}), hold on, plot(FIT)
end
%
% calculate compression force before pull
FSC=mean(Control_data(round(fdo.RampStT/0.0005)-2000:1:round(fdo.RampStT/0.0005)))*fdo.Stiffness;
delay=Pstartt;
%fdo.Number_Tubes=3; % This may require to be examined every time to ensure
%fdo.Type=1;
%it is correct
%%
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
mx=2;
nm=4;%fdo_p1.mblopeusedrupt; %this is one U save
plot((1:length(eventname))*0.0005-(fdo.RampStT), eventname*fdo.Stiffness,'color','b')
hold on
  plot((1:1:size(mbslope(:,nm)))*(((nm-1)*50+100)*dptime)-(fdo.RampStT),mbslope(1:1:size(mbslope(:,nm)),nm)*fdo.Stiffness,'color',[0.85 0.33 0],'LineWidth', 1,'marker','o','markersize',6,'MarkerEdgeColor','k','MarkerFaceColor','r');
 % plot((1:1:size(mbslope(:,mx)))*(((mx-1)*50+100)*dptime)-(RampStT),mbslope(1:1:size(mbslope(:,mx)),mx)*fdo.Stiffness,'color',[0.3 0.75 .75],'LineWidth', 1,'marker','o','markersize',6,'MarkerEdgeColor','k','MarkerFaceColor','g');
%xlim ([(fdo_p1.StopTPull(1,1)-fdo.RampStT),20])
xlim ([-1,8])

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
eventname=QPDnmXc(1:1:length(QPDnmXc));
MBNUM=nm;
delta=((MBNUM-1)*50+100);

PSloperf=[];
for j=1:1:length(find (Pstartp))
    PSloper=eventname((Pstartp(j))*delta:(Pstopp(j))*delta); %range of force
    PSloperf{j}=PSloper;
end
%%
plateau(1,1)=i;
plateau(1,2)=mean(PSloper(:,1))*fdo.Stiffness;
plateau(1,3)=std(PSloper(:,1))*fdo.Stiffness;
plateau(1,4)=Pstartt(i)+fdo.RampStT;
plateau(1,5)=Pstopt(i)+fdo.RampStT;
% [fdo_p1.plateau]=deal(plateau);
% [fdo_p1.FSC]=deal(FSC);
%%
plateau2(1,1)=i;
plateau2(1,2)=mean(PSloper(:,1))*fdo.Stiffness;
plateau2(1,3)=std(PSloper(:,1))*fdo.Stiffness;
plateau2(1,4)=Pstartt(i)+fdo.RampStT;
plateau2(1,5)=Pstopt(i)+fdo.RampStT;
% [fdo_p1.plateau]=deal(plateau);
% [fdo_p1.FSC]=deal(FSC);

%%
stationary(1,1)=1;
stationary(1,2)=mean(PSloper(:,1))*fdo.Stiffness;
stationary(1,3)=std(PSloper(:,1))*fdo.Stiffness;
stationary(1,4)=Pstartt(i)+fdo.RampStT;
stationary(1,5)=Pstopt(i)+fdo.RampStT;
[fdo_p1.stationary]=deal(stationary);

%%
plateau3(1,1)=3;
plateau3(1,2)=mean(PSloper(:,1))*fdo.Stiffness;
plateau3(1,3)=std(PSloper(:,1))*fdo.Stiffness;
plateau3(1,4)=Pstartt(i)+fdo.RampStT;
plateau3(1,5)=Pstopt(i)+fdo.RampStT;
[fdo_p1.plateau3]=deal(plateau3);
%%
[fdo_p1.plateau]=deal(plateau);
%[fdo_p1.plateau2]=deal(plateau2);
%[fdo_p1.plateau3]=deal(plateau3);
%% find time constant for relaxation
clear frelax t;
 options = optimoptions('lsqcurvefit','MaxFunctionEvaluations',90000,'MaxIterations',90000,'TolFun', 1E-7,'Display','final','FunctionTolerance', 1E-15,'StepTolerance',1E-8,'FiniteDifferenceType','forward','OptimalityTolerance',1E-20);
t=fdo_p1.StopTPull(1):0.0005:(fdo_p1.plateau(1,5));
%t=59.7:0.0005:61.03;
t=t';
frelax=eventname(round(fdo_p1.StopTPull(1)/0.0005):1:round(fdo_p1.plateau(1,5)/0.0005))*Stiffness; 
%frelax=eventname(round(59.7/0.0005):1:round(61.03/0.0005))*Stiffness; 

%range of force
 to=0.5;
 lb=0.2;
 ub=10;


fun = @(to,t) fdo_p1.plateau(1,2)-(fdo_p1.plateau(1,2)-(fdo.FmaxPULL(1))).*exp((-(t-fdo_p1.StopTPull(1)))/to);
%fun = @(to,t) 88-(88-(fdo.FmaxPULL(2))).*exp((-(t-59.7))/to);
 
[to,resnorm,residual,exitflag,output] = lsqcurvefit(fun,to,t,frelax(1:1:length(t),1),lb,ub,options);
%%
close all

plot(t-fdo_p1.RampStT,frelax(1:1:size(t),1),'-k',t-fdo_p1.RampStT,fun(to,t),'-b');
hold on;
%%

%%
%   D=['HN31','la',int2str(numb),'.mat'];
%    C=strcat(D);
save(C,'fdo_p1');
%% Determine delay with cumslope;
Stime =fdo.RampStT-2;
Etime= fdo.RampStT+1;
initialtime=0;
period1=0.0005;
newFolder=strcat('C:\Users\bfarrell\Documents\M files\OT analysis');
genpath('newfolder');
cd(newFolder);
[cslope] = cumslope(QPDnmYc,Stime,Etime,period1,initialtime);
[dcm_obj,StartTrise]= plot_cslope(cslope, period1,Stime,Etime);
Delay_Actual=StartTrise.Position(1,1)-fdo.RampStT
TStartrise=StartTrise.Position(1,1);
%% Get Rayleigh data this is needed if not originally calculated
Slope=fdo.Slope;
Stiffness=fdo.Stiffness;
rho=fdo.rho;
start=4;
start2=6;
start3=2;
bin=400;
period1=0.0005;
j=1;
k(1,j)=1;
newFolder=strcat('C:\Users\bfarrell\Documents\M files\OT analysis');
genpath('newfolder');
cd(newFolder);
[B2,h2,MR] =Calculate_Rayleigh_Scale_factor(start,start2,start3,rho,period1,k,Slope,Stiffness,bin,j);
%%
%plot data
figure1 = figure('NumberTitle','off','Color',[1 1 1]);
ax1=axes('Parent',figure1,...
'FontSize',16,'FontName','Times New Roman','Xticklabel',{'-150','-100','-50','0','50','100','150'},...
'Xtick',[ -150 -100 -50 0 50 100 150 ],'Ylim',([0 0.05]),'Xlim',([-19 550]),'XColor', 'k','TickDir', 'out');
hold(ax1,'on');
histogram(B2(:,1),100,'normalization', 'probability','Facecolor',[0.8 0.8 0.8],'Edgecolor',[0.8 0.8 0.8]);
hold (ax1,'on')
plot(ax1,0:1:400,h2*3,'LineStyle', '--','LineWidth',2,'color','k');
MRayleigh(1,1:1:6)=MR(j,1:1:6);
%[fdo.MRayleigh]=deal(MRayleigh);

%% save variables to struct and save
newFolder=strcat('C:\Users\bfarrell\Box Sync\Paper_Submission_with_VR\Comments\Data_for_paper\Data_for_paper\DATA_fromVR\Data for output to portal');
genpath('newfolder');
cd(newFolder);
C=['HN31','d',int2str(numb),'.mat'];
D=strcat(C);

%%%% Save to structure for publication
fdo_p1=struct('Researcher',fdo.Researcher,'Dofexp',fdo.Dofexp,'Cellnumber',fdo.Cellnumber,'Stiffness',fdo.Stiffness,'Rayleigh_Scale_Factor',fdo.MRayleigh(1,5:6),'zeroTime',fdo.zeroTime,...
'MCompF_b_Pull',FSC,'mblopeusedrupt',MBNUM,'RampStT',fdo.RampStT,'RampEndT',fdo.RampEndT,'delay',delay,'StartTPull',Pstartt+fdo.RampStT,...
'StopTPull',Pstopt+fdo.RampStT,'dTPull',PdT,'FmaxPull',PdF_2,'dFPull',PdF, 'L_rate', meanlr,'Number_of_tubes',fdo.Number_Tubes,'Type',fdo.Type,'slope_Number',i,'Delay_actual',Delay_Actual,'Rise_Actual',TStartrise);
%%
save(D,'fdo_p1');

%% Save to fdo out
% newFolder=strcat('C:\Users\bfarrell\Box Sync\Paper_Submission_with_VR\Comments\Data_for_paper\Data_for_paper\DATA_fromVR\Data for output to portal')
% genpath('newfolder');
% cd(newFolder);
% 
% C=['HN31','noc',int2str(numb),'.mat'];
% D=strcat(C);
% save(D,'fdo_p1');
% %% load struct
% newFolder=strcat('C:\Users\bfarrell\Box Sync\Paper_Submission_with_VR\Comments\Data_for_paper\Data_for_paper\DATA_fromVR\Data for output to portal')
% genpath('newfolder');
% cd(newFolder);
% C=['HN31','control',int2str(numb),'.mat'];
% D=strcat(C);
% load(D)
%%
close all;
clear Cursorposition PSloper PSloperf Pstartp Pstartt Pstopp Pstopt
i=menu('Choose forcemax  number','1','2','3','4','5');
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
mx=15;
nm=fdo_p1.mblopeusedrupt; %this is one U save
plot((1:length(eventname))*0.0005-(fdo.RampStT), eventname*fdo.Stiffness,'color','b')
hold on
  plot((1:1:size(mbslope(:,nm)))*(((nm-1)*50+100)*dptime)-(fdo.RampStT),mbslope(1:1:size(mbslope(:,nm)),nm)*fdo.Stiffness,'color',[0.85 0.33 0],'LineWidth', 1,'marker','o','markersize',6,'MarkerEdgeColor','k','MarkerFaceColor','r');
%  plot((1:1:size(mbslope(:,mx)))*(((mx-1)*50+100)*dptime)-(RampStT),mbslope(1:1:size(mbslope(:,mx)),mx)*fdo.Stiffness,'color',[0.3 0.75 .75],'LineWidth', 1,'marker','o','markersize',6,'MarkerEdgeColor','k','MarkerFaceColor','g');
xlim ([-1 15])
ylim ([-200 100])
%
disp('Click on a line to display a data tip, then press Return.')
pause                            % Wait while the user does this.

Cursorposition = getCursorInfo(dcm_obj);
%%
Pstartp(i)=Cursorposition(1,2).DataIndex(1) ;
Pstartt(i)=Cursorposition(1,2).Position(1);
%
Pstopp(i)=Cursorposition(1,1).DataIndex(1);
%stopt(i)=Cursorposition(1,1).Position(1)+((k+1)*50/2000);
Pstopt(i)=Cursorposition(1,1).Position(1);

disp([ num2str(Pstartp(i)) '  ' num2str(Pstopp(i))  ])
disp([ num2str(Pstartt(i)) ' ' num2str(Pstopt(i))  ])
eventname=QPDnmXc(1:1:length(QPDnmXc));
MBNUM=nm;
delta=((MBNUM-1)*50+100);

PSloperf=[];
for j=1:1:length(find (Pstartp))
    PSloper=eventname((Pstartp(j))*delta:(Pstopp(j))*delta); %range of force
    PSloperf{j}=PSloper;
end
%
clear fmax
fmax(1,1)=1;
fmax(1,2)=mean(PSloper(:,1))*fdo.Stiffness;
fmax(1,3)=std(PSloper(:,1))*fdo.Stiffness;
fmax(1,4)=Pstartt(i)+fdo.RampStT;
fmax(1,5)=Pstopt(i)+fdo.RampStT;
%%
[fdo_p1.fmax]=deal(fmax);
%%
save(D,'fdo_p1');
