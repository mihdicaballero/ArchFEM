%
KGmat     = sparse( 3*nnod,3*nnod) ; % Material stifness matrix
KGgeom    = sparse( 3*nnod,3*nnod) ; % Geometric stifness matrix

for elem = 1:nelem
	% Degress of freedom of the element
	nodeselem = conectiv(elem,1:2)' ; dofselem  = nodes2dofs( nodeselem , 3 ) ;
	% Initial length of the bar
	L0 = Lini(elem) ;
	% Coordinates x & y of the element nodes
	x = [ xelems( elem, 1) xelems( elem, 2) ]' ;
	y = [ yelems( elem, 1) yelems( elem, 2) ]' ;	
	% Initial slope and deformed slope
	beta0   = atan2 (y(2)-y(1),x(2)-x(1)) ;
	c       = cos(beta0) ; 
	s       = sin(beta0) ; 
	% 
	B     = [ -c    -s    0  c     s    0 ;
			  -s/L0  c/L0 1  s/L0 -c/L0 0 ;
			  -s/L0  c/L0 0  s/L0 -c/L0 1 ];
    %          
	% Rotation vectors
	z 	  = [ s -c  0 -s c 0 ]' ; 
	r	  = [-c -s  0  c s 0 ]' ;
	%
	Cl 	  = E*A/L0*G ; 
	B1    = z*z'./L0 ;
	B2 	  = (r*z'+z*r')./(L0^2) ; % I don't use this matrix.
	
	% Stifness matrix	
	KGmate  = B' * Cl * B  ; 	% Standard stifness matrix
	KGgeome  = B1 ;				% Geometric stifness matrix

	% matrices assembly
	KGmat (dofselem,dofselem) = KGmat (dofselem,dofselem) + KGmate ;
	KGgeom (dofselem,dofselem) = KGgeom (dofselem,dofselem) + KGgeome ;
end

% boundary conditions are applied
KGmatred   = KGmat   ( freedofs, freedofs );
KGgeomred  = KGgeom  ( freedofs, freedofs );
% ------------------------------------
Fextred = Fext ( freedofs ) ;
% ------------------------------------

uklin  = KGmatred \ Fextred  ;
Uklin  = zeros(3*nnod,1) ;
Uklin(freedofs) = uklin   ;



% ===============================================================
% buckling analysis
%
[ ModesLinBuck, lambdas] = eig( KGmatred , - KGgeomred ) ;
%~ [ ModesLinBuck, lambdas] = eigs( KL0red , - KGlinred, 5, 'sa' ) ;

[lambdas,perm] = sort(diag(abs(lambdas))); % Sort of lambdas in absolute value, in order to not consider infinte lambdas
ModesLinBuck=ModesLinBuck(:,perm); % Permutation of modes according to lambdas

factor_crit_lin          = min( lambdas ); % Critic factor

%~ if factor_crit_lin < 0,

  %~ indsneg = find( lambdas <0) ;

  %~ fprintf(' ===== Warning: %3i negative linear buckling analysis factors! ===== \n Removing negative eigenmodes.... \n',length(indsneg) );

  %~ lambdas(indsneg) = [] ;
  %~ ModesLinBuck(:,indsneg) = [] ;

  %~ fprintf(' =========================================================\n');
%~ end

nmodesLinBuck  = length(lambdas) ;
UsModesLinBuck = zeros( 2*nnod, nmodesLinBuck ) ;

for i=1:nmodesLinBuck
  uaux                       = ModesLinBuck(:,i) ;
  UsModesLinBuck(freedofs,i) = uaux / norm( uaux, 'inf' ) ;
end


KG0red = KGmatred ; % Linear stifness matrix 

