load('C:\Users\skidmore\Desktop\OT_data\8-5-2019\Calibration\bead1\calibration_optical_tweezers08-05-2019_Transformed.mat');

Xb_slope1 = [Transformed_data{2,6}];
time_constant1 = mean([Transformed_data{2:5,7}]);
Stiffness1 = mean([Transformed_data{2:5,8}]);
load('C:\Users\skidmore\Desktop\OT_data\8-5-2019\Calibration\bead2\Calibration_optical_tweezers08-05-2019_Transformed.mat');

Xb_slope2 = [Transformed_data{2,6}];
time_constant2 = mean([Transformed_data{2:5,7}]);
Stiffness2 = mean([Transformed_data{2:5,8}]);

load('C:\Users\skidmore\Desktop\OT_data\8-5-2019\Calibration\bead3\Calibration_optical_tweezers08-05-2019_Transformed.mat');

Xb_slope3 = [Transformed_data{2,6}];
time_constant3 = mean([Transformed_data{2:5,7}]);
Stiffness3 = mean([Transformed_data{2:5,8}]);

Xb = (Xb_slope1+Xb_slope2+Xb_slope3)/3;
Stiffness = (Stiffness1+Stiffness2+Stiffness3)/3;
Time_constant = (time_constant1+time_constant2+time_constant3)/3;


%What is the power:
Laser_power = 6
%Power at objective:
Power_at_objective = 0.11
%Save Date
save('Calibration_data_8-5-2019','Stiffness', 'Time_constant', 'Xb', 'Laser_power', 'Power_at_objective')