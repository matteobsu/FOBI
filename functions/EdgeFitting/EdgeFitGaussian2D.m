function [edge_p,edge_w,edge_h] = EdgeFitGaussian2D(data,spectrum,spectrum_range,est_p,est_w,est_h,BC_p,BC_w,BC_h,mask)
%EDGEGAUSSIAN Summary of this function goes here
%   Detailed explanation goes here
s = size(data);

if(nargin<10)
    mask=ones(s);
end
edge_p = zeros(s(1),s(2));
edge_w = zeros(s(1),s(2));
edge_h = zeros(s(1),s(2));

for i=1:s(1)
    disp(['Fitting row:' num2str(i) '/' num2str(s(1))])
    for j=1:s(2)
        if(mask(i,j)==1)
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