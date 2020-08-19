
% Carga externa global en los nodos
Fext    = zeros(3*nnod,1) ; 

% Cargas externas nodales aplicadas sobre la estructura en coordenadas globales
for i = 1:size(Puntuales)(1)
	node = Puntuales(i,1) ;
	Fext(3*node-2) = Fext(3*node-2) + Puntuales(i,2);
	Fext(3*node-1) = Fext(3*node-1) + Puntuales(i,3);
	Fext(3*node)   = Fext(3*node)   + Puntuales(i,4);
end

% Cargas externas distribuidas sobre la estructura aplicada sobre los nodos, en coordenadas globales
% Si la carga es por eje horizontal, la paso a eje del arco.
if	q_tipo == 1
	q_elem = q_dato*(xelems(:,2)-xelems(:,1))./Lini ;
elseif q_tipo == 2
	q_elem = zeros(nelem,1) + q_dato ;
end

% Proyecto las fuerzas en coordenadas locales del elemento para cada nodo
qa = q_elem.*sinini ; % Carga axial a la barra
qn = q_elem.*cosini ; % Carga normal a la barra
% Calculo las resultantes por elemento de barra y de viga
Fbarra     = [ qa.*Lini/2  qa.*Lini/2];
Fcortante  = [ qn.*Lini/2  qn.*Lini/2 ] ;
Fmomento   = [ qn.*Lini.^2/12  -qn.*Lini.^2/12 ];
% Lo paso a coordenadas globales

O = zeros(3,3); % Matriz de ceros de 3x3
for elem = 1:nelem
	% Grados de libertad del elemento
	nodeselem = conectiv(elem,1:2)' ; dofselem  = nodes2dofs( nodeselem , 3 ) ;
	% Se calcula la matriz de cambio de base
	Icb = [ cosini(elem)   sinini(elem) 0   ;...
		 -sinini(elem)   cosini(elem) 0   ;...
		  0			 0		  1 ] ;
	% Matriz de giro
	Q = [ Icb  O     ;...
		  O	   Icb ] ;
	FLelem = [Fbarra(elem,1) ; Fcortante(elem,1) ; Fmomento(elem,1) ; Fbarra(elem,2) ; Fcortante(elem,2) ; Fmomento(elem,2) ] ;
	FGelem = Q'*FLelem ;
	Fext(dofselem) = FGelem + Fext(dofselem) ;
end


