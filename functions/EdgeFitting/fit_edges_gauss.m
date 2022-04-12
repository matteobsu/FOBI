

function fit_res=fit_edges_gauss(spectra,peaks_struct,npoints,pause_fl,varargin)
%%

x1=spectra.lam(:);
y1=spectra.y(:);

for i=1:2:length(varargin)
    name=varargin{i};
    value=varargin{i+1};
    switch name
        case 'plot_fits'
            plot_fits=value;
            
        case 'lim'
            lim=value;
            
    end
end


if ~exist('plot_fits','var')
    plot_fits=0;
end



maxdrift_d=0.01; %half the maximum range in d to find the y max (keep tight as possible!)


% fit MULTI PV simultaneously
%Optimización
opt = optimset('disp','off','large','on','jacobi','off','tolx',1e-6,'tolf',1e-6,'maxi',10000);
slguess=0;  %some guesses - first peaks are broader
%%
% aa=1.07;
N1=0;

BB = find(strcmp(varargin, 'BG'));

if (~isempty(BB)) && (~isempty(varargin{BB+1}))
    
    BG=varargin{BB+1};
    
    
    x_bg=[];
    y_bg=[];
    for l=1:size(BG,1)
        kk1=find(x1>=BG(l,1) & x1<=BG(l,2));
        
        x_bg=[x_bg x1(kk1)];
        y_bg=[y_bg y1(kk1)];
        
        clear kk1;
    end
    
    [pback_pars,s,mu]=polyfit(x_bg,y_bg,4); % 1st order polynomial (linear) background fit
    pback_norm=polyval(pback_pars,x1,[],mu);
else
    pback_norm=0*ones(length(x1),1)';
end

y_norm1=y1-pback_norm;



n1=0;
cc=0;
clear ancho pico_ancho d_ancho pico_d_anch peakintV pico_area d_peakintV pico_d_are centerV pico_centro d_centerV pico_d_centro  pfit_v(:,:)=[pfit0(:) pfit1(:) pfit2(:)];
MULTI_group_peaks=peaks_struct.MULTI_group_peaks;
for igroup=1:length(MULTI_group_peaks);
    clear yfitV peaks peakintV centerV
    clear rs_v jac_v rn_v pfit  rs jac  p0_v p0f
    peaks=MULTI_group_peaks{igroup};
    
    
    for ii=1:size(peaks,2)
        n1=n1+1;%size(pp,2);
        i=peaks(ii);
        cen0(i)=peaks_struct.tof(i);
        c(i)=peaks_struct.tau(i);
        fwhmguessV(i)=peaks_struct.fwhm(i);
        ddd_min(i)=peaks_struct.dx(i,1);
        ddd_max(i)=peaks_struct.dx(i,2);
        
        % dx_int=peaks_struct.dx;
        %
        %
        %            ddd_min=dx_int(igroup,1);
        %           ddd_max=dx_int(igroup,2);
    end
    
    
    
    
    %Fitea el Bg con un polinomio de grado 1
    npar= [];
    fn = {};
    
    
    for i=1:size(peaks,2)
        npar= [npar 6];
        fn = [fn 'edge_neutron_TOF_gaussian'];
        
    end
    
    % %Busca si los picos que le pido quedan dentro del espectro, si estan
    % fitea sino coloca NaN en sigma, en el area y en la posición de ese pico
    for i=1:size(peaks,2)
        
        
        dmin=min(min(x1));
        dmax=max(max(x1));
        %if dmin<= ddd_min((peaks(i))) &  dmax>=ddd_max((peaks(i)));
        
        %Busca los datos que le corresponden en x e yraw
        k=find(x1>ddd_min((peaks(i))) & x1<ddd_max((peaks(i)))); %Encuentra los indices
        x = x1(k)';
        yraw=y_norm1(k)';
        
        Nx=length(x);
        %    ii=find(x<cen0(peaks(i))+10*c(peaks(i)) & x>cen0(peaks(i))-10*c(peaks(i)));
        ii=find(x<cen0(peaks(i))+5*c(peaks(i)) & x>cen0(peaks(i))-5*c(peaks(i)));
        i_1=max(ii);
        i_2=min(ii);
        
        ancho=x(i_1)-x(i_2);
        sigma1=ancho(1)/2;
        
        
        %j=find(x<x(i_2)+sigma1/2);
        
        j=[find(x==min(x)):find(x==min(x))+npoints]; %%!!!!!!!!!!!!! number of pints
        %j=[find(x==min(x)):find(x==min(x))+6];
        xleft=x(j);
        yleft=yraw(j); %x,y values to use for background determination
        [pback_left]=polyfit(xleft,yleft,1);
        a_left=pback_left(1);
        b_left=pback_left(2);
        %  k=find(x>x(i_1)-sigma1/2);
        
        
        k=[find(x==max(x))-npoints:find(x==max(x))];  %%!!!!!!!!!!!!! number of pints
        
        % 1st order polynomial (linear) background fit
        Nk=length(k);
        xright=x(k);
        yright=yraw(k); %x,y values to use for background determination
        [pback_right]=polyfit(xright,yright,1); % 1st order polynomial (linear) background fit
        a_right=pback_right(1);
        b_right=pback_right(2);
        
        y_r=pback_right(1)*x+pback_right(2);
        y_l=pback_left(1)*x+pback_left(2);
        
        
        
        Tr_r_xmax=pback_right(1)*x(round((i_1-i_2)/2))+pback_right(2);
        Tr_l_xmax=pback_left(1)*x(round((i_1-i_2)/2))+pback_left(2);
        H_xmax(peaks(i))=Tr_r_xmax-Tr_l_xmax;
        
        
        Tr_r=pback_right(1)*cen0(peaks(i))+pback_right(2);
        Tr_l=pback_left(1)*cen0(peaks(i))+pback_left(2);
        H(peaks(i))=Tr_r-Tr_l;
        Tr_left(peaks(i))=Tr_l;
        Tr_right(peaks(i))=Tr_r;
        
        a_left(peaks(i))=pback_left(2);
        a_right(peaks(i))=pback_right(2);
        b_left(peaks(i))=pback_left(1);
        b_right(peaks(i))=pback_right(1);
        %      else
        %     for i=1:size(peaks,2)
        %            pico_pos(peaks(i))=0;
        %          pico_d_pos(peaks(i))=0;
        %          pico_ancho(peaks(i))=0;
        %          pico_d_ancho(peaks(i))=0;
        %          pico_alto(peaks(i))=0;
        %           pico_Tr_left(peaks(i))=0;
        %          pico_Tr_right(peaks(i))=0;
        %
        %
        %
        %            pico_a_left(peaks(i))=0;
        %       pico_b_left(peaks(i))=0;
        %       pico_a_right(peaks(i))=0;
        %       pico_b_right(peaks(i))=0;
        %          end;
        % end
        for i=1:length(x);
            if i<i_2
                x_plot(i)=x(i);
                y_plot(i)=y_l(i);
            else
                x_plot(i)=x(i);
                y_plot(i)=y_r(i);
            end
        end
        %  if plot_H==1;
        %     figure(50);
        %     plot(x,y,'+');hold on;
        %     plot(x_plot,y_plot,'-r');
        %     title(sprintf('Ajuste por rectas'));
        % text(0.05,0.95,sprintf('X0= %f ',x(round((i_1-i_2)/2))),'sc');
        % text(0.05,0.9,sprintf('cen0= %f ',cen0(peaks)),'sc');
        % text(0.05,0.85,sprintf('fwhm= %f',sigma1),'sc');
        % text(0.05,0.8,sprintf('Altura_cal= %f ',H(peaks)),'sc');
        % text(0.05,0.75,sprintf('Altura= %f ',H_xmax(peaks)),'sc');
        % ylabel('Cuentas'); xlabel('TOF (usec)'); hold off;
        %  end
        %
        
        
        p0 = [];
        p1=[];
        p01 = [];
        p02 = [];
        low0=[];up0=[];
        
        
        for i=1:size(peaks,2)
            %a_left(i) b_left(i)  a_right(i)  b_right(i)
            p1=[p1 b_left(peaks(i)) a_left(peaks(i))  b_right(peaks(i))  a_right(peaks(i)) NaN NaN ];
            
            p0 = [p0  cen0(peaks(i)) fwhmguessV(peaks(i)) ];
            p01 = [p01 1.001*cen0(peaks(i)) 1.5*fwhmguessV(peaks(i)) ];
            p02 =[p02 0.999*cen0(peaks(i)) 1.5*fwhmguessV(peaks(i)) ];
            
            
            if ~exist('lim','var')
                lim=[0.99*cen0(peaks(i)) 1.01*cen0(peaks(i))];
            end
            
            low0 =[low0 lim(1) 0.03*max(fwhmguessV) ];
            up0 =[up0 lim(2) 5*max(fwhmguessV)];
            
            
        end
        
        %COMIENZA EL FITEO
        [pfit0,rn0,rs0,ex0,out0,lam0,jac0] = lsqnonlin('sumfun1',p0,low0,up0,opt,p1,npar,fn,x,yraw,ones(size(yraw)));
        [pfit1,rn1,rs1,ex1,out1,lam1,jac1] = lsqnonlin('sumfun1',p01,low0,up0,opt,p1,npar,fn,x,yraw,ones(size(yraw)));
        [pfit2,rn2,rs2,ex2,out2,lam2,jac2] = lsqnonlin('sumfun1',p02,low0,up0,opt,p1,npar,fn,x,yraw,ones(size(yraw)));
        
        
        %for i=1:size(peaks,2)
        p0_v=[p0(:) p01(:) p02(:)];
        pfit_v=[pfit0(:) pfit1(:) pfit2(:)];
        rs_v=[rs0 rs1 rs2];
        rn_v=[rn0 rn1 rn2];
        [C,I]=min(rn_v);
        
        p0f=p0_v(:,I);
        pfit=pfit_v(:,I);
        rs=rs_v(:,I);
        if I==1; jac=jac0;end
        if I==2; jac=jac1;end
        if I==3; jac=jac2;end
        %end
        y0 = sumfun1(p0f,p1,npar,fn,x);
        
        [dum var] = confint(p0f,rs,jac); % variance of fitted params
        
        
        yfit = sumfun1(pfit,p1,npar,fn,x);
        p2=[];
        for i=1:size(peaks,2)
            p2=[p2 pback_left(1) pback_left(2)  pback_right(1)  pback_right(2) NaN NaN ];
            yfitV(:,i)=sumfun1(pfit([(1+(i-1)*npar):(2+(i-1)*npar)]),p2,npar,fn,x);
            
            % Posicion del corte luego del fiteo
            pico_pos(peaks(i))=(pfit(1+(i-1)*(npar)));
            pico_d_pos(peaks(i))=(sqrt(var(1+(i-1)*(npar))));
            
            % Ancho del pico
            pico_ancho(peaks(i))=pfit(2+(i-1)*(npar));
            pico_d_ancho(peaks(i))=sqrt(var(2+(i-1)*(npar)));
            
            %
            % Alto
            pico_Tr_right(peaks(i))=pback_right(1)*pico_pos(peaks(i))+pback_right(2);
            pico_Tr_left(peaks(i))=pback_left(1)*pico_pos(peaks(i))+pback_left(2);
            pico_alto(peaks(i))=pico_Tr_right(peaks(i))- pico_Tr_left(peaks(i));
            pico_a_left(peaks(i))=a_left(peaks(i));
            pico_b_left(peaks(i))=b_left(peaks(i));
            pico_a_right(peaks(i))=a_right(peaks(i));
            pico_b_right(peaks(i))=b_right(peaks(i));
        end
        
        
        if plot_fits==1
            figure(200);clf; subplot('position',[0.1 0.3 0.85 0.6]);
            
            plot(x,yraw,'+',x,y0,'-r',x,yfitV,'-b',x,yfit,'-k');  ylabel('Intensity'); %
            %             title(sprintf('detector= %i ',l));
            %                 text(0.05,0.95,sprintf('Peak=(%d %d %d)',peaks_struct.h(peaks),peaks_struct.k(peaks),peaks_struct.l(peaks)),'sc');
            text(0.05,0.9,sprintf('H= %f',pico_alto(peaks)),'sc');
            text(0.05,0.85,sprintf('Center= %f ',pico_pos(peaks)),'sc');
            text(0.05,0.8,sprintf('sigma= %f ', pico_ancho(peaks)),'sc');
            % text(0.05,0.75,sprintf('tau= %f ', pico_tau(peaks)),'sc');
            subplot('position',[0.1 0.1 0.85 0.15]);
            plot(x,yraw'-yfit,'-g'); ylabel('Residual'); xlabel('TOF'); grid on;
            if(pause_fl)
                pause;
            end
            
        end;
        
        
    end;
    
    
    
    
    
    %*************************************************************************%
    %                   GUARDA INFORMACION DE LOS PICOS
    %*************************************************************************
    
    
    %
    for ii=1:size(peaks,2)
        cc=cc+1;
        pic=peaks(ii);
        %     % Ancho luego del fiteo sigma
        fit_espectro(cc).sigma=pico_ancho(pic);
        fit_espectro(cc).dsigma=pico_d_ancho(pic);
        %    fit_espectro(cc).tau=pico_ancho(pic);
        %  fit_espectro(cc).dtau=pico_d_ancho(pic);
        %          % Altura  del pico
        fit_espectro(cc).altura=pico_alto(pic);
        fit_espectro(cc).Tr_left=pico_Tr_left(pic);
        fit_espectro(cc).Tr_right=pico_Tr_right(pic);
        %          %Posición del pico
        fit_espectro(cc).centro=pico_pos(pic);
        fit_espectro(cc).dcentro=pico_d_pos(pic);
        fit_espectro(cc).yfit=yfit;
        fit_espectro(cc).x=x;
        fit_espectro(cc).y0=y0;
        fit_espectro(cc).y=yraw;
        fit_espectro(cc).a_l=pico_a_left(pic);
        fit_espectro(cc).a_r=pico_a_right(pic);
        fit_espectro(cc).b_l=pico_b_left(pic);
        fit_espectro(cc).b_r=pico_b_right(pic);
        %         fit_espectro(cc).HKL=[peaks_struct.h(pic)  peaks_struct.k(pic)  peaks_struct.l(pic)];
        %        fit_espectro(cc).LAM=peaks_struct.lam(pic);
        fit_espectro(cc).H=-(pico_a_left(pic)+pico_b_left(pic).*fit_espectro(cc).centro)+(pico_a_right(pic)+pico_b_right(pic).*fit_espectro(cc).centro);
    end
    
    clear x y yfit y0
    
    fit_res=fit_espectro;
    
    % if guar==1
    % b1=sprintf('fit_espectro_point%s_%s_%dx%d',point,orien,DNx,DNy);
    % save([fileroot b1],'fit_espectro');
    % end
    %
    % cd([sprintf('%s',home)])
end