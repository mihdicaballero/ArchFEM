% Funcion que plotea los distintos soportes de una estructura

function [ HX , HY ] = Supports( type , pos , offset)

% type = tipo de restriccion 
% pos = posición del punto en donde se dibuja el apoyo
% offset = tamaño del apoyo a dibujar


if type == 2
	% ========= Apoyo Deslizante ==========
	%
	[ X , Y ] = Polygs( [0,0] , offset , 3 , pi/2) ;
	X = [X(3) X(1:2) X(3)] ; Y = [Y(3) Y(1:2) Y(3)] ;
	Hx = [ X'          ; linspace( + offset , - offset ,3)'] ;
	Hy = [ (Y-offset)' ; -ones(3,1)*offset*1.8] ;
	%
elseif type == 3
	% ========= Apoyo Fijo ==========
	%
	[ X , Y ] = Polygs( [0,0] , offset , 3 , pi/2) ;
	[ X , Y ] = Polygs( [0,0] , offset , 3 , pi/2) ;
	X = [X(3) X(1:2) X(3)] ; Y = [Y(3) Y(1:2) Y(3)] ;
	Xsuelo(1:2:15)=linspace(-offset*cos(pi/6),+offset*cos(pi/6),8);
	Xsuelo(2:2:14)=linspace(-offset*cos(pi/6)*7/8,+offset*cos(pi/6),7);
	Xsuelo(16)=+offset*cos(pi/6);
	Ysuelo(1:2:15)=-offset-offset*sin(pi/6);
	Ysuelo(2:2:16)=-offset-offset*sin(pi/6)-offset*cos(pi/6)/4;
	Hx = [ X'        ; Xsuelo'  ] ;
	Hy = [ (Y-offset)';Ysuelo'  ] ;
	%
elseif type == 4
	% ========= Empotramiento ==========
	%
	[ X , Y ] = Polygs( [0,0] , offset , 3 , pi/2) ;
	[ X , Y ] = Polygs( [0,0] , offset , 3 , pi/2) ;
	X = X([2 3]) ; Y = Y([2 3]) ;
	%
	Xsuelo(1:2:15)=linspace(-offset*cos(pi/6),+offset*cos(pi/6),8);
	Xsuelo(2:2:14)=linspace(-offset*cos(pi/6)*7/8,+offset*cos(pi/6),7);
	Xsuelo(16)=+offset*cos(pi/6);
	XsueloNuevo = zeros(1,24) ;
	XsueloNuevo(1:3:22) = Xsuelo(1:2:15) ;
	XsueloNuevo(2:3:23) = Xsuelo(2:2:16) ;
	XsueloNuevo(3:3:24) = Xsuelo(1:2:15) ;
	%
	Ysuelo(1:2:15)=-offset-offset*sin(pi/6);
	Ysuelo(2:2:16)=-offset-offset*sin(pi/6)-offset*cos(pi/6)/4;
	Ysuelo = Ysuelo.*6 ;
	Y = Y-offset ; Ysuelo = Ysuelo - max(Y)*6 ; Y = Y - max(Y) ;
	YsueloNuevo = zeros(1,24) ;
	YsueloNuevo(1:3:22) = Ysuelo(1:2:15) ;
	YsueloNuevo(2:3:23) = Ysuelo(2:2:16) ;
	YsueloNuevo(3:3:24) = Ysuelo(1:2:15) ;
	%
	Hx = [ X' ; XsueloNuevo'  ]; 
	Hy = [ Y' ; YsueloNuevo'  ];
end

HX = [Hx  + pos(1) ] ;
HY = [Hy  + pos(2) ] ;


