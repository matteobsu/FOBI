function [D] = Fobi4x10TimeDelays(time)
%TIME_DELAYS Summary of this function goes here
%   Detailed explanation goes here
Nt = length(time);
angles = [7.579 13.316 18.1825 30.831 36.201 53.363 61.1375 67.332 76.674 87.573]-7.579;
angles = [angles, angles+1*90, angles+2*90, angles+3*90]/360;
shifts = Nt*angles;
D = zeros(Nt,1); 
for i = 1:length(shifts)
    %% strip model
    sfloor = floor(shifts(i));
    rest = shifts(i)-sfloor;
    sfloor = sfloor+1;
    D(sfloor) = 1-rest;
    D(sfloor+1) = rest;
    %% line model
%     idd = 1+round(shifts(i));
%     D(idd)=1;
end
% D = imgaussfilt(D,'Padding','circular');
end

