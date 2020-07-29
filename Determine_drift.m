function [QPDnmXc, QPDnmYc, Theta, Rho] = Determine_drift( TubeBreak,QPDnmX,QPDnmY,period1,numbs,ND, Stt, Ftt)
zerodisp(1,1)=mean(QPDnmX(1:1:numbs));
zerodisp(1,2)=std(QPDnmX(1:1:numbs));

zerodisp(1,3)=mean(QPDnmY(1:1:numbs));
zerodisp(1,4)=std(QPDnmY(1:1:numbs));

zerodisp(1,5)=nanmean(QPDnmX(TubeBreak*1/(period1):1:length(QPDnmX)));
zerodisp(1,6)=nanstd(QPDnmX(TubeBreak*1/(period1):1:length(QPDnmX)));
zerodisp(1,7)=nanmean(QPDnmY(TubeBreak*1/(period1):1:length(QPDnmY)));
zerodisp(1,8)=nanstd(QPDnmY(TubeBreak*1/(period1):1:length(QPDnmY)));
% Find drift of the bead
driftX=ND*(zerodisp(1,5)-zerodisp(1,1))/(TubeBreak*1/period1-numbs); % nm/pt
driftY=ND*(zerodisp(1,7)-zerodisp(1,3))/(TubeBreak*1/period1-numbs); % nm/pt

% Correct for nonzerodisplacement and drift in X
QPDnmXc = zeros(length(QPDnmX), 1);

for i=1:1:length(QPDnmX)
QPDnmXc(i,1)=QPDnmX(i,1)-zerodisp(1,1);
 if (i>(18000))
     QPDnmXc(i,1)=QPDnmXc(i,1)-driftX*i;
  end
end
%  Correct for nonzerodisplacement and drift in Y
QPDnmYc = zeros(length(QPDnmY), 1);
for i=1:1:length(QPDnmY)
QPDnmYc(i,1)=QPDnmY(i,1)-zerodisp(1,3);
 if (i>(numbs))
     QPDnmYc(i,1)=QPDnmYc(i,1)-driftY*i;
 end
end
%Determine the angle amd resultant
[Theta,Rho] = cart2pol(QPDnmXc(:,1),QPDnmYc(:,1));
%clear QPDnmY QPDnmX; 
end
