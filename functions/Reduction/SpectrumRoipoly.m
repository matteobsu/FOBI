function [spectrum] = SpectrumRoipoly(I,cax)
%SPECTRUMROIPOLY Summary of this function goes here
%   Detailed explanation goes here
if exist('cax','var') == 0
    cax = 0;
end
figure, imagesc(nanmean(I,3)), 
if(~isempty(cax))
    caxis(cax)
end

roi = roipoly;
spectrum = SpectrumRoi(I,roi);
end

