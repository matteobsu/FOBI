function [Trec_merged,yrec_merged,y0rec_merged,t_merged] = FobiWiener(y,y0,t,tmax,nrep,c,flag_smooth,roll)
%FULL_FOB_REDUCTION Summary of this function goes here
%   Detailed explanation goes here

if nargin<8
    roll=0;
    if nargin<7
        flag_smooth=0;
        if(nargin<6)
            c = 0.1;
        end
    end
end

[y,tn] = interpolate_noreadoutgaps(y,t,tmax,nrep,0);
[y0,tn] = interpolate_noreadoutgaps(y0,t,tmax,nrep,0);
%% choose time delays
% D = FobiPoldiTimeDelays(tn);
% D = Fobi4x10TimeDelays(tn);
D = Fobi5x8TimeDelays(tn);
%%
if(flag_smooth)
    y = smooth(y);
    y0 = smooth(y0);
end

y0rec = wiener_deconvolution(y0,D,c);
yrec = wiener_deconvolution(y,D,c);
Trec = yrec./y0rec;

replen = length(y)/nrep;
for i=1:nrep
    yover(:,i) = yrec(replen*(i-1)+1:replen*i);
    y0over(:,i) = y0rec(replen*(i-1)+1:replen*i);
    Tover(:,i) = Trec(replen*(i-1)+1:replen*i);
end
yrec_merged = nanmean(yover,2);
y0rec_merged = nanmean(y0over,2);
Trec_merged = nanmean(Tover,2);

yrec_merged = circshift(yrec_merged,roll);
y0rec_merged = circshift(y0rec_merged,roll);
Trec_merged = circshift(Trec_merged,roll);

t_merged = tn(1:replen);
end

