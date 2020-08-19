% Material properties
%~ A = 0.00250 ; E = 700000 ; I = 5.20833e-07 ; % Datos del material ficticios
%~ A = 0.00106 ; E = 2.10e+08 ; I = 1.71e-06 ; % Ménsula con imperfeccion
%~ A = 33.5e-4 ; E = 2.10e+08 ; I = 14.6e-8 ; % Ménsula centrada para LBA 
A = 0.00004082820 ; E = 199714000 ; I = 1.32651e-10 ; % Datos del material ficticios


% Viga en ménsula 
%~ nelem = 20 ;
%~ L = 2 ; % Lenght in m
%L = 5.00 ; % Lenght in m for cantilever with imperfection
%~ nnod = nelem + 1 ;
%~ rest = [4 1] ; % Apoyos: empotrado - libre

%~ % Conectividad de los nodos
%~ conectiv = zeros(nelem,2) ;
%~ for i = 1:nelem
	%~ %
	%~ coordnod(i+1,:) = [(L/nelem)*i 0] ;
	%~ conectiv(i,:) = [i i+1] ;
	%~ %
%~ end

% Cercha de Von Mises [Li 2017]

nelem = 22 ;
nnod = nelem + 1 ;
rest = [4 4] ; % Apoyos: empotrado - empotrado

auxx = 0.65715/2 ;
auxy = 0.0098 ;  
auxy = 0.0198 ;  

%~ % Conectividad de los nodos
conectiv = zeros(nelem,2) ;

for i = 1:nelem/2
	coordnod(i+1,:) = [(2*auxx/nelem)*i 2*auxy/nelem*i] ;
	coordnod(nelem/2+i+1,:) = [(2*auxx/nelem)*(nelem/2+i) 2*auxy/nelem*(nelem/2-i)] ;
	conectiv(i,:) = [i i+1] ;
	conectiv(nelem/2+i,:) = [nelem/2+i nelem/2+i+1] ;
end

% External forces vector
Fext = zeros(3*nnod,1) ;
