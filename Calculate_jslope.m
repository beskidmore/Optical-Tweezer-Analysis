
function [mbslope] = Calculate_jslope(QPDnmXc,initialtime,D_init,D,D_final, period1)
%Calculate jump slope for matrix X by finding the slope every D points
%starting at D_init.
%   Detailed explanation goes here
clear eventname;
eventname=QPDnmXc(1:1:length(QPDnmXc));
kfinal=D_final/D-1;
mbslope= zeros(size(eventname(:,1),1)/10:1:kfinal);
 for k=1:1:10
     delta=D_init:D:D_final;
     delta=delta';
     delta;
 for i=1:1:(size(eventname))/(delta(k));
tb= (i*delta(k)-(delta(k)-1):1:delta(k)*i)./delta(k)+initialtime;
tb=tb';
p=polyfit(tb*period1*delta(k),eventname(i*delta(k)-(delta(k)-1):1:delta(k)*i),1);
mbslope(i,k)=p(1);
 end
 end

end