% ======================================================================
% ======================================================================
% ======================= SALIDA DE DATOS ==============================
% ======================================================================
% ======================================================================

% Creo vector con reacciones de extremos, poniendo las nulas también.

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
entradas = find(gdlfij) ; % Vector con entradas en donde hay reacción		          
R = zeros(1,6) ;
R(entradas) = Reac ;   % Vector con 6 entradas, donde hay reacción la entrada
					   % vale la reacción, sino cero.

% Creo matriz con los desplazamientos horizontales, verticales y giros
% en columnas separadas
U= [ U(1:3:end)*100 , U(2:3:end)*100 , U(3:3:end) ] ;
% Modifico vectores de solicitaciones a correctas unidades
V_tot = V_tot/e*V_max ;
M_tot = M_tot/e*M_max ; 
R_tot = R_tot/e*R_max ;

% Imprimo los resultados en un nuevo .txt

% Nombre del archivo según el tipo de arco
if tipo == 1
	out = fopen( '../../Output/Output_arco_circular.txt' ,'w');
elseif tipo == 2
	out = fopen( '../../Output/Output_arco_parabolico.txt' ,'w');
elseif tipo == 3
	out = fopen( '../../Output/Output_arco_catenaria.txt' ,'w');
end

% Reacciones
fprintf( out , '%s \n\n' , ' ========================= Reacciones =========================' );
fprintf( out , '%s \n' , ' Extremo izquierdo: ' );
	fprintf( out , '%s%.4e%s' , ' H_A = ', R(1),'kN  ' );
	fprintf( out , '%s%.4e%s' , ' V_A = ', R(2),'kN  ' );
	fprintf( out , '%s%.4e%s' , ' M_A = ', R(3),'kNm  ' );
fprintf( out, '\n');
fprintf( out , '%s \n' , ' Extremo derecho: ' );
	fprintf( out , '%s%.4e%s' , ' H_B = ', R(4),'kN  ' );
	fprintf( out , '%s%.4e%s' , ' V_B = ', R(5),'kN  ' );
	fprintf( out , '%s%.4e%s' , ' M_B = ', R(6),'kNm  ' );
fprintf( out, '\n\n');
% Desplazamientos
fprintf( out , '%s \n' , ' =================== Desplazamientos y Giros ===================' );
fprintf( out , '\n'); 
fprintf( out , '%s \n' , ' Nodo	Desp. Horizontal [cm]	Desp. Vertical [cm] Giro [rad]' );
for i=1:size(U, 1)
    fprintf(out, '  %g  			%.2f				%.2f	          %.5f ', i,U(i,1),U(i,2),U(i,3));
    fprintf(out, '\n');
end
fprintf(out, '\n');
% Solicitaciones
fprintf( out , '%s \n' , ' ================= Solicitaciones en la estructura =================' );
fprintf( out , '\n'); 
fprintf( out , '%s \n' , ' Elemento	   Directa [kN]	 Cortante [kN]	 Momento [kNm]' );
for elem = 1:nelem 
	fprintf( out       , ' %i%s 		%.2f			%.2f			%.2f \n', elem , ' izq.', R_tot(4*elem-3),V_tot(4*elem-3),M_tot(4*elem-3) );
	fprintf( out       , ' %i%s 		%.2f			%.2f			%.2f \n', elem , ' der.', R_tot(4*elem)  ,V_tot(4*elem)  ,M_tot(4*elem)   );
end
fprintf( out, '\n');

fclose( out ) ;
