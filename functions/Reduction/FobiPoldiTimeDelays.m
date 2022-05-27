function [D] = FobiPoldiTimeDelays(time)
%TIME_DELAYS Summary of this function goes here
%   Detailed explanation goes here
Nt = length(time);
angles = [0, 9.363, 21.475, 37.039, 50.417, 56.664, 67.422, 75.406];
angles = fliplr(90-angles); 
angles=angles-angles(1);
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

