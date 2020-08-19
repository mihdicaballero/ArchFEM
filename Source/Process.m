% Proceso de datos
% Se calcula conectividad de nodos, matriz de rigidez global, vector de fuerzas global
% desplazamientos y giros de todos los nodos, reacciones en los apoyos.

tic

% Matriz de rigidez total
KG = zeros(3*nnod,3*nnod) ;

% Cálculo de la matriz de rigidez local para cada elemento y ensamblaje en la matriz global
for elem=1:nelem
	%
	% Coordenadas globales de los nodos segun X e Y 
	x = coordnod( conectiv(elem,:) ,1 ) ;
	y = coordnod( conectiv(elem,:) ,2 ) ;
	DeltaX = x(2)-x(1) ;
	DeltaY = y(2)-y(1) ;
	l = sqrt(DeltaX^2+DeltaY^2) ;
	%
	% Se calcula la matriz de cambio de base
	Icb = [ DeltaX/l   DeltaY/l 0   ;...
		 -DeltaY/l   DeltaX/l 0   ;...
		  0			 0		  1 ] ;
	% Matriz de giro
	O = zeros(3,3); % Matriz de ceros de 2x2
	Q = [ Icb  O     ;...
		  O	   Icb ] ;
	% Calculo de matrices de rigidez local para barra y viga
	% Matriz de rigidez de la viga en coordenadas locales
	Kviga = E*I/l^3 * [ ...
					12   6*l    -12   6*l   ;
					6*l  4*l^2  -6*l  2*l^2 ;
					-12  -6*l    12   -6*l   ;
					6*l  2*l^2  -6*l  4*l^2  ] ;
	% Matriz de rigidez de elemento de barra en coordenadas locales
	Kbarra =  E*A/l*[ ...
				  1  -1 ;
				  -1  1 ] ;
	%       
	gdlviga = [2,3,5,6] ;
	gdlbarra = [1,4] ;
	Kelem = zeros(6) ;
	Kelem(gdlbarra,gdlbarra) = Kbarra ;
	Kelem(gdlviga,gdlviga) = Kviga ;
	KGelem = Q'*Kelem*Q ;
	% Grados de libertad del elemento
	gdlelem = conec2gdlframe (conectiv , elem );
	% Alocamos la matriz Kelem en el lugar correspondiente en KG
	KG(gdlelem,gdlelem)  = KG(gdlelem,gdlelem) + KGelem  ;
	%
end

% Fuerzas en cada nodo
F = zeros (1,3*nnod)' ;%
                                                                                                                                                                     
for elem = 1:nelem
	%
	% Coordenadas globales de los nodos segun X e Y 
	x = coordnod( conectiv(elem,:) ,1 ) ;
	y = coordnod( conectiv(elem,:) ,2 ) ;
	DeltaX = x(2)-x(1) ; DeltaY = y(2)-y(1) ;
	l = sqrt(DeltaX^2+DeltaY^2) ;
	%
	% Se calcula la matriz de cambio de base
	Icb = [ DeltaX/l   DeltaY/l 0   ;...
		 -DeltaY/l   DeltaX/l 0   ;...
		  0			 0		  1 ] ;
	% Matriz de giro
	O = zeros(3,3); % Matriz de ceros de 2x2
	Q = [ Icb  O     ;...
		  O	   Icb ] ;
	% Matriz de giro de u y v
	Qq = [ DeltaX/l   DeltaY/l    ;...
		 -DeltaY/l   DeltaX/l  ] ;
	% Grados de libertad del elemento
	gdlelem = conec2gdlframe (conectiv , elem ) ;
	%
	% Si la carga es por eje horizaontal, la paso a eje del arco y listo.
	if	q_tipo == 1
		q_elem = q_dato*DeltaX/l ;
	elseif q_tipo == 2
		q_elem = q_dato ;
	end
	
	% Proyecto las fuerzas en coordenadas locales del elemento para cada nodo
	qF = Qq * [0 ; q_elem];
	qa = qF(1) ; % Carga axial a la barra
	qn = qF(2) ; % Carga normal a la barra
	%
	Fbarra = [ qa*l/2  qa*l/2]'  ;
	%
	Fviga = [ qn*l/2  qn*l^2/12  qn*l/2  -qn*l^2/12 ]'  ;
	%
	FLelem = [Fbarra(1) ; Fviga([1 2]) ; Fbarra(2) ; Fviga([3 4])] ; % Vector local de fuerzas
	% Roto cargas a directa y cortante
	FGElem = Q'*FLelem ;
	F(gdlelem) = FGElem + F(gdlelem) ;

end
%
% Paso la matriz de cargas puntuales a vectores

Puntuales_nodos = Puntuales(:,1);
Puntuales_h_valores = Puntuales(:,2);
Puntuales_v_valores = Puntuales(:,3);
Puntuales_m_valores = Puntuales(:,4);

% Fuerzas puntuales horizontales en la estructura
for i=1:length(Puntuales_nodos)
	F(3*Puntuales_nodos(i)-2) = F(3*Puntuales_nodos(i)-2) + Puntuales_h_valores(i) ;
end
%
% Fuerzas puntuales verticales en la estructura
for i=1:length(Puntuales_nodos)
	F(3*Puntuales_nodos(i)-1) = F(3*Puntuales_nodos(i)-1) + Puntuales_v_valores(i) ;
end
%
% Fuerzas puntuales verticales en la estructura
for i=1:length(Puntuales_nodos)
	F(3*Puntuales_nodos(i)) = F(3*Puntuales_nodos(i)) + Puntuales_m_valores(i) ;
end




%

% Restricciones
% Supongo todo empotrado y luego voy sacando restricciones
% Pongo 0 donde no hay restriccion
gdlfij = [ 1  2  3 3*nnod-2 3*nnod-1 3*nnod ] ; 
for i=1:2
	if rest(i) == 1
		gdlfij([3*i-2,3*i-1,3*i]) = 0 ;
	elseif rest(i) == 2
		gdlfij([3*i-2,3*i]) = 0 ;
	elseif rest(i) == 3
		gdlfij([3*i]) = 0 ;
	end
end
% Saco los ceros de gdlfij
gdlfij(gdlfij==0) = [] ;

gdllib =  1:3*nnod ;
gdllib(gdlfij) = [] ;


% Matriz reducida del problema
Kliblib = KG( gdllib , gdllib ) ;
U = zeros(3*nnod,1) ;

% Sistema lineal a resolver
U (gdllib) = Kliblib \ F (gdllib);

Kfijlib = KG( gdlfij , gdllib ) ;


% Reacciones
Reac = Kfijlib * U ( gdllib ) - F(gdlfij);% Reacciones en los apoyos


% Le resto lo que descarga directamente en los apoyos
tiempo_cuentas = toc ;
if Language == 1
	printf(' The time for data process was %.2f seconds. \n',tiempo_cuentas)
elseif Language ==2
	printf(' El tiempo de proceso de datos fue de %.2f segundos. \n',tiempo_cuentas)
end




