function [mask] = MaskRoipoly(I,I0)
%MASKROIPOLY Summary of this function goes here
%   Detailed explanation goes here
figure, imagesc(nanmean(I,3)./nanmean(I0,3)), title('Transmission Image')
mask = roipoly; 
end

