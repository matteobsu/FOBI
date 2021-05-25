function [imageout] = DataResize(image,binning)
%DATAFILTERING Summary of this function goes here
%   Detailed explanation goes here
s = size(image);
ms = max(s(1:2));
scale = (ms/binning)/ms;
if(length(size(image)==2)) %#ok<SZARLOG,ISMT>
    imageout=imresize(image,scale,'nearest');
end

if(length(size(image)==3)) %#ok<*ISMT,*SZARLOG>
%     imageout = zeros(s(1),s(2),s(3));
	for i=1:size(image,3) %#ok<*ALIGN>
        imageout(:,:,i) = imresize(image(:,:,i),scale,'bicubic');
    end
end

end

