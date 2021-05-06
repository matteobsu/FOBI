function [idx] = find_nearest(array,value)
%FIND_NEAREST Summary of this function goes here
%   Detailed explanation goes here
[~,idx] = min(abs(array-value));
end

