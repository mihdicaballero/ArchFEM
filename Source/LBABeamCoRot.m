% --- Ejemplo LBA usando elemento co-rotacional ---

% PNI 20 acero
E = 210.0e+9 ;
A =  33.5e-4 ;
I =  14.6e-8 ;

L = 2       ;

nelems = 20 ;

rho = sqrt(I/A);

Lelem  = L/nelems   ;
nnodes = nelems + 1 ;

% empotramiento izquierdo y factor de luz pandeo
fixdofs = [ 1 2 3 ] ; beta = 2 ;



Cl = E* A / Lelem * ...
    [ 1        0        0  ; ...
      0  4*rho^2  2*rho^2  ; ...
      0  2*rho^2  4*rho^2  ] ;

B = [ -1  0 0 1 0 0 ; ...
      0 1/Lelem 1 0 -1/Lelem 0 ; ...
      0 1/Lelem 0 0 -1/Lelem 1] ;    

z= [ 0 -1 0 0 1 0 ]' ;
r= [ -1 0 0 1 0 0 ]' ;

Kmatelem = B' * Cl * B     ;
Kgeoelem = -1/Lelem * z*z' ;

Kmat = sparse( 3*nnodes, 3*nnodes) ;
Kgeo = sparse( 3*nnodes, 3*nnodes) ;

% ensamblado matrices
for i=1:nelems

  dofselem = ((3*i-2):3*(i+1))' ;
  
  Kmat (dofselem,dofselem) = Kmat (dofselem,dofselem) + Kmatelem ;
  Kgeo (dofselem,dofselem) = Kgeo (dofselem,dofselem) + Kgeoelem ;
  
end

Kmat( fixdofs,:) = [] ;  Kmat( :,fixdofs) = [] ;
Kgeo( fixdofs,:) = [] ;  Kgeo( :,fixdofs) = [] ;

[vecs,vals ] = eig(Kmat,-Kgeo) ;

vals = diag(vals) ;
valpropmin = min(abs(vals)) 

Pcrnum = pi^2 * E * I / ( (beta*L)^2 )  
