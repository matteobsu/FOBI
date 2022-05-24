function [Trec_merged,yrec_merged,y0rec_merged,t_merged] = FobiWienerRoi(I,I0,t,tmax,nrep,ChopperId,c,flag_smooth,roll,roi)
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

y0 = SpectrumRoi(I0,roi);
y = SpectrumRoi(I,roi);
[y,~] = interpolate_noreadoutgaps(y,t,tmax,nrep,0);
[y0,tn] = interpolate_noreadoutgaps(y0,t,tmax,nrep,0);
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
if(flag_smooth)
    y = smooth(y);
    y0 = smooth(y0);
end

y0rec = wiener_deconvolution(y0,D,c);
yrec = wiener_deconvolution(y,D,c);
% Trec =  wiener_deconvolution(y./y0,D,c);

% l0 = size(y0,1);
% l1 = size(y0rec,1);
% 
% y0rec = imresize(y0rec,l0/l1);
% yrec = imresize(yrec,l0/l1);

Trec = yrec./y0rec;

replen = length(y0rec)/nrep;
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

figure(888),
subplot(2,1,1), plot(t_merged,y0rec_merged), hold on, plot(t_merged,yrec_merged),
legend('Open beam','Sample')
subplot(2,1,2), plot(t_merged,Trec_merged),
legend('Transmission')
end

