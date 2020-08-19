% sets current tangent stiffness and geometric matrices
KT     = sparse( 3*nnod,3*nnod) ; % Tangent stifness matrix
FintGk = zeros( 3*nnod,1) ; % Global forces vector

for elem = 1:nelem
	% Degress of freedom of the element
	nodeselem = conectiv(elem,1:2)' ; dofselem  = nodes2dofs( nodeselem , 3 ) ;
	% Initial length of the bar
	L0 = Lini(elem) ;
	% Coordinates x & y of the element nodes
	x = [ xelems( elem, 1) xelems( elem, 2) ]' ;
	y = [ yelems( elem, 1) yelems( elem, 2) ]' ;
	
	% Displacements and slope element vector
	uke = Uk (dofselem) ; 
	% Coordinates vector discreted by dof
	ue  = [uke(1), uke(4)]; we = [uke(2), uke(5)]; thetae = [uke(3), uke(6)]; 
	
	% Deformed length of the beam
	Le      = sqrt(((x(2)+ue(2))-(x(1)+ue(1)))^2 + ((y(2)+we(2))-(y(1)+we(1)))^2 );
	
	% Strain and axial force
	ul = (Le^2-L0^2) / (Le+L0) ; % Local axial displacement
	N = E * A * ul / L0 ; % Axial force in the beam
	
	% Initial slope and deformed slope
	beta0   = atan2 (y(2)-y(1),x(2)-x(1)) ;
	beta    = atan2 ((y(2)+we(2))-(y(1)+we(1)),(x(2)+ue(2))-(x(1)+ue(1))); 
	c       = cos(beta) ; 
	s       = sin(beta) ; 
	beta1   = thetae(1) + beta0 ; 
	beta2   = thetae(2) + beta0 ; 
	theta1l = atan((cos(beta)*sin(beta1)-sin(beta)*cos(beta1))/(cos(beta)*cos(beta1)+sin(beta)*sin(beta1))) ;	
	theta2l = atan((cos(beta)*sin(beta2)-sin(beta)*cos(beta2))/(cos(beta)*cos(beta2)+sin(beta)*sin(beta2))) ;
	
	% Moment in both nodes of the beam
	M1 	  = 2*E*I/L0 * (2*theta1l+1*theta2l) ;
	M2 	  = 2*E*I/L0 * (1*theta1l+2*theta2l) ;	
	
	% Curvature in every node of the element
	curvature(elem,:) = [M1/(E*I), -M2/(E*I)] ; 
		
	qle    = [N M1 M2 ]' ; 
	
	B     = [ -c    -s    0  c     s    0 ;
			  -s/Le  c/Le 1  s/Le -c/Le 0 ;
			  -s/Le  c/Le 0  s/Le -c/Le 1 ];
	Cl = E*A/L0*G ; 
	% Rotation vectors
	z 	  = [ s -c  0 -s c 0 ]' ; 
	r	  = [-c -s  0  c s 0 ]' ;
	
	B1    = z*z'./Le ;
	B2 	  = (r*z'+z*r')./(Le^2) ;
	
	% Stifness matrix	
	KT1e  = B' * Cl * B  ; 		% Standard stifness matrix
	KTGe  = N*B1 + (M1+M2)*B2 ; % Geometric stifness matrix and initial stress matrix
	Finte = B'*qle ;

	% matrices assembly
	KT (dofselem,dofselem) = KT (dofselem,dofselem) + KT1e + KTGe ;
	% internal loads vector assembly
	FintGk ( dofselem) = FintGk(dofselem) + Finte ;

end

% boundary conditions are applied
KTred  = KT  ( freedofs, freedofs );
% ------------------------------------







