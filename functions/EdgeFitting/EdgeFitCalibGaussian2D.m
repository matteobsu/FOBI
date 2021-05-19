function [edge_p,edge_w,edge_h] = EdgeFitGaussian2D(data,spectrum,spectrum_range,C,est_p,est_w,est_h,BC_p,BC_w,BC_h,mask,test)
%EDGEGAUSSIAN Summary of this function goes here
%   Detailed explanation goes here
if exist('radius','var') == 0
    test=0
end
if exist('mask','var') == 0
    mask=ones(s);
end

s = size(data);
edge_p = zeros(s(1),s(2));
edge_w = zeros(s(1),s(2));
edge_h = zeros(s(1),s(2));

if test
    spectrum = C(test(1),test(2),1)+C(test(1),test(2),2)*spectrum;
    EdgeFitGaussian(squeeze(data(test(1),test(2),:)),spectrum,spectrum_range,est_p,est_w,est_h,BC_p,BC_w,BC_h,1);
    return
end

for i=1:s(1)
    disp(['Fitting row:' num2str(i) '/' num2str(s(1))])
    for j=1:s(2)
        if mask(i,j)==1
            spectrum = C(i,j,1)+C(i,j,2)*spectrum;
            [a,b,c] = EdgeFitGaussian(squeeze(data(i,j,:)),spectrum,spectrum_range,est_p,est_w,est_h,BC_p,BC_w,BC_h,0);
            edge_p(i,j) = a;
            edge_w(i,j) = b;
            edge_h(i,j) = c;
        else
            edge_p(i,j) = nan;
            edge_w(i,j) = nan;
            edge_h(i,j) = nan;
        end
    end
end

end