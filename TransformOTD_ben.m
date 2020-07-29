function [QPDnmX,QPDnmY,RampEndT,RampStT] = TransformOTD(fdo,num,inv1)
%Transform OT data, read data, normalize with respect to sum, and plot it. 
%   Detailed explanation goes here
L=length((fdo(1,num).ForceData));
time1=(1:L).*0.0005;
time1=time1';
[p]=polyfit(time1,fdo(1,num).ForceData(1:L,3),2);
%%%plot((1:1:length(fdo(1,num).ForceData))*0.0005,fdo(1,num).ForceData(1:L,3), 'b')
QPDsignalsum=polyval(p,time1);
%hold on; plot((1:1:L).*0.0005,QPDsignalsum(1:L,1), 'g'); 
% For dates after the signal was switched 2 is Y and 1 is X 
%QPDsignalX=fdo(1,num).ForceData(1:L,2)./(10.*QPDsignalsum(1:L,3));% determining X relative to sum treats NaN as missing values
QPDsignalX=fdo(1,num).ForceData(1:L,2)./(10*fdo(1,num).ForceData(1:L,3));
%QPDsignalY=fdo(1,num).ForceData(1:L,1)./(10.*QPDsignalsum(1:L,3)); % signal in volts
QPDsignalY=fdo(1,num).ForceData(1:L,1)./(10.*fdo(1,num).ForceData(1:L,3)); % signal in volts

% QPDsignalX=ForceData(1,num).QPDdata(1:L,2)./(10.*ForceData(1,num).QPDdata(1:L,3));% determining X relative to sum treats NaN as missing values
% QPDsignalY=ForceData(1,num).QPDdata(1:L,1)./(10.*ForceData(1,num).QPDdata(1:L,3)); % signal in volts

QPDnmX=QPDsignalX./(inv1*fdo(1,num).Slope); % signal in nm
QPDnmY=QPDsignalY./(inv1*fdo(1,num).Slope); % signal in nm
% this for dates after august 2013
 %RampEndT= 2*(5+((ForceData(1,num).Properties(1,23)))+5+20);
 %RampStT=2*((ForceData(1,num).Properties(1,23))+10);
 
%BEN JUST SET THE NUMBERS TO CELL TOUCH TIME AND END OF MOVEMENT TIME
%Di Actual (um)+ distance of push (um) X push speed(um/s)+  Time At Cell (s) + pull(um/s)*Distance of pull (um)
RampEndT=  fdo(1,num).Properties(1,21) + abs(fdo(1,num).Properties(1,15)/fdo(1,num).Properties(1,16)) +  fdo(1,num).Properties(1,18) + abs(fdo(1,num).Properties(1,22)/fdo(1,num).Properties(1,17));
%Di Actual (um)+ distance of push (um) X push speed(um/s)+  Time At Cell (s)
RampStT=  fdo(1,num).Properties(1,21)+ abs(fdo(1,num).Properties(1,15)/fdo(1,num).Properties(1,16)) + fdo(1,num).Properties(1,18) ;
clear QPDsignalX QPDsignalY 
end