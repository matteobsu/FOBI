function vol=readtiffstack(filemask,index,ext)
% vol=readtiffstack(filemask,index)
% Inputs:
% filemask - full file mask (including path, base file name, and extension)
% index    - vector containing file indices
%
% Output:
% vol      - the volume
%

if (nargin<3)
    ext='.tif';
end

img=ReadImg(filemask,index(1),ext);
dims=size(img);
dims(3)=length(index);
vol=single(zeros(dims));
h=waitbar(0,'Reading tiff images');
   
vol(:,:,1)=img;
for i=2:length(index)
    waitbar(i/length(index));
    vol(:,:,i)=ReadImg(filemask,index(i),ext);
end

close(h);

    
function img=ReadImg(filemask,ind,ext)
if ind<10
    filename=[filemask '000' num2str(ind) ext];
else
    if ind<100
        filename=[filemask '00' num2str(ind) ext];
    else
        if ind<1000
            filename=[filemask '0' num2str(ind) ext];
        else 
            filename=[filemask num2str(ind) ext];
        end
    end
end

img=single(imread(filename));
if (2<ndims(img))
    img=mean(img,3);
end
    