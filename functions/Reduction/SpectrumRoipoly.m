function [spectrum] = SpectrumRoipoly(I)
%SPECTRUMROIPOLY Summary of this function goes here
%   Detailed explanation goes here
figure, imagesc(nanmean(I,3))
roi = roipoly;
spectrum = SpectrumRoi(I,roi);
end

