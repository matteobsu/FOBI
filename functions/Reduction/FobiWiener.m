function [Trec_merged,yrec_merged,y0rec_merged,t_merged] = FobiWiener(y,y0,t,tmax,nrep,ChopperId,c,flag_smooth,roll)
%FULL_FOB_REDUCTION Summary of this function goes here
%   Detailed explanation goes here
if exist('roll','var') == 0
    roll=0;
end
if exist('flag_smooth','var') == 0
    flag_smooth=0;
end
if exist('c','var') == 0
    c = 0.1;
end

if(flag_smooth)
    y = smooth(y);
    y0 = smooth(y0);
end

pr = 0;
[y0,tn] = interpolate_noreadoutgaps(y0,t,tmax,nrep,pr);
[y,~] = interpolate_noreadoutgaps(y,t,tmax,nrep,pr);
%% choose time delays
switch ChopperId
    case 'POLDI'
        D = FobiPoldiTimeDelays(tn);
    case '4x10'
        D = Fobi4x10TimeDelays(tn);
    case '5x8'
        D = Fobi5x8TimeDelays(tn);
    otherwise 
        disp('Please select chopper')
end
%%

y0rec = wiener_deconvolution(y0,D,c);
yrec = wiener_deconvolution(y,D,c);
% Trec = yrec./y0rec;
Trec = wiener_deconvolution(y./y0rec,D,c);

replen = length(y)/nrep;

yrec_merged = circshift(yrec(1:replen),roll);
y0rec_merged = circshift(y0rec(1:replen),roll);
Trec_merged = circshift(Trec(1:replen),roll);

t_merged = tn(1:replen);
end

