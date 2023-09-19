    
function [D] = Fobi3x14TimeDelays_v2(time)
    %TIME_DELAYS Summary of this function goes here
    %   Detailed explanation goes here
    Nt = length(time);
    angles = [0.8958 10.4775 21.1331 32.2086 37.0404 43.7625 59.2190 65.4966 75.5918 85.4641 91.0146 98.9699 108.2814 113.3630]
    angles = [angles 120+angles 240+angles]-0.8958;
    angles = [angles]/360;
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