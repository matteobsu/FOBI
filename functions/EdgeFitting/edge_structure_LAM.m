function edge_struct=edge_structure_LAM(material,guess,MULTI_group,varargin)


 for i=1:2:length(varargin)
name=varargin{i};
value=varargin{i+1};
switch name
    case 'tau'
        tau=value;
    
    case 'fwhm' 
        fwhm=value;
end
 
         
end
    
  
       if ~exist('tau','var')
          tau=10;
       end  
          if ~exist('fwhm','var')
          fwhm=10;
       end   
       
  

a2=sprintf(material,'%s.mat');
load(['C:\Users\malamud_f\Documents\MATLAB\samples\' a2]);
%% Create the peaks_struct 



peaks_struct.MULTI_group_peaks=MULTI_group; %{ [1] [2] [3] [4] [5] [6] [7] [8] [9]};
 
 n1=0;
 for igroup=1:length(peaks_struct.MULTI_group_peaks);
  
    peaks=peaks_struct.MULTI_group_peaks{igroup}; 
    n1=n1+1;
    for ii=1:size(peaks,2)
         peaks_struct.lam(peaks(ii))=2*hkl.d(peaks(ii));    
peaks_struct.tof(peaks(ii))=guess.cen(n1);%2*hkl.d(i).*a;
peaks_struct.h(peaks(ii))=hkl.h(peaks(ii));
peaks_struct.k(peaks(ii))=hkl.k(peaks(ii));
peaks_struct.l(peaks(ii))=hkl.l(peaks(ii));
    lam=peaks_struct.lam(peaks(ii)); %Longitud de onda con d=cen0
    peaks_struct.tau(peaks(ii))=tau;%0.01;%*tau_IMAT(lam);               %Valor de tau correspondiente a lamda
     peaks_struct.fwhm(peaks(ii))=fwhm;%0.01;%*tau_IMAT(lam);  
     peaks_struct.ancho(peaks(ii))=peaks_struct.tau(peaks(ii))+peaks_struct.fwhm(peaks(ii));

        peaks_struct.dx(peaks(ii),1)=guess.xmin(n1);
          peaks_struct.dx(peaks(ii),2)=guess.xmax(n1);
 
    end
 end


 edge_struct=peaks_struct;
end