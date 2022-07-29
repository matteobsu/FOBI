function [pos,wid,h,pos2,gamma] = EdgeFitVoigt(signal,spectrum,spectrum_range,est_p,est_w,est_h,est_p2,est_g,BC_p,BC_w,BC_h,BC_p2,BC_gamma,flag_smooth,pr)
%EDGEGAUSSIAN Summary of this function goes here
%   Detailed explanation goes here
if(nargin<10)
    flag_smooth=1;
end
if(nargin<11)
    pr=0;
end
%% prepare data
d_spectrum = spectrum(1:end-1);
if(pr)
    figure(997), plot(spectrum,signal),
end
if(flag_smooth)
    signal = smooth(signal);
end
if(pr)
    figure(997),hold on, plot(spectrum,signal), grid
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
fitfun = fittype( @(a1,b1,c1,b2,gamma,m,q,x) a1*exp(-((x-b1)/c1).^2)+gamma./((x-b2).^2+gamma.^2)+m*x+q); 
x0 = [est_h est_p est_w est_p2 est_g 0 0];
L = [BC_h(1) BC_p(1) BC_w(1) BC_p2(1) BC_gamma(1) -inf -inf];
U = [BC_h(2) BC_p(2) BC_w(2) BC_p2(2) BC_gamma(2) +inf +inf];
% 2nd order poly bkg
% fitfun = fittype( @(a1,b1,c1,p,m,q,x) a1*exp(-((x-b1)/c1).^2)+p*x.^2+m*x+q); 
% x0 = [est_h est_p est_w 0 0 0];
% L = [BC_h(1) BC_p(1) BC_w(1) -inf -inf -inf];
% U = [BC_h(2) BC_p(2) BC_w(2) +inf +inf +inf];

%% fit
[f,gof] = fit(x',y',fitfun,'StartPoint',x0,'Lower',L,'Upper',U);
if(pr)
    figure(996), plot(f,x,y), grid
end
pos = f.b1;
wid = f.c1;
h = f.a1;
off = f.q;
slo = f.m;
pos2 = f.b2;
gamma = f.gamma;

end

