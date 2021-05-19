function [pos,wid,h] = EdgeFitGaussian(signal,spectrum,spectrum_range,est_p,est_w,est_h,BC_p,BC_w,BC_h,pr)
%EDGEGAUSSIAN Summary of this function goes here
%   Detailed explanation goes here
if exist('pr','var') == 0
    pr=0;
end
%% prepare data
d_spectrum = spectrum(1:end-1);
d_signal = smooth(diff(signal));
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
options = fitoptions('gauss1');
options.Lower = [BC_h(1),BC_p(1),BC_w(1)];
options.Upper = [BC_h(2),BC_p(2),BC_w(2)];
options.StartPoint = [est_h,est_p,est_w];

%% fit
f = fit(x.',y.','gauss1',options);
if(pr)
    figure, 
    subplot(2,1,1), plot(f,x,y)
    subplot(2,1,2), plot(x,signal(find_nearest(d_spectrum,spectrum_range(1)):find_nearest(d_spectrum,spectrum_range(2))))
end
pos = f.b1;
wid = f.c1;
h = f.a1;

end

