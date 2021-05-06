function [pImage] = PolarImage(image)
%POLARIMAGE Summary of this function goes here
%   Detailed explanation goes here
pImage = zeros(size(image));

[nx,ny] = size(image);
xx = linspace(-(nx-1)/2,(nx-1)/2,nx);
xx = repmat(xx',[1 ny]);
yy = linspace(-(ny-1)/2,(ny-1)/2,ny);
yy = repmat(yy,[nx 1]);

r = sqrt(xx.^2+yy.^2);
rho = atan2(yy,xx);
ur = unique(r);
urho = unique(rho);
rbins = linspace(min(ur),max(ur),nx);
rhobins = linspace(min(urho),max(urho),ny);
for ii=1:length(rbins)
    for jj=1:length(rhobins)
        if (ii==length(rbins))
            if (ii==length(rbins) && jj == length(rhobins))
                pImage(ii,jj) = sum(image(rho>rhobins(jj) & r>=rbins(ii)));
            else
                pImage(ii,jj) = sum(image(rho>rhobins(jj) & rho<=rhobins(jj+1) & r>rbins(ii)));
            end
        else
            if (jj==length(rbins))
            pImage(ii,jj) = sum(image(rho>=rhobins(jj) & r>=rbins(ii) & r<rbins(ii+1)));
            else
                pImage(ii,jj) = sum(image(rho>=rhobins(jj) & rho<rhobins(jj+1) & r>=rbins(ii) & r<rbins(ii+1)));
            end
        end
    end
end      
        
% end

