function [D,angles] = chopper_time_delays(time,nslits,nrep,mode,rng)
%TIME_DELAYS Summary of this function goes here
%   Detailed explanation goes here

if exist('mode','var') == 0
    mode = 'pseudorandom';
end

Nt = length(time);
% Nt = 300;
% nslits = 8;
% nrep = 3;
switch mode
    case 'even'
        angles = linspace(0,360,nslits+1)/nrep; angles = angles(1:end-1); ang_t = angles;
    case 'random'
        angles = 360*rand(nslits,1)/nrep; angles = angles'; ang_t = angles;
    case 'pseudorandom'
        step = 360/nslits/nrep;
        for i=1:nslits      
            angles(i) = (i-1)*step + rand(1)*rng*step; ang_t = angles;
        end
end

if(nrep>1)
    for rep = 1:nrep-1
        angles = [angles, ang_t+rep*360/nrep];
    end
end
shifts = Nt*angles/360;
D = zeros(Nt,1);
for i = 1:length(shifts)
    sfloor = floor(shifts(i));
    rest = shifts(i)-sfloor;
    sfloor = sfloor+1;
    D(sfloor) = 1-rest;
    if(sfloor+1==length(D)+1)
        D(1)=rest;
    else
        D(sfloor+1) = rest;
    end
%     D(sfloor)=1;
end
end

