function PLOTXnm_Ynm_vs_time(QPDnmX,QPDnmY,period1,Stime)
%close all;
hold on;
grid on;
% % %plot((1:1:length(QPDnmY)).*period1+Stime,0.0909*QPDnmY(1:1:length(QPDnmY),1),'color','g')
% % %plot((1:1:length(QPDnmX)).*period1+Stime,0.0909*QPDnmX(1:1:length(QPDnmX),1),'color','r')
%ylabel ('Force (pN)')
plot((1:1:length(QPDnmY)).*period1+Stime,QPDnmY(1:1:length(QPDnmY),1),'color','g')
plot((1:1:length(QPDnmX)).*period1+Stime,QPDnmX(1:1:length(QPDnmX),1),'color','r')
ylabel ('Force (pN)')
legend('Y', 'X')
xlabel( 'Time (s)')
%xlim ([20 65])
%ylim ([-30 150])
% Note in this plot the position of tube break if it occurs
end