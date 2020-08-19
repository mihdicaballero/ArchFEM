% Lectura de datos del archivo input_arco_circular

fid = fopen( '../../Input/input_arco_circular.txt' ,'r' );

% Obtengo los datos de entrada

%---- Radio de Curvatura ----
titulo = fgets  (fid) ;
R  = fscanf (fid,'%g') ;
%----Coordenadas "x" de los extremos ----
titulo = fgets  (fid);
x_coord = fscanf(fid,'%g')'; 
%----- Número de elementos ----
titulo = fgets  (fid) ;
nelem  = fscanf (fid,'%g') ;
%----- Carga distribuida (positiva hacia arriba) [kN/m] ----
titulo = fgets  (fid) ;
q_dato  = fscanf (fid,'%g') ;
titulo = fgets  (fid) ;
q_tipo  = fscanf (fid,'%g') ;
%---- Cargas puntuales en los nodos----
titulo = fgets  (fid); % Dexcripción
titulo = fgets  (fid); % Cantidad
Puntuales_cantidad = fscanf(fid,'%g')'  ;
Puntuales = [] ;
	for i=1:Puntuales_cantidad+1
		Puntuales = [ Puntuales ; fscanf(fid,'%g',[4] )' ] ;
		salto = fgets  (fid); 
	end
% ---- Tipos de apoyos de cada extremo [Izq, Der]----
% 1 = Libre - 2 = Apoyo Deslizante - 3 = Apoyo Fijo - 4 = Empotrado 
titulo = fgets  (fid) ; % Titulo
titulo = fgets  (fid) ; % Explicacion de posibles entradas
rest = fscanf(fid,'%g',[2] )' ;
salto = fgets  (fid) ;
%----- Modulo Elasticidad [kN/m2] ----
titulo = fgets  (fid) ;
E  = fscanf (fid,'%g') ; 
%----- Área de la viga ----
titulo = fgets  (fid) ;
A  = fscanf (fid,'%g') ;
%----- Inercia de la viga ----
titulo = fgets  (fid) ;
I  = fscanf (fid,'%g') ;
%--- Escala para ploteo de estructura deformada ---
titulo = fgets  (fid) ;
SF  = fscanf (fid,'%g') ;
%--- ¿Ver valores de solicitaciones en las figuras? 1 = Si - 2 = No
titulo = fgets  (fid) ;
VerVal  = fscanf (fid,'%g') ;
%--- Elija que gráficos desea ver. 1 = Si - 2 = No
%--- Modelo de la estructura   Estructura Deformada  Cortante   Momento   Directa 
titulo = fgets  (fid) ; titulo = fgets  (fid) ;
Ploteos  = fscanf (fid,'%g') ;
%--- Respecto al modelo de la estructura, elija que quiere ver: 1 = Si - 2 = No
%--- Apoyos    Nº de nodos  Nodos   Barras 
titulo = fgets  (fid) ; titulo = fgets  (fid) ;
Modelo  = fscanf (fid,'%g') ;

fclose(fid) ;

% Verifico que no sea un mecanismo la estructura
%
ap_error = 0 ; % Si es 0 todo bien, si hay error vale 1


if Language == 1
	switch (rest)
	case {[1,1]}
		disp(' ERROR! The structure is a mechanism, check the constraints at the')
		disp(' ends of the arch.') ;
		ap_error = 1 ;
		return
	case {[2,1]}
		disp(' ERROR! The structure is a mechanism, check the constraints at the')
		disp(' ends of the arch.') ;
		ap_error = 1 ;
		return
	case {[1,2]}
		disp(' ERROR! The structure is a mechanism, check the constraints at the')
		disp(' ends of the arch.') ;
		ap_error = 1 ;
		return
	case {[2,2]}
		disp(' ERROR! The structure is a mechanism, check the constraints at the')
		disp(' ends of the arch.') ;
		ap_error = 1 ;
		return
	endswitch
elseif Language == 2
	switch (rest)
	case {[1,1]}
		disp(' ERROR! La estructura es un mecanismo, revisar restricciones de los')
		disp(' extremos del arco.') ;
		ap_error = 1 ;
		return
	case {[2,1]}
		disp(' ERROR! La estructura es un mecanismo, revisar restricciones de los')
		disp(' extremos del arco.')
		ap_error = 1 ;
		return
	case {[1,2]}
		disp(' ERROR! La estructura es un mecanismo, revisar restricciones de los')
		disp(' extremos del arco.')
		ap_error = 1 ;
		return
	case {[2,2]}
		disp(' ERROR! La estructura es un mecanismo, revisar restricciones de los')
		disp(' extremos del arco.')
		ap_error = 1 ;
		return
	endswitch
end

% Cantidad de nodos
nnod = nelem + 1 ;

% Veo que no hayan cargas puntuales donde no tengo nodos
nod_error = 0;
for i=1:Puntuales_cantidad
	if Puntuales(i,1) > nnod
		nod_error=1;
		if Language == 1
			disp(' ERROR! There are point loads applied to non existent nodes.')
			return
		elseif Language ==2
			disp(' ERROR! Hay fuerzas puntuales aplicadas en nodos que no existen.')
			return
		end
	end
end


% Veo si la cantidad de nodos es menor a algún nodo en carga puntual

%Discretización del arco:
x_ini=x_coord(1); %Coordenada x del extremo izquierdo
x_fin=x_coord(2); %Coordenada x del extremo derecho

% Veo si la distancia entre los extremos del arco es mayor al diámetro del arco
L = abs(x_fin-x_ini) ;
if L > 2*R
	if Language == 1
		disp(' ERROR! The distance between the ends of the arch can not be bigger')
		disp(' than the double of the curvature radius.')
		ap_error = 1;
		return
	elseif Language == 2
		disp(' ERROR! La distancia entre los extremos del arco no puede ser mayor')
		disp(' al doble del radio de curvatura.')
		ap_error = 1;
		return
	end
end



ang = (asin(x_fin/R)-asin(x_ini/R)) ; % Angulo del arco
L=R*ang ; %Largo total del arco
l=L/nelem; %Largo de cada elemento

x=zeros(nnod,1);
x(1)=x_ini;

for i=2:length(x)
    x(i)=R*sin(l/R+asin(x(i-1)/R));
end
% Valores de y
y=sqrt(R^2-x.^2);
% Llevo el minimo de y a cero
y = y - min(y) ;
%
coordnod = [x,y] ;
%
% Ángulo de la horizontal al primer punto del arco
theta = pi/2+asin(x_ini/R) ;
% Vector con todos los angulos
thetai = zeros(nnod,1) ;
for i = 1:nnod
	thetai(i) = theta+ang/nelem*(i-1) ;
end
