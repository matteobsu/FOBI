function [H] = wiener_deconvolution(f,g,c)
%WIENER_DECONVOLUTION Summary of this function goes here
%   Detailed explanation goes here
%   Detailed explanation goes here
if(nargin<4)
    filter = 'none';
    if(nargin<3)
        c = 1e-2;
    end
end
switch filter
    case 'central' 
        x = 1:length(f);
        K = fftshift((1./(0.006*abs(x-length(x)/2))))';
        K(end) = 0.5*K(end-1)+0.5*K(1); 
        figure, plot(K)
    case 'centralinverse' 
        x = 1:length(f);
        K = fftshift((1-1./abs(x-length(x)/2)))';
        K(end) = 0.5*K(end-1)+0.5*K(1); 
        figure, plot(K)
    case 'none'
        K = squeeze(ones(length(f),1));
    otherwise
        disp('WARNING: Unrecognized filter, set to none')
        K = squeeze(ones(length(f),1));
end
f = squeeze(f); g = squeeze(g);
if(size(f,2)>1)
    f=f';
end
if(size(g,2)>1)
    g=g';
end
% Correlation theorem
F = fft(f); 
G = fft(g); 
arg = F.*conj(G)./((abs(G).^2)+c); 

%complexplot(fftshift(F)); 
%complexplot(fftshift(G));
%complexplot(arg);

%% applying filter
arg = K.*arg; 
%complexplot(arg);

%% inverting results
H = ifft(arg);

% H = ifft(F./(G + c));
% H = ifft(conj(F).*G./(abs(G).^2 + c));
% H = ifft(F.*conj(G)./(abs(G).^2 + c));
% H = ifft(conj(F.*G)./(abs(G).^2 + c));

end

