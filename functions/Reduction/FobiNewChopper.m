function [D] = FobiNewChopper(time)
    %TIME_DELAYS Summary of this function goes here
    %   Detailed explanation goes here
    Nt = length(time);
    angles = [0, 54, 78, 90.5, 113, 144.5, 158, 179.5, 202, 234.5, 247, 270, 301, 324.5];
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
    
    