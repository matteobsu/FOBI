function [spectrum] = SpectrumRoi(data,roi,method)
%ROI_SPECTRUM Summary of this function goes here
%   Detailed explanation goes here
if exist('method','var') == 0
    method='median';
end
roi = double(roi);
roi(roi==0)=nan;
data = data.*repmat(roi,[1 1 size(data,3)]);
for i=1:size(data,3)
    a = data(:,:,i);
    if(method=='median') %#ok<ALIGN>
        spectrum(i)=nanmedian(a(:));
    else
    if(method=='mean')
        spectrum(i)=nanmean(a(:));
    end
end
end