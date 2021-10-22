


MULTIGROUP_Edge.cen= [4.169 ]; % center in LAM or TOF
MULTIGROUP_Edge.xmax=[4.37 ]; % interval for the fitting
MULTIGROUP_Edge.xmin=[4.08 ];
MULTI_group={ [1]};
                                                                   
edge_struct_fe_lam1=edge_structure_LAM(MULTIGROUP_Edge,MULTI_group,'tau',0.005,'fwhm',0.005);



spectra.y=y_Tr;
spectra.lam=lam;

fit_ed(k).fit1=fit_edges_gauss(spectra,edge_struct_fe_lam1,'plot_fits',0,'lim',[4.1 4.2]); 