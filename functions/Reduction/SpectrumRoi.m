function [spectrum] = SpectrumRoi(data,roi)
%ROI_SPECTRUM Summary of this function goes here
%   Detailed explanation goes here
roi = double(roi);
roi(roi==0)=nan;
data = data.*repmat(roi,[1 1 size(data,3)]);
for i=1:size(data,3)
    a = data(:,:,i);
    spectrum(i)=nanmean(a(:));
end
end