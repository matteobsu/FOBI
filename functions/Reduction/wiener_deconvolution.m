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
        lf = length(f);
        x = 1:lf;
        K = zeros(lf,1);
        ww = 4;
        if(mod(lf,2)==0)
            x0 = length(x)/2+1;
            width = round(x0/ww);
            K(x0-round(width/2):x0+round(width/2))=1;
        else
            x0 = round(length(x)/2);
            width = round(x0/ww);
            K(x0-round(width/2):x0+round(width/2))=1;
        end
        arg = fftshift(K).*arg;
        
    case 'LowPassBu'
        lf = length(f);
        x = 1:lf;
        K = zeros(lf,1);
        n = 5;
        ww = 5;
        if(mod(lf,2)==0)
            x0 = length(x)/2+1;
            width = round(x0/ww);
            K(x0)=1;
            D = 1:1:(lf-x0);
            HH = 1./(1+(D/width).^(2*n));
            K(x0+1:end)=HH;
            D = 1:1:(x0-1);
            HH = 1./(1+(D/width).^(2*n));
            K(1:x0-1)=fliplr(HH);
        else
            x0 = round(length(x)/2);
            width = round(x0/ww);
            K(x0)=1;
            D = 1:1:(lf-x0);
            HH = 1./(1+(D/width).^(2*n));
            K(x0+1:end)=HH;
            K(1:x0-1)=fliplr(HH);
        end
        
        arg = fftshift(K).*arg;
        
    case 'LowPassGa'
        lf = length(f);
        x = 1:lf;
        K = zeros(lf,1);
        if(mod(lf,2)==0)
            x0 = length(x)/2+1;
            width = round(x0/10);
            K(x0)=1;
            D = 1:1:(lf-x0);
            HH = exp(-(D.^2/(2*width^2)));
            K(x0+1:end)=HH;
            D = 1:1:(x0-1);
            HH = exp(-(D.^2/(2*width^2)));
            K(1:x0-1)=fliplr(HH);
        else
            x0 = round(length(x)/2);
            width = round(x0/10);
            K(x0)=1;
            D = 1:1:(lf-x0);
            HH = exp(-(D.^2/(2*width^2)));
            K(x0+1:end)=HH;
            K(1:x0-1)=fliplr(HH);
        end
        
        arg = fftshift(K).*arg;
        
    case 'none'
    otherwise
        disp('WARNING: Unrecognized filter, set to none')
end

H = real(ifft(arg));
end