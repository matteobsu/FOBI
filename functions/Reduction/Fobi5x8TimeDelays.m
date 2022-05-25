function [D] = Fobi5x8TimeDelays(time)
%TIME_DELAYS Summary of this function goes here
%   Detailed explanation goes here
Nt = length(time);
angles = [4.81 17.09 24.47 31.35 36.48 48.21 59.64 66.64]-4.81;
angles = [angles]/90;
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

