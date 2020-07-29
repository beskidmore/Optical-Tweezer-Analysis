function [dcm_obj,zeroforcetime]= plot_cslope(cslope, period1,Stime,Etime)
close all;
figure1 = figure('NumberTitle','off','Name','C_slope','Color',[1 1 1]);
axes('Parent',figure1,...
    'FontSize',12,'FontName','Arial');
xlim([Stime Etime])
ylim([-6.5 20])
xlabel('time, s','FontSize',12,'FontName','Arial');
ylabel('nm/s', 'FontSize',12,'FontName','Arial');
hold('all');
grid('on');
datacursormode on
dcm_obj = datacursormode(figure1);
set(dcm_obj,'DisplayStyle','datatip',...
'SnapToDataVertex','off','Enable','on')
plot((1:1:size(cslope(:,1))).*period1+Stime,cslope(1:1:size(cslope(:,1))),'color','g','linewidth',2);
disp('Click to display a data tip, then press Return.')
pause                            % Wait while the user does this.
zeroforcetime = getCursorInfo(dcm_obj);


end

