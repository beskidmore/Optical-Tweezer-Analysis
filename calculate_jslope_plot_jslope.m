%Calculate jump slope for matrix X by finding the slope every D points
%starting at D_init.
clear mbslope;
period1=0.0005; % 1 point every 2kHz this depends upon collection frequency
D_init=100;
D=100;
D_final=2000;
clear eventname;
eventname=QPDnmYc(1:1:length(QPDnmYc));
kfinal=D_final/D-1;
mbslope= zeros(size(eventname(:,1),1)/10:1:kfinal);
 for k=1:1:10  % calculate ten slopes
     delta=D_init:D:D_final; % calculate ten slopes
     delta=delta';
     delta;
 for i=1:1:(size(eventname))/(delta(k));
tb= (i*delta(k)-(delta(k)-1):1:delta(k)*i)./delta(k)+initialtime;
tb=tb';
p=polyfit(tb*period1*delta(k),eventname(i*delta(k)-(delta(k)-1):1:delta(k)*i),1);
mbslope(i,k)=p(1);
 end
 end
 %% %Calculate jump slope for matrix X by finding the slope every D points
%starting at D_init.
clear mbslope2;
period1=0.0005; % 1 point every 2kHz this depends upon collection frequency
D_init=100;
D=100;
D_final=2000;
clear eventname;
eventname2=QPDnmXc(1:1:length(QPDnmXc));
kfinal2=D_final/D-1;
mbslope2= zeros(size(eventname2(:,1),1)/10:1:kfinal);
 for k=1:1:10  % calculate ten slopes
     delta=D_init:D:D_final; % calculate ten slopes
     delta=delta';
     delta;
 for i=1:1:(size(eventname2))/(delta(k));
tb2= (i*delta(k)-(delta(k)-1):1:delta(k)*i)./delta(k)+initialtime;
tb2=tb2';
p2=polyfit(tb2*period1*delta(k),eventname2(i*delta(k)-(delta(k)-1):1:delta(k)*i),1);
mbslope2(i,k)=p2(1);
 end
 end

 %% plot sectional slope to visualize regions and repeat for all rupture events usually less than 10
 hold on
 %close all;
%figure1 = figure('NumberTitle','On','Name','HN31jumpslope','Color',[1 1 1]);
%axes('Parent',figure1,'FontSize',16,'FontName','Arial');
%h=figure(1);
 
hold('all');
grid('on');
% xlabel('time, s','FontSize',18,'FontName','Arial');
% ylabel('slope units', 'FontSize',18,'FontName','Arial');
%dcm_obj = datacursormode(figure1);
%set(dcm_obj,'DisplayStyle','datatip',...
%'SnapToDataVertex','off','Enable','on')
mx=6; %this depends upon which slope U want to plot of the 39 this is 5th
nm=6; %this depends upon which slope U want to plot of the 39 this is 3rd
% note the 50 and 100 below correspond to the jslope averraging above

hold on;
%plot((1:1:length(QPDnmXc)).*period1+Stime,QPDnmXc(1:1:length(QPDnmXc),1)*ForceData.Stiffness,'color','b')
%plot(QPDnmXc, period1, 'color', 'b');
hold on;
%smoothdx = smooth(QPDnmXc, period1)
%PLOTXnm_Ynm_vs_time(smoothdx, QPDnmXc, period1, Stime);
hold on;
smoothd = smooth(QPDnmYc, period1)
PLOTXnm_Ynm_vs_time(smoothd, QPDnmYc, period1, Stime);
%plot((1:1:length(QPDnmXc)).*period1+Stime,QPDnmXc(1:1:length(QPDnmXc),1)*ForceData.Stiffness,'color','b')
hold on; 
plot((1:1:size(mbslope(:,nm)))*(((nm-1)*100+100)*period1),mbslope(1:1:size(mbslope(:,nm)),nm)*ForceData.Stiffness,'color',[0.85 0.33 0],'LineWidth', 1,'marker','o','markersize',10,'MarkerEdgeColor','k','MarkerFaceColor','r');
%%%%disp(mean(mbslope(1:1:size(mbslope(:,nm)),nm)*ForceData.Stiffness))
hold on;
%plot((1:1:size(mbslope2(:,mx)))*(((mx-1)*100+100)*period1),mbslope2(1:1:size(mbslope2(:,mx)),mx)*ForceData.Stiffness,'color',[0.3 0.75 .75],'LineWidth', 1,'marker','o','markersize',10,'MarkerEdgeColor','k','MarkerFaceColor','g');
%xlim([0 90])
hold on;
