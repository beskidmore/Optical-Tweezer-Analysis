close all
clear Restforce offset Restforce2 division total  h Mang ahat bhat Y1 ax start B2 hric MRI total rfit rconf
numb= [ 1 2 3 4 5 6 7 8 9 10 12 13 14 15 16 23 27 28 30 39 21 44];% same 10 similar 6 in same direction but higher 5 4 a nd 1 coming to same val
% 4 8 15 or 16 18 is interestong
% 18 looks like tube break going up.
Restforce=zeros(20,20);
B=zeros(4000,1);
MR=zeros(50,7);
period1=0.0005;
 for j=1:1:22
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
start2=9;
start3=2;
anumb=1;
hold on;
period1=0.0005;
if j~=1
    division=2;
else
    division =1;
end
% fit to Rayleigh
B2(1:1:size(fdo.Rho(round((start-(start3))/0.0005):1:round((start2-start3)/0.0005),1)),1)=fdo.Rho(round((start-(start3))/0.0005):1:round((start2-start3)/0.0005),1);
total=length(fdo.Rho(round((start-(start3))/(period1/1)):1:round((start-0.001)/(period1/1)),1));
[rfit, rconf] =raylfit(B2(1:1:total),0.05);
h2=raylpdf(0:1:400,rfit);  %this defines the bin width
MR(j,1)=k;
MR(j,2)=rfit;
MR(j,3)=rconf(1,1);
MR(j,4)=rconf(2,1);
MR(:,5)=MR(:,2)*(pi/2)^(0.5);
MR(:,6)=MR(:,2).^2*(2-pi/2);
MR(j,7)=fdo.Slope;
MR(j,8)=fdo.Stiffness;
% plot data
  switch division
      case 1
          for m = 1:1:22
           h(m) = subplot(2,11,m);
           ax(m)=h(m);
          end
         
       hold(ax(1),'on')
% This code is to plot just one plot for presentation       
% figure1 = figure('NumberTitle','off','Color',[1 1 1]);
% ax1=axes('Parent',figure1,...
% 'FontSize',16,'FontName','Times New Roman','Xticklabel',{'-150','-100','-50','0','50','100','150'},...
% 'Xtick',[ -150 -100 -50 0 50 100 150 ],'Ylim',([0 0.05]),'Xlim',([-19 550]),'XColor', 'k','TickDir', 'out');
     histogram(ax(1),B2(:,1),100,'normalization', 'probability','Facecolor',[0.8 0.8 0.8],'Edgecolor',[0.8 0.8 0.8]);
      drawnow
      hold (ax(1),'on')
      plot(ax(1),0:1:400,h2*1,'LineStyle', '--','LineWidth',2,'color','k');
     case 2 
     hold(ax(j),'on');
      histogram(ax(j),B2(:,1),100,'normalization', 'probability','Facecolor',[0.8 0.8 0.8],'Edgecolor',[0.8 0.8 0.8]);
      plot(ax(j),0:1:400,h2*1,'LineStyle', '--','LineWidth',2,'color','k');
     end      
clear fdo temp N1 B2 tout sout h2 rfit rconf
B2=zeros(4000,1);
 end
%% Need to save MR to fdo structure