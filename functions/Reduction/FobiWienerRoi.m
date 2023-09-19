function [Trec_merged,yrec_merged,y0rec_merged,t_merged] = FobiWienerRoi(I,I0,t,tmax,nrep,ChopperId,c,filter,roll,roi,flag_smooth)
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
if exist('filter','var') == 0
    filter = 'none';
end

y0 = SpectrumRoi(I0,roi);
y = SpectrumRoi(I,roi);

if(flag_smooth)
    sp = 3;
    y = smooth(y,sp);
    y0 = smooth(y0,sp);
end

pr = 0;
[y0,t_merged] = interpolate_noreadoutgaps(y0,t,tmax,nrep,pr);
[y,~] = interpolate_noreadoutgaps(y,t,tmax,nrep,pr);

%% choose time delays
    switch ChopperId
    case 'POLDI'
        D = FobiPoldiTimeDelays(t_merged);
        nslits = 8;
    case '4x10'
        D = Fobi4x10TimeDelays(t_merged);
        nslits = 10;
    case '5x8'
        D = Fobi5x8TimeDelays(t_merged);
        nslits = 8;
    case '3x14'
        D = Fobi3x14TimeDelays(t_merged);
        nslits = 14;
    otherwise 
        disp('Please select chopper')
end
%%

yrec = nslits*nrep*wiener_deconvolution(y,D,c,filter);
y0rec = nslits*nrep*wiener_deconvolution(y0,D,c,filter);
% Trec = yrec./y0rec; %direct T deconvolution seems to give heigher edges
Trec = nslits.*wiener_deconvolution(y./y0,D,c,filter);

% figure, plot(Trec)

yrec_merged = circshift(yrec,roll);
y0rec_merged = circshift(y0rec,roll);
Trec_merged = circshift(Trec,roll);

figure(888),
subplot(2,1,1), plot(t_merged,y0rec_merged), hold on, plot(t_merged,yrec_merged),
legend('Open beam','Sample')
subplot(2,1,2), plot(t_merged,Trec_merged),
legend('Transmission'), grid
end

