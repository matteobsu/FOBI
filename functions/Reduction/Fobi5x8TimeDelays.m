function [D] = Fobi5x8TimeDelays(time)
%TIME_DELAYS Summary of this function goes here
%   Detailed explanation goes here
Nt = length(time);
angles = [4.81 17.09 24.47 31.35 36.48 48.21 59.64 66.64]-4.81;
angles = [angles, angles+1*72, angles+2*72, angles+3*72, angles+4*72]/360;
shifts = Nt*angles;
D = zeros(Nt,1); 
for i = 1:length(shifts)
    sfloor = floor(shifts(i));
    rest = shifts(i)-sfloor;
    sfloor = sfloor+1;
    D(sfloor) = 1-rest;
    D(sfloor+1) = rest;
end
end

