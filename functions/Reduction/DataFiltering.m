function [imageflt] = DataFiltering(image,kernel,kerneltype)
%DATAFILTERING Summary of this function goes here
%   Detailed explanation goes here
if(numel(kernel)==2)
    imageflt=zeros(size(image));
	switch kerneltype
        case 'movingaverage'
            K = ones(kernel(1),kernel(2));
            K = K./sum(K(:));
            for ii=1:size(image,3)
                imageflt(:,:,ii) = conv2(image(:,:,ii),K,'same');
            end
	
        case 'gaussianblur'
            for ii=1:size(image,3)
                imageflt(:,:,ii) = imgaussfilt(image(:,:,ii),kernel);
            end
            
        otherwise
        	disp('Wrong kernel, please select "movingaverage" or "gaussianblur"')
    end
end

if(numel(kernel)==3)
	switch kerneltype
        case 'movingaverage'
            K = ones(kernel(1),kernel(2),kernel(3));
            K = K./sum(K(:));
            imageflt = convn(image,K,'same');
	
        case 'gaussianblur'
            imageflt = imgaussfilt3(image,kernel);
            
        otherwise
        	disp('Wrong kernel, please select "movingaverage" or "gaussianblur"')
    end
end

end

