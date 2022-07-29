function [edge_p,edge_w,edge_h,lor_p,lor_g] = EdgeFitVoigt2D(data,spectrum,spectrum_range,est_p,est_w,est_h,est_p2,est_g,BC_p,BC_w,BC_h,BC_p2,BC_gamma,mask,test)
    %EDGEGAUSSIAN Summary of this function goes here
    %   Detailed explanation goes here
    s = size(data);
    if exist('test','var') == 0
        test=0;
    end
    if exist('mask','var') == 0
        mask=ones(s);
    end
    
    edge_p = zeros(s(1),s(2));
    edge_w = zeros(s(1),s(2));
    edge_h = zeros(s(1),s(2));
    lor_p = zeros(s(1),s(2));
    lor_g = zeros(s(1),s(2));
    
    if test
        [p,w,h,lp,lg]=EdgeFitVoigt(squeeze(data(test(1),test(2),:)),spectrum,spectrum_range,est_p,est_w,est_h,est_p2,est_g,BC_p,BC_w,BC_h,BC_p2,BC_gamma,0,1)
        return
    end
    
    for i=1:s(1)
        disp(['Fitting row:' num2str(i) '/' num2str(s(1))])
        for j=1:s(2)
            if mask(i,j)==1
                [a,b,c,d,e] = EdgeFitVoigt(squeeze(data(i,j,:)),spectrum,spectrum_range,est_p,est_w,est_h,est_p2,est_g,BC_p,BC_w,BC_h,BC_p2,BC_gamma,0,0);
                edge_p(i,j) = a;
                edge_w(i,j) = b;
                edge_h(i,j) = c;
                lor_p(i,j) = d;
                lor_g(i,j) = e;
            else
                edge_p(i,j) = nan;
                edge_w(i,j) = nan;
                edge_h(i,j) = nan;
                lor_p(i,j) = nan;
                lor_g(i,j) = nan;
            end
%             pause()
        end
    end
    
    end