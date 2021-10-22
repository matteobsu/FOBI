function F = edge_neutron_TOF_gaussian(p,t)


% INPUT
% p: DOUBLE(7), parameter values

% t: DOUBLE(npts,1), t en  Neutron time-of-flight data points
% 
% p(1)=a_left   ordinate of line for TOF < t_0
% p(2)=b_left  slope of line for TOF < t_0
% p(3)=a_right  ordinate of line for TOF > t_0
% p(4)=b_right  slope of line for TOF > t_0
% p(5)= t0=   Bragg edge position
% p(6)=sigma    ; symmetric (gaussian) broadening of the edge



% OUTPUT
% F: DOUBLE(npts), function values

% COMMENTS
% Can be called from SUMFUN1 for LSQ fitting
%


t = t(:);
a_left=p(1);
b_left=p(2);
a_right=p(3);
b_right=p(4);
t0=p(5);
sig=p(6);



tr_left=(a_left*t+b_left);
tr_right=(b_right+a_right*t);


x_sig=-(t-t0)./(sqrt(2)*sig);
b=.5*(erfc(x_sig));%-exp(x_tau+(.5*sig_tau^2)).*erfc(x_sig+sig_tau));
F=tr_right.*b+tr_left.*(1-b);
end

