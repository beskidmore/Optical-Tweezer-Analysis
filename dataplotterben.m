filename3 = 'C:\Users\skidmore\Desktop\OT_data\bead-and-out-of-trap-data-for-mlab.xlsx';
close all
time=xlsread(filename3, 'E3:E92');
force=xlsread(filename3, 'D3:D92');
condition=xlsread(filename3, 'K3:K92');
power=xlsread(filename3, 'F3:F92');

c = 3;

hold on;
for i=1:1:size(condition)
if(condition(i,1)==1&&power(i,1)==5)
    plot(time(i),force(i),'marker','o', 'markersize',12, 'linestyle','none','color','r');
elseif(condition(i,1)==1&&power(i,1)==5.5)
    plot(time(i),force(i),'marker','o', 'markersize',12, 'linestyle','none','color','g');
elseif(condition(i,1)==1&&power(i,1)==6)
    plot(time(i),force(i),'marker','o', 'markersize',12, 'linestyle','none','color','b');
elseif(condition(i,1)==0&&power(i,1)==5)
    plot(time(i),force(i),'marker','x', 'markersize',12, 'linestyle','none','color','r');
elseif(condition(i,1)==0&&power(i,1)==5.5)
    plot(time(i),force(i),'marker','x', 'markersize',12, 'linestyle','none','color','g');
elseif(condition(i,1)==0&&power(i,1)==6)
    plot(time(i),force(i),'marker','x', 'markersize',12, 'linestyle','none','color','b');
elseif(condition(i,1)==2&&power(i,1)==5)
    plot(time(i),force(i),'marker','d', 'markersize',12, 'linestyle','none','color','r');
elseif(condition(i,1)==2&&power(i,1)==5.5)
    plot(time(i),force(i),'marker','d', 'markersize',12, 'linestyle','none','color','g');
elseif(condition(i,1)==2&&power(i,1)==6)
    plot(time(i),force(i),'marker','d', 'markersize',12, 'linestyle','none','color','b');
elseif(condition(i,1)==3&&power(i,1)==5)
    plot(time(i),force(i),'marker','.', 'markersize',12, 'linestyle','none','color','r');
elseif(condition(i,1)==3&&power(i,1)==5.5)
    plot(time(i),force(i),'marker','.', 'markersize',12, 'linestyle','none','color','g');
elseif(condition(i,1)==3&&power(i,1)==6)
    plot(time(i),force(i),'marker','.', 'markersize',12, 'linestyle','none','color','b');
end
end
xlabel('Time (s)');
ylabel('Force (pN)');
set(gca,'FontSize',14)
set(gca, 'FontName', 'Times New Roman')
%% 
hold on;
binsize = 0:5:60;
yyaxis right
ylabel('Count')
hold on;

h1 = histc(forcetimecondition82019S1.Timetofullbreakafterpullpulloutpleatauifbasalend, binsize)
h2 = histc(forcetimecondition82019S1.Timetofullbreakafterpullpulloutpleatauifbasalend1, binsize)
h3 = histc(forcetimecondition82019S1.Timetofullbreakafterpullpulloutpleatauifbasalend2, binsize)
h4 = histc(forcetimecondition82019S1.Timetofullbreakafterpullpulloutpleatauifbasalend3, binsize)
%h = histogram(forcetimecondition82019S1.Timetofullbreakafterpullpulloutpleatauifbasalend, binsize,'FaceColor','m', "FaceAlpha", 0.1)
%i = histc(forcetimecondition82019S1.Timetofullbreakafterpullpulloutpleatauifbasalend1, binsize, 'FaceColor','y', "FaceAlpha", 0.1)
%s = histc(forcetimecondition82019S1.Timetofullbreakafterpullpulloutpleatauifbasalend2,binsize, 'FaceColor','k', "FaceAlpha", 0.1)
%t = histc(forcetimecondition82019S1.Timetofullbreakafterpullpulloutpleatauifbasalend3, binsize, 'FaceColor','w', "FaceAlpha", 0.1)
%disp(h1)

%%bar(binsize+2.5, h1, 'facecolor', 'none', 'edgecolor', 'b',  'barwidth', 1)
%%bar(binsize+2.5, h2, 'facecolor', 'none', 'edgecolor', 'm','barwidth', 1)
%%bar(binsize+2.5, h3, 'facecolor', 'none', 'edgecolor', 'r','barwidth', 1)
%%bar(binsize+2.5, h4, 'facecolor', 'none', 'edgecolor', 'g','barwidth', 1)

gram1 = h1 + h2 
gram2 = gram1 + h3 
gram3 = gram2 + h4
bar(binsize+2.5, gram3, 'facecolor', 'none', 'edgecolor', 'c',  'barwidth', 1, 'linewidth', 1.5)
bar(binsize+2.5, gram2, 'facecolor', 'none', 'edgecolor', 'm','barwidth', 1, 'linewidth', 1.5)
bar(binsize+2.5, gram1, 'facecolor', 'none', 'edgecolor', 'y','barwidth', 1, 'linewidth', 1.5)
bar(binsize+2.5, h1, 'facecolor', 'none', 'edgecolor', 'k','barwidth', 1, 'linewidth', 1.5)




