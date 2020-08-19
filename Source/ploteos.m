
set (0, "defaultaxesfontname", "times") 
set (0, "defaultaxesfontsize", 11) 
set (0, "defaulttextfontname", "times") 
set (0, "defaulttextfontsize", 11) 


Ukesc = Uk.*scale ;
%~ Ukesc = Uklin.*scale ;

displacmat      = reshape(Ukesc,3,nnod) ;
displacmat(3,:) = [] ;
Nodesdef        = coordnod + displacmat'  ;


xelems = xelems.*dist_convertion ; yelems = yelems.*dist_convertion ; 
Ukesc  = Ukesc.*dist_convertion ;
Nodesdef = Nodesdef.*dist_convertion ; 
curvature = curvature./dist_convertion ; 
coordnod = coordnod*dist_convertion ; 


lw = 2.5;
ms = 5;

figure, hold on %

for i=1:nelem
  plot(xelems(i,:),yelems(i,:),'b-o','linewidth',lw,'markersize',ms)
  plot(Nodesdef( conectiv(i,1:2) , 1),Nodesdef( conectiv(i,1:2) , 2),'r--','linewidth',lw,'markersize',ms)
end


hold off

auxx = Largos(1)/20*dist_convertion ; 
auxy = Largos(2)/20*dist_convertion ; 
title('Indeformada (continua) y deformada (discontinua)')
grid on
box on
set(gca, 'linewidth', 1.5, 'fontsize', 11 )
xlabel_str = sprintf("x [%s]",length_unit);
ylabel_str = sprintf("y [%s]",length_unit); 
xlabel(xlabel_str) 
ylabel(ylabel_str) 
axis equal
xmin = min(min(Nodesdef(:,1)),min(coordnod(:,1))) - auxx ; 
xmax = max(max(Nodesdef(:,1)),max(coordnod(:,1))) + auxx ; 
ymin = min(min(Nodesdef(:,2)),min(coordnod(:,2))) - auxy ; 
ymax = max(max(Nodesdef(:,2)),max(coordnod(:,2))) + auxy ; 
axis ([xmin xmax ymin ymax])

%~ print('Indeformada-Deformada','-deps') ;
%~ print('Indeformada-Deformada','-depslatex') ;

% Curvature plot
figure, hold on %

for i=1:nelem
  plot(xelems(i,:),yelems(i,:),'b-o','linewidth',lw,'markersize',ms)
  plot(xelems(i,:),curvature(i,:),'m--','linewidth',lw,'markersize',ms)
end

hold off

title('Indeformada (continua) y curvatura (discontinua)')
grid on
box on
set(gca, 'linewidth', 1.5, 'fontsize', 11 )
xlabel_str = sprintf("x [%s]",length_unit);
ylabel_str = sprintf("k [1/%s]",length_unit); 
xlabel(xlabel_str) 
ylabel(ylabel_str) 

ymin2 = min(min(curvature(:,2)),min(coordnod(:,2))) - auxy ; 
ymax2 = max(max(curvature(:,2)),max(coordnod(:,2))) + auxy ; 
axis ([xmin xmax ymin2 ymax2])


%  [0,0] to first Load factors

% Trim of uks vector for max load iterations in Arc Length Method
if solutionMethod  == 2 
	uks1([loadIter+1:end]) = [] ;
	uks2([loadIter+1:end]) = [] ;
	fks([loadIter+1:end])  = [] ;
end

uks1 = [0 ;uks1] ; uks2 = [0 ;uks2] ; fks = [0 ; sign(applied_load)*fks] ;

uks_load_factor1 = uks1.*uk_load_factor_scale ; 
uks_load_factor2 = uks2.*uk_load_factor_scale ; 
% 

% Load factor plot for 2 control degrees of freedom

figure
if numbercontroldof == 2
	plot(uks_load_factor1,fks,'b-o','markersize',ms,'linewidth',lw)
	hold on
	plot(uks_load_factor2,fks,'k-o','markersize',ms,'linewidth',lw)
else
	plot(uks_load_factor1,fks,'b-o','markersize',ms,'linewidth',lw)
end
%
title('Carga-Desplazamiento')
grid("on")
box on
set(gca, 'linewidth', 2, 'fontsize', 11 )
xlabel_loadfactor = sprintf('Desplazamientos [%s]',length_unit) ;
ylabel_loadfactor = sprintf('%s',force_unit) ; 
ylabel(ylabel_loadfactor)
xlabel(xlabel_loadfactor)
str1 = 'Control DOF 1' ; 
str2 = 'Control DOF 2' ;
if numbercontroldof == 2
	legend (str1, str2)
else
	legend (str1)
end

%~ hold on

%~ % Critic factor plot
%~ factor_crit_lin = ones(length(uks_load_factor1),1)*factor_crit_lin ; 
%~ plot(uks_load_factor1,factor_crit_lin,'k-','linewidth',lw)
%~ str3 = 'Load critic factor ' ;
%~ legend(str1,str3) 




