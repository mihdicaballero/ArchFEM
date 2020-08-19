% Lectura de datos del archivo input_arco_catenaria


fid = fopen( '../../Input/input_arco_catenaria.txt' ,'r' );

% Obtengo los datos de entrada

%---- Coordenadas de los dos apoyos [x,y] ----
titulo = fgets  (fid) ; 
apoyos = [] ; 
	for i=1:2
		apoyos = [ apoyos ; fscanf(fid,'%g',[2] )' ] ;
	end
salto = fgets  (fid) ;
%--- Constante [a] de la función de la catenaria  y(x)=a*cosh(x/a)  ---
titulo = fgets  (fid) ;
const = fscanf(fid,'%g')';
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
% Tipos de apoyos de cada extremo [Izq, Der]:
% 1 = Libre - 2 = Apoyo Deslizante - 3 = Apoyo Fijo - 4 = Empotrado 
titulo = fgets  (fid) ; % Titulo 
titulo = fgets  (fid) ; % Explicacion de posibles entradas
rest = fscanf(fid,'%g',[2] )'  ;
salto = fgets (fid) ;
%----- Modulo Elasticidad [kN/m2] ----
titulo = fgets  (fid) ;
E  = fscanf (fid,'%g') ;
% Tipo de discretización, elija una opción sola.
% 1 = Divide segun eje horizontal - 2 = Divide en elementos iguales
%titulo = fgets  (fid) ; titulo = fgets  (fid) ;
%discre  = fscanf (fid,'%g') ;
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

% Hallo las coordendas de los nodos
%
Y = [apoyos(1,2) apoyos(2,2)] ;
X = [apoyos(1,1) apoyos(2,1)] ;
%
% Divido en cantidad de elementos segun discretizacion elegida
%if discre == 1
	x = X(1):(X(2)-X(1))/nelem:X(2) ;
	y = -const*cosh(x./const) ;
%elseif discre == 2
	%% Método para dividir en elementos de igual largo
	%%Largo de la curva
	%L=const*sinh(X(2)/const)-const*sinh(X(1)/const); %calcula el largo de la curva entre los dos apoyos
	%%largo del elemento
	%l=L/nelem;
	%x=[];
	%y=[];
	%for i=0:nelem
		%x=[x,asinh((i*l+const*sinh(X(1)/const))/const)*const] ;
	%end
	%y =[y,-const*cosh(x./const)] ;
%else
	%if Language == 1
		%disp('Error in the choice of the type of discretization, choose again.')
		%return
	%elseif Language == 2
		%disp('Error en la eleccion del tipo de discretizacion, elija de nuevo.')
		%return
	%end
%end
y = y - min(y) ; % Llevo el minimo de y a cero
coordnod = [x',y'] ;
%




