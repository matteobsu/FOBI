function [data_reduced] = multiVS_reduction(data,t,tmax,nrep)
[n,m] = size(data);
data_reduced = zeros(n,m);
for i = 1:n
    for j = 1:m
        data_reduced(i,j) = multiVS_reduction_1d(squeeze(data(i,j,:)),t,tmax,nrep,0);
    end
end
end