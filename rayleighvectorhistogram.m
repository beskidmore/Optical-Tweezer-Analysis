close all
clear Restforce offset Restforce2 division total  h Mang ahat bhat Y1 ax start B2 hric MRI total rfit rconf
numb= [ 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 21 22 23 24 25 26 27 28 30 31 32 33 34 35 36 37 38 39 40 41 42 43 44];% same 10 similar 6 in same direction but higher 5 4 a nd 1 coming to same val
Restforce=zeros(20,20);
B=zeros(4000,1);
MAng=zeros(20,5);
MR=zeros(42,8);
period1=0.0005;
 for j=1:1:1
k=numb(1,j);
period1=(period1);
a=strcat('HN31cellc',num2str(k),'.mat');
newFolder=strcat('C:\Users\bfarrell\Documents\Data\HN31\Control\','cellc',num2str((k)));
genpath('newfolder');
cd(newFolder);
markersize=zeros(1,20);
markersize(1,1:1:20)=7;
load(a);
start=4;
start2=6;
start3=2;
anumb=1;

hold on;
period1=0.0005;
if j~=1
    division=2;
else
    division =1;
end

B2(1:1:size(fdo.Rho(round((start-(start3))/0.0005):1:round((start2-start3)/0.0005),1)),1)=fdo.Rho(round((start-(start3))/0.0005):1:round((start2-start3)/0.0005),1);
total=length(fdo.Rho(round((start-(start3))/(period1/1)):1:round((start-0.001)/(period1/1)),1));
[rfit, rconf] =raylfit(B2(1:1:total),0.05);
h2=raylpdf(0:1:400,rfit);
MR(j,1)=k; %cell number
MR(j,2)=rfit; %scale factor
MR(j,3)=rconf(1,1);
MR(j,4)=rconf(2,1);
MR(:,5)=MR(:,2)*(pi/2)^(0.5);%mean 
MR(:,6)=MR(:,2).^2*(2-pi/2); %variance
MR(j,7)=fdo.Slope;
MR(j,8)=fdo.Stiffness;

 figure1 = figure('NumberTitle','off','Color',[1 1 1]);
 ax1=axes('Parent',figure1,...
 'FontSize',16,'FontName','Times New Roman','Xticklabel',{'-150','-100','-50','0','50','100','150'},...
 'Xtick',[ -150 -100 -50 0 50 100 150 ],'Ylim',([0 0.05]),'Xlim',([-19 550]),'XColor', 'k','TickDir', 'out');
 hold(ax1,'on');
      histogram(B2(:,1),100,'normalization', 'probability','Facecolor',[0.8 0.8 0.8],'Edgecolor',[0.8 0.8 0.8]);
       hold (ax1,'on')
      plot(ax1,0:1:400,h2*1,'LineStyle', '--','LineWidth',2,'color','k');
% save to structure
MRay(1,1:1:6)=MR(j,1:1:6);
[fdo.MRayleigh]=deal(MRay);
% save fdo to file
k=fdo.Cellnumber;
subdirectory='Control';
newFolder=strcat('C:\Users\bfarrell\Documents\Data\HN31\',subdirectory,'\','cellc',num2str((k)));
genpath('newfolder');
cd(newFolder);
save(strcat('HN31','cellc', num2str(k),'.mat'),'fdo');
newFolder=strcat('C:\Users\bfarrell\Documents\M files\OT analysis');
genpath('newfolder');
cd(newFolder);

clear fdo temp N1 B2 tout sout h2 rfit rconf
B2=zeros(4000,1);
 end
