function [pos,wid,h] = EdgeFitGaussOffset(signal,spectrum,spectrum_range,est_p,est_w,est_h,BC_p,BC_w,BC_h,smooth_span,pr)
%EDGEGAUSSIAN Summary of this function goes here
%   Detailed explanation goes here
if exist('pr','var') == 0
    pr=0;
end
if exist('smooth_span','var') == 0
    smooth_span=5;
end
%% prepare data
d_spectrum = spectrum(1:end-1);
if(pr)
    figure(998), plot(spectrum,signal),
end
if(smooth_span)
    signal = smooth(signal,smooth_span,'sgolay');
end
if(pr)
    figure(998), hold on, plot(spectrum,signal), grid
end

% d_signal = smooth(diff(signal));
d_signal = diff(signal);
x = d_spectrum(find_nearest(d_spectrum,spectrum_range(1)):find_nearest(d_spectrum,spectrum_range(2)));
y = d_signal(find_nearest(d_spectrum,spectrum_range(1)):find_nearest(d_spectrum,spectrum_range(2)));
x = squeeze(x)';
y = squeeze(y)';
if(size(x,2)==1)
    x=x';
end
if(size(y,2)==1)
    y=y;
end
y(isnan(y))=1;
%% initial guess and BCs
% 1st order poly bkg
fitfun = fittype( @(a1,b1,c1,m,q,x) a1*exp(-((x-b1)/c1).^2)+m*x+q); 
x0 = [est_h est_p est_w 0 0];
L = [BC_h(1) BC_p(1) BC_w(1) -inf -inf];
U = [BC_h(2) BC_p(2) BC_w(2) +inf +inf];
% 2nd order poly bkg
% fitfun = fittype( @(a1,b1,c1,p,m,q,x) a1*exp(-((x-b1)/c1).^2)+p*x.^2+m*x+q); 
% x0 = [est_h est_p est_w 0 0 0];
% L = [BC_h(1) BC_p(1) BC_w(1) -inf -inf -inf];
% U = [BC_h(2) BC_p(2) BC_w(2) +inf +inf +inf];

%% fit
[f,gof] = fit(x',y',fitfun,'StartPoint',x0,'Lower',L,'Upper',U);
if(pr)
    figure(999), plot(f,x,y), grid
end
pos = f.b1;
wid = f.c1;
h = f.a1;
off = f.q;
slo = f.m;

end

