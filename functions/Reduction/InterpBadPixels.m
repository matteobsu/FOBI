function [OutI] = InterpBadPixels(I)
%INTERPOLATE_PIXELS Summary of this function goes here
%   Detailed explanation goes here
%  The bad pixel were individually spotted up to 16/05/2021 and neighbor
%  interpolation is applied.
OutI=I;

px=112; py=396;
OutI(px,py,:)=0.25*(I(px-1,py-1,:)+I(px-1,py+1,:)+I(px+1,py-1,:)+I(px+1,py+1,:));
px=230; py=107;
OutI(px,py,:)=0.25*(I(px-1,py-1,:)+I(px-1,py+1,:)+I(px+1,py-1,:)+I(px+1,py+1,:));
px=280; py=187;
OutI(px,py,:)=0.25*(I(px-1,py-1,:)+I(px-1,py+1,:)+I(px+1,py-1,:)+I(px+1,py+1,:));
px=287; py=212;
OutI(px,py,:)=0.25*(I(px-1,py-1,:)+I(px-1,py+1,:)+I(px+1,py-1,:)+I(px+1,py+1,:));
px=298; py=172;
OutI(px,py,:)=0.25*(I(px-1,py-1,:)+I(px-1,py+1,:)+I(px+1,py-1,:)+I(px+1,py+1,:));
px=325; py=314;
OutI(px,py,:)=0.25*(I(px-1,py-1,:)+I(px-1,py+1,:)+I(px+1,py-1,:)+I(px+1,py+1,:));
px=411; py=465;
OutI(px,py,:)=0.25*(I(px-1,py-1,:)+I(px-1,py+1,:)+I(px+1,py-1,:)+I(px+1,py+1,:));
px=487; py=214;
OutI(px,py,:)=0.25*(I(px-1,py-1,:)+I(px-1,py+1,:)+I(px+1,py-1,:)+I(px+1,py+1,:));

end

