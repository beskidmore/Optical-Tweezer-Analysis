% This script calculates the rayleigh scale factor plots it and saves it to
% the fdo structure and saves to the file.  This calculates the noise in 2
% % seconds of data at 2000 Hz.  It is good to visualize this data to ensure R distribution fits. 
close all
clear B2 Y1 ax start B2 hric MRI total rfit rconf
% numb= [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 21 22 23 24 25 26 27 28 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44];% same 10 similar 6 in same direction but higher 5 4 a nd 1 coming to same val
numb=[5000 2016 2017 2018];
B=zeros(4000,1);
MR=zeros(42,8); %This is the array for scale factor data  
period1=0.0005;
 for j=1:1:1
k=numb(1,j);  %this is number of cell
period1=(period1);
a=strcat('HN31cellnoc',num2str(k),'.mat');
%newFolder=strcat('C:\Users\bfarrell\Documents\Data\HN31\Control\','cellc',num2str((k))); %this is where control data are
%newFolder=strcat(ForceData.CellInfo,'cellnoc',num2str((k)));
newFolder=strcat(ForceData.CellInfo)
genpath('newfolder');
cd(newFolder);
load(a);
% This part defines the number of points usually 2 seconds or 4000 points
% when possible
Slope=fdo.Slope;
Stiffness=fdo.Stiffness;
Rho=fdo.Rho;
start=4;
start2=6;
start3=2;
bin=400;
newFolder=strcat('C:\Users\bfarrell\Documents\M files\OT analysis');
genpath('newfolder');
cd(newFolder);
[B2,h2,MR] =Calculate_Rayleigh_Scale_factor(start,start2,start3,Rho,period1,k,Slope,Stiffness,bin,j);

%plot data
figure1 = figure('NumberTitle','off','Color',[1 1 1]);
ax1=axes('Parent',figure1,...
'FontSize',16,'FontName','Times New Roman','Xticklabel',{'-150','-100','-50','0','50','100','150'},...
'Xtick',[ -150 -100 -50 0 50 100 150 ],'Ylim',([0 0.05]),'Xlim',([-19 550]),'XColor', 'k','TickDir', 'out');
hold(ax1,'on');
histogram(B2(:,1),100,'normalization', 'probability','Facecolor',[0.8 0.8 0.8],'Edgecolor',[0.8 0.8 0.8]);
hold (ax1,'on')
plot(ax1,0:1:400,h2*1,'LineStyle', '--','LineWidth',2,'color','k');
 end
%%      
% save to structure the first 6 points
MRay(1,1:1:6)=MR(j,1:1:6);
[fdo.MRayleigh]=deal(MRay);
%%
% save fdo to file
k=fdo.Cellnumber;
subdirectory='Noc';
newFolder=strcat('C:\Users\bfarrell\Documents\Data\HN31\Noc\','cellnoc',num2str((k)));

% newFolder=strcat('C:\Users\bfarrell\Documents\Data\HN31\',subdirectory,'\','cellc',num2str((k)));
genpath('newfolder');
cd(newFolder);
save(strcat('HN31','cellnoc', num2str(k),'.mat'),'fdo');
newFolder=strcat('C:\Users\bfarrell\Documents\M files\OT analysis');
genpath('newfolder');
cd(newFolder);

clear fdo temp N1 B2 total sout h2 rfit rconf MRay
B2=zeros(4000,1);
 
