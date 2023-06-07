function [spectrum, unc] = SpectrumRoi(data, roi, method)
    if nargin < 3
        method = 'mean';
    end
    
    roi = double(roi);
    roi(roi == 0) = NaN;
    
    maskedData = bsxfun(@times, data, roi);
    
    numChannels = size(data, 3);
    spectrum = zeros(numChannels, 1);
    unc = zeros(numChannels, 1);
    
    for i = 1:numChannels
        a = maskedData(:, :, i);
        validElements = ~isnan(a(:));
        
        if strcmp(method, 'median')
            spectrum(i) = median(a(validElements));
        else
            spectrum(i) = mean(a(validElements));
        end
        
        if nargout==2
        unc(i) = std(a(validElements));
        end
    end
end