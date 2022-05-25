function [H] = wiener_deconvolution(f,g,c,filter)
%WIENER_DECONVOLUTION Summary of this function goes here
%   Detailed explanation goes here
if(nargin<4)
    filter = 'none';
    if(nargin<3)
        c = 1e-2;
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

%complexplot((F)); 
% complexplot((G));
% complexplot(arg);
% complexplot(fftshift(arg));
%%
switch filter
    case 'central' 
        x = 1:length(f);
        K = fftshift((1./(0.006*abs(x-length(x)/2))))';
        K(end) = 0.5*K(end-1)+0.5*K(1); 
        figure, plot(K)
        arg = K.*arg;
    case 'centralinverse' 
        x = 1:length(f);
        K = fftshift((1-1./abs(x-length(x)/2)))';
        K(end) = 0.5*K(end-1)+0.5*K(1); 
        figure, plot(K)
        arg = K.*arg;
    case 'none'
    otherwise
        disp('WARNING: Unrecognized filter, set to none')
end

%% inverting results
% nfft = length(f);
% nfft = 2^(nextpow2(length(f))-1);
% H = ifft(arg,nfft);

H = ifft(arg);

% H = ifft(F./(G + c));
% H = ifft(conj(F).*G./(abs(G).^2 + c));
% H = ifft(F.*conj(G)./(abs(G).^2 + c));
% H = ifft(conj(F.*G)./(abs(G).^2 + c));
end

