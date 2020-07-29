function [B2,h2,MR]  =Calculate_Rayleigh_Scale_factor(start,start2,start3,Rho,period1,k,Slope,Stiffness,bin,j,MR);
B2=zeros(4000,1);
% Summary of this function goes here
% % grab the data
B2(1:1:size(Rho(round((start-start3)/period1):1:round((start2-start3)/period1),1)),1)=Rho(round((start-start3)/period1):1:round((start2-start3)/period1),1);
total=length(Rho(round((start-(start3))/period1):1:round((start-0.001)/period1,1)));
[rfit, rconf] =raylfit(B2(1:1:total),0.05); %fit data
h2=raylpdf(0:1:bin,rfit);
MR(j,1)=k; %cell number
MR(j,2)=rfit; %scale factor
MR(j,3)=rconf(1,1); %confidence interval
MR(j,4)=rconf(2,1); %confidence Interval
MR(j,5)=MR(j,2)*(pi/2)^(0.5);%mean 
MR(j,6)=MR(j,2).^2*(2-pi/2); %variance
MR(j,7)=Slope;
MR(j,8)=Stiffness;


end
