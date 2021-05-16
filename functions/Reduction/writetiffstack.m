function writetiffstack(img,filemask,bits)
%
% Writes a 3D image as a sequence of tiff images
%
% usage:
% writetiffstack(img,filemask)
%
% inputs:
% img - the image to write
% filemask - mask for the file name generation including path
%
% $Author: kaestner $
% $Date: 2011-01-21 16:20:35 +0100 (Fri, 21 Jan 2011) $
% $Revision: 832 $
%

if (nargin<3)
    bits='float';
end
index=1:size(img,3);
hi=max(img(:));
lo=min(img(:));
for i=index
    if (i<10)
        fname=[filemask '000' num2str(i) '.tif'];
    else if (i<100)
            fname=[filemask '00' num2str(i) '.tif'];
        else if (i<1000)
                fname=[filemask '0' num2str(i) '.tif'];
            else
                fname=[filemask num2str(i) '.tif'];
            end
        end
    end
    
    if (bits==8)
        imwrite((img(:,:,i)-lo)./(hi-lo), fname);
    end
    if (bits==16)
        imwrite(uint16(65535*(img(:,:,i)-lo)./(hi-lo)), fname);
    end
    if (bits=='float')
        writefloattif(img(:,:,i), fname);
    end    
end

        