function [QPDnmX,QPDnmY,RampEndT,RampStT] = TransformOTD(ForceData,num,inv1)
%Transform OT data, read data, normalize with respect to sum, and plot it. 
%   Detailed explanation goes here
L=length((ForceData(1,num).QPDdata));
time1=(1:L).*0.0005;
time1=time1';
[p]=polyfit(time1,ForceData(1,num).QPDdata(1:L,3),2);
plot((1:1:length(ForceData(1,num).QPDdata))*0.0005,ForceData(1,num).QPDdata(1:L,3), 'b')
QPDsignalsum=polyval(p,time1);
hold on; plot((1:1:L).*0.0005,QPDsignalsum(1:L,1), 'g'); 
% For dates after the signal was switched 2 is Y and 1 is X 
%QPDsignalX=ForceData(1,num).QPDdata(1:L,2)./(10.*QPDsignalsum(1:L,3));% determining X relative to sum treats NaN as missing values
QPDsignalX=ForceData(1,num).QPDdata(1:L,2)./(10*ForceData(1,num).QPDdata(1:L,3));
%QPDsignalY=ForceData(1,num).QPDdata(1:L,1)./(10.*QPDsignalsum(1:L,3)); % signal in volts
QPDsignalY=ForceData(1,num).QPDdata(1:L,1)./(10.*ForceData(1,num).QPDdata(1:L,3)); % signal in volts

% QPDsignalX=ForceData(1,num).QPDdata(1:L,2)./(10.*ForceData(1,num).QPDdata(1:L,3));% determining X relative to sum treats NaN as missing values
% QPDsignalY=ForceData(1,num).QPDdata(1:L,1)./(10.*ForceData(1,num).QPDdata(1:L,3)); % signal in volts

QPDnmX=QPDsignalX./(inv1*ForceData(1,num).Slope); % signal in nm
QPDnmY=QPDsignalY./(inv1*ForceData(1,num).Slope); % signal in nm
% this for dates after august 2013
 RampEndT= 2*(5+((ForceData(1,num).Properties(1,23)))+5+10);
 % this for dates before august 2013
%    RampEndT= 2*(5+((20))+5+10);
%       RampStT=2*(5+((20))+5);

 RampStT=2*((ForceData(1,num).Properties(1,23))+10);
clear QPDsignalX QPDsignalY 
end