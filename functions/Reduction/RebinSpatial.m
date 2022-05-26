function data_out = RebinSpatial(data_in,rows,columns,flag_mf)
Nx = size(data_in,1);
Ny = size(data_in,2);
Nx_out = floor(Nx/rows);
Ny_out = floor(Ny/columns);

data_out = zeros(Nx_out,Ny_out,size(data_in,3));
data_mf = zeros(size(data_in));

% to get rid of bad pixels
if(flag_mf)
    for kk =1:size(data_in,3)
        data_mf(:,:,kk) = medfilt2(data_in(:,:,kk),[3 3],'symmetric');
    end
else
    data_mf=data_in;
end

if(rows>1 || columns>1)
    ii=0;
    jj=0;
    for i = 1:Nx_out
        ii=ii+1;
        for j = 1:Ny_out
            jj=jj+1;
            window = data_mf((i-1)*rows+1:i*rows,(j-1)*columns+1:j*columns,:);
            data_out(i,j,:) = nanmean(nanmean(window,2),1);
        end
    end
else
    data_out=data_mf;
end
end