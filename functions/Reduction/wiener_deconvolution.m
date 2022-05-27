function [H] = wiener_deconvolution(f,g,c,filter)
%WIENER_DECONVOLUTION Summary of this function goes here
%   Detailed explanation goes here
if(nargin<4)
    filter = 'none';
    if(nargin<3)
        c = 1e-1;
    end
end
f = squeeze(f); g = squeeze(g);
if(size(f,2)>1)
    f=f';
end
if(size(g,2)>1)
    g=g';
end

%% Correlation theorem
F = fft(f); 
G = fft(g); 

arg = F.*conj(G)./((abs(G).^2)+c);  

% complexplot(fftshift(arg));
%%
switch filter
    case 'LowPass' 
        x = 1:length(f);
        x0 = length(x)/2+1;
        width = round(x0/4);
        K = zeros(length(F),1);
        K(x0-round(width/2):x0+round(width/2))=1;
        arg = fftshift(K).*arg;
    case 'LowPassBu' 
        x = 1:length(f);
        x0 = length(x)/2+1;
        width = round(x0/5);
        n = 5;
        K = zeros(length(F),1);
        D = 1:1:(length(f)-x0);
        HH = 1./(1+(D/width).^(2*n));
        K(x0)=1;
        K(x0+1:end)=HH;
        D = 1:1:(x0-1);
        HH = 1./(1+(D/width).^(2*n));
        K(1:x0-1)=fliplr(HH);
        arg = fftshift(K).*arg;
    case 'LowPassGa' 
        x = 1:length(f);
        x0 = length(x)/2+1;
        K = zeros(length(F),1);
        D = 1:1:(length(f)-x0);
        HH = exp(-(D.^2/(2*width^2)));
        K(x0)=1;
        K(x0+1:end)=HH;
        D = 1:1:(x0-1);
        HH = exp(-(D.^2/(2*width^2)));
        K(1:x0-1)=fliplr(HH);

        arg = fftshift(K).*arg;
    case 'none'
    otherwise
        disp('WARNING: Unrecognized filter, set to none')
end


H = ifft(arg);
end

