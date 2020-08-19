close all, clc, clear all

disp(' ===========================================================================')
disp(' ===========================================================================')
disp('      ______   ______   ______   __  __   ______  ______   __    __      ')
disp('     /\  __ \ /\  == \ /\  ___\ /\ \_\ \ /\  ___\/\  ___\ /\ `-./  \     ')
disp('     \ \  __ \\ \  __< \ \ \____\ \  __ \\ \  __\\ \  __\ \ \ \-./\ \    ')
disp('      \ \_\ \_\\ \_\ \_\\ \_____\\ \_\ \_\\ \_\   \ \____ \\ \_\ \ \_\   ')
disp('       \/_/\/_/ \/_/ /_/ \/_____/ \/_/\/_/ \/_/    \/_____/ \/_/  \/_/   ')
disp('')
disp(' ===========================================================================')
disp(' ===========================================================================')
disp('')
disp(' Nonlinear Analysis module with Corotational Finite Elements ')
disp('')

uk_load_factor_scale = 100 ; % Converts m to cm in plot
scale 				 = 1   ; % Scale for displacements
dist_convertion      = 100 ; % Converts m to cm in plot
length_unit			 = 'cm'     ; % To be displayed in plot
force_unit 			 = 'P [kN]' ; % To be displayed in plot
%~ force_unit  = 'M [kNm]' ; % To be displayed in plot

% Imperfection of the structure 
addimperfection = 0 ; % 1: add imperfection, 0: don't add imperfection
angle = 0.1 ; % Imperfection angle in degrees - vertical projection of slope added

% ==========================================================
% ==== Viga en ménsula con carga puntual en el extremo =====
% ==========================================================
	% Load geometry
	pre_beam
	% Vertical puntual load applied at the end
	P 	= -6 ; % kN
	%~ P_imper = -40 ; % kN
	%~ Pcr = pi^2*E*I/(2*L)^2 ;
	applied_load = P ; % Applied load to be displayed in force-displacement plot
	%~ Fext(3*nnod-1) = 1 ; %  Carga puntual P vertical en el extremo
	%~ Fext(3*nnod-2) = 1 ; %  Carga puntual P horizontal en el extremo
	Fext((ceil(3*nnod/2))) = 1 ; %  Carga puntual P en el medio

	% Moment puntual load applied at the end
	%~ Mc 	= -2*pi*E*I/L ; % kNm 
	%~ M 	= -0.1 ; % kNm 
	%~ applied_load = Mc ; % Applied load to be displayed in force-displacement plot
	%~ Fext(3*nnod) = 1 ; % Momento puntual M en el extremo

	numbercontroldof = 1 ;  % Number of control dof to show in load-displacement plot. Maximum of 2.  
	controldof_1 = -(ceil(3*nnod/2)) ; 	% Blue 	- Desplazamiento vertical en el centro
	%~ controldof_1 = -(3*nnod-1) ; 	% Blue 	- Desplazamiento vertical del extremo
	%~ controldof_2 = -(3*nnod-2) ; 	% Black - Desplazamiento horizontal del extremo
	
	setini % Initialization of parameters
% ===============================================================
 
% ==========================================================
% ========== Arco de radio de curvatura circular ===========
% ==========================================================
	%~ Language = 2 ;
	%~ pre_circular

	%~ applied_load = -6 ; 
	%~ applied_load = -30 ; 
	%~ applied_load = -30 ; 

	%~ numbercontroldof = 1 ;  % Number of control dof to show in load-displacement plot. Maximum 2.  
	%~ % The sign of the controldof determines how to plot displacement
	%~ controldof_1 = -(ceil(3*nnod/2)) ; 	% Vertical en el medio
	
	%~ setini 		% Initialization of parameters
	%~ forces % Construction of external applied forces vector
% ===============================================================

targetLoadFactor = applied_load ;

nLoadSteps      = 35 ; % Cercha de Von Mises
incremarclen 	= 0.02 ;

% Input for arch examples
% ======= Arco fijo-fijo con carga vertical e inclinada - coord x= 2.032
% R [m] nLoadSteps incremarclen
% 2.54		80			0.1		% Carga vertical
% 2.54		80			0.1		% Carga inclinada
% 2.54		126			0.1		% Carga veritcal + imperfección
% 5.08		80			0.1		% Carga vertical
% 7.62		55			0.1		% Carga vertical
% 10.16		55			0.07	% Carga vertical
% ======= Arco fijo-empotrado con carga vertical - coord x= 2.422
% R [m] nLoadSteps incremarclen 
% 2.54		110			0.15	% Carga vertical


% Iterative method used: 
%~ solutionMethod  = 1 ; 	 % Incremental Newton-Raphson
solutionMethod  = 2 ; % Combined NR/arc-length method

% Nonlinear iteration parameters
NRtolits     = 30     ;
NRtoldeltau  = 1.0e-5 ;
NRtolR       = 1.0e-3 ;
% ===============================================================

% Scripts to run
linear_analysis % Linear analysis
process_NL 	% Nonlinear analysis
factor_crit_lin
ploteos 	% Plots

 
