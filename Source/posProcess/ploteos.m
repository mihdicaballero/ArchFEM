% Ploteo de el modelo de la estructura, la estructura deformada
% y los diagramas de cortante, momento y directa.


if Ploteos(1) == 1

	tic

	% Ploteo en 2D de la estrutura con apoyos y numero de nodos
	% Define posición y tamaño de la figura en función del tamaño de la pantalla
	scrsz = get(0,'ScreenSize');
	set(gcf,'Position',[scrsz(3)*0.2 scrsz(4)*0.3 scrsz(3)*0.7 scrsz(4)*.6])
	figure(1)
	% Vectores de posición para el numero de los nodos
	esc_numeros = 0.05 ;
	if max(Largos) < 2*min(Largos)
		offset = max([ min(Largos)*esc_numeros 0.1 ]);
	else
		offset = min([ max(Largos)*esc_numeros 0.75 ]);
	end
	pos = zeros(nnod,2) ;

	for elem=1:nelem
		% Coordenadas globales de los nodos segun X e Y 
		x = coordnod( conectiv(elem,:) ,1 ) ;
		y = coordnod( conectiv(elem,:) ,2 ) ;
		DeltaX = x(2)-x(1) ; DeltaY = y(2)-y(1) ;
		l = sqrt(DeltaX^2+DeltaY^2) ;
		% Matriz de giro de [u,v]
		Q = [ DeltaX/l   DeltaY/l    ;...
			 -DeltaY/l   DeltaX/l  ] ;

		if Modelo (3) == 1;
		plot( x, y,'ok','LineWidth', 2);
		hold on
		end
		if Modelo (4) == 1;
		plot( x, y,'-k','LineWidth', 2);
		hold on
		end


			% Ploteo los vectores de las fuerzas
			% Cargas distruibuidas a lo largo del arco
			if q_dato ~= 0 && q_tipo == 2 
				% Cantidad de vectores por elemento según las dimensiones de los mismos
				if l<1.5
					cant = 2 ;
				else
					cant = 3 ;
				end
				x_F = x(1):(x(2)-x(1))/cant:x(2) ;
				if y(1) != y(2)
					y_F = y(1):(y(2)-y(1))/cant:y(2) ;
				else
					if cant == 2
						y_F = [y(1) y(1) y(1) ] ;
					else
						y_F = [y(1) y(1) y(1) y(1)] ;
					end
				end
		if Modelo(5) == 1;
				Hq=quiver ( x_F , y_F-sign(q_dato)*offset*2 , 0 , sign(q_dato)*offset*2 , 'linewidth',1.3);
				set(Hq,'maxheadsize',0.2)
				plot(x_F,y_F-sign(q_dato)*offset*2,'linewidth',1.3)
		end
				%
				PosNod = Q' * [0 ; sign(q_dato)*offset] ; %Coordenada (x,y) del numero del nodo i
			else
				% Por si no tengo carga distribuida
				PosNod = Q' * [0 ; offset] ; %Coordenada (x,y) del numero del nodo i
			end
		

		% 
		pos(elem,1) = PosNod(1) + x(1) ; %Coordenada x del numero del nodo i
		pos(elem,2) = PosNod(2) + y(1) ; %coordenada y del numero del nodo i
		pos(elem+1,1) = PosNod(1) + x(2) ; %Coordenada x del numero del nodo j
		pos(elem+1,2) = PosNod(2) + y(2) ; %coordenada y del numero del nodo j
		%
	end
	if Modelo(5) == 1;
		% Ploteo de carga distruibuida a lo largo de eje horizontal
		if q_tipo == 1
			% Cantidad de vectores por elemento según las dimensiones de los mismos
			div = 20 ;
			x_F = [coordnod(1,1) : Largos(1)/div : coordnod(end,1)] ;
			y_F = zeros(1,length(x_F));
			if sign(q_dato) == 1
				y_F(1,:) = max(coordnod(:,2))+(offset*1.8); 
			else
				y_F(1,:) = max(coordnod(:,2))+(offset*3.5); 
			end
			Hq = quiver ( x_F , y_F , 0 , sign(q_dato)*offset*2 , 'linewidth',1.3);
			set(Hq,'maxheadsize',0.2)
			plot(x_F,y_F,'linewidth',1.3)
		end
		
		% Ploteo de cargas puntuales
		% Fuerzas puntuales verticales en la estructura
		for i=1:length(Puntuales_nodos)
			x_F = [coordnod(Puntuales_nodos(i),1)] ;
			y_F = [coordnod(Puntuales_nodos(i),2)] ;
			Hq = quiver ( x_F , y_F-sign(Puntuales_v_valores(i))*offset*3 , 0 , sign(Puntuales_v_valores(i))*offset*3 ,'linewidth',1.6,'color',[0.7,0.07,0.07]);
			set(Hq,'maxheadsize',0.2)
		end
		% Fuerzas puntuales horizontales en la estructura
		for i=1:length(Puntuales_nodos)
			x_F = [coordnod(Puntuales_nodos(i),1)] ;
			y_F = [coordnod(Puntuales_nodos(i),2)] ;
			Hq = quiver ( x_F-sign(Puntuales_h_valores(i))*offset*3 , y_F , sign(Puntuales_h_valores(i))*offset*3 , 0 ,'linewidth',1.6,'color',[0.7,0.07,0.07]);
			set(Hq,'maxheadsize',0.2)
		end
		% momentos puntuales en la estructura
		for i=1:length(Puntuales_nodos)
			if Puntuales_m_valores(i) ~= 0
				x_F = [coordnod(Puntuales_nodos(i),1)] ;
				y_F = [coordnod(Puntuales_nodos(i),2)] ;
				Hm = moment ( x_F , y_F , Puntuales_m_valores(i), offset );
			end
		end
		
	end

	% Ploteo los numeros de los nodos
	if Modelo(2) == 1 ;
		for i = 1 : nnod
			text( pos(i,1), pos(i,2), num2str(i),'Color',[0.02,0.3,0.07] )
		end
	end

	%Ploteo los apoyos de la estructura
	if Modelo (1) == 1;
		% Primero
		if rest(1) ~= 1
			[ HX , HY ] = Supports( rest(1) , coordnod(1,:) , offset*.9) ;
			plot( HX , HY , 'Color',[0.05,0.07,.4],'linewidth',2)
		end
		% Segundo
		if rest(2) ~= 1
			[ HX , HY ] = Supports( rest(2) , coordnod(end,:) , offset*.9) ;
			plot( HX , HY , 'Color',[0.05,0.07,.4],'linewidth',2)
		end
	end
	
	hold off
	title('Modelo de la estructura')
	grid on
	% Valor de escala para los ejes
	aux = max([ min(Largos)/4  1]);
	axis([min(coordnod(:,1))-aux  (aux+max(coordnod(:,1))) -(aux-min(coordnod(:,2)))  (aux+max(coordnod(:,2)))])
	axis equal
	xlabel('x [m]')
	ylabel('y [m]')

	tiempo_plotModelo = toc ;
	if Language == 1
		printf(' The time for plotting the model structure was %.2f seconds. \n',tiempo_plotModelo)
	elseif Language == 2
		printf(' El tiempo para plotear el modelo de la estructura fue de %.2f segundos. \n',tiempo_plotModelo)
	end
end

% ====================================================================================
% ====================================================================================
% ====================================================================================
% ====================================================================================
% ====================================================================================


if Ploteos(2) == 1

	tic
	% Grafico la estructura deformada e indeformada
	% Factor de escala para graficar
	Ugraf = SF * U ;
	
	% Ploteo en 2D de la estrutura con apoyos y numero de nodos
	% Define posición y tamaño de la figura en función del tamaño de la pantalla
	figure(2)
	scrsz = get(0,'ScreenSize');
	set(gcf,'Position',[scrsz(3)*0.2 scrsz(4)*0.3 scrsz(3)*0.7 scrsz(4)*.6])

	for elem=1:nelem
		% Coordenadas globales de los nodos segun X e Y 
		x = coordnod( conectiv(elem,:) ,1 ) ;
		y = coordnod( conectiv(elem,:) ,2 ) ;
		gdlelem = conec2gdlframe (conectiv , elem ) ;
		%Posición deformada
		xdef = x + Ugraf(gdlelem(1:3:end)) ;
		ydef = y + Ugraf(gdlelem(2:3:end)) ;

		plot( x, y,'-k','LineWidth', 2);
		hold on
		plot( xdef, ydef,'-b','LineWidth', 2) ;

	end

	hold off
	title('Indeformada VS Deformada')
	grid on
	% Valor de escala para los ejes
	aux = max([ min(Largos)/4  1]);
	axis([min(coordnod(:,1))-aux  (aux + max([ max(coordnod(:,1))+Ugraf(3*nnod-2) max(coordnod(:,1)) ])) -(aux-min([min(Ugraf) min(coordnod(:,2))]))  (aux+max([ max(coordnod(:,2))+max(Ugraf) max(coordnod(:,2)) ]))])
	axis equal
	xlabel('x [m]')
	ylabel('y [m]')

	tiempo_plot2D = toc ;
	if Language == 1
		printf(' The time for plotting the deformed structure was %.2f seconds. \n',tiempo_plot2D)
	elseif Language == 2
		printf(' El tiempo para plotear la estructura deformada fue de %.2f segundos \n',tiempo_plot2D)
	end
end

% ----------------------------------------------
% --------  Solicitaciones  --------------------------


tic

% Numero de divisiones por elemento para calculo de solicitaciones
num = 3 ;
V_tot = zeros(nelem*(num-1)+nnod,1) ;
M_tot = zeros(nelem*(num-1)+nnod,1) ;
R_tot = zeros(nelem*(num-1)+nnod,1) ;



for elem = 1:nelem
	%
	% Coordenadas globales de los nodos segun X e Y 
	x = coordnod( conectiv(elem,:) ,1 ) ;
	y = coordnod( conectiv(elem,:) ,2 ) ;
	DeltaX = x(2)-x(1) ; DeltaY = y(2)-y(1) ;
	l = sqrt(DeltaX^2+DeltaY^2) ;
	% Paso para los gráficos
	paso = l/num ;  
	%
	% Se calcula la matriz de cambio de base
	Icb = [ DeltaX/l   DeltaY/l 0   ;...
		 -DeltaY/l   DeltaX/l 0   ;...
		  0			 0		  1 ] ;
	% Matriz de giro
	O = zeros(3,3); % Matriz de ceros de 2x2
	Q = [ Icb  O     ;...
		  O	   Icb ] ;
	% Matriz de giro de [u,v]
	Qq = [ DeltaX/l   DeltaY/l    ;...
		 -DeltaY/l   DeltaX/l  ] ;
	% Grados de libertad del elemento
	gdlelem = conec2gdlframe (conectiv , elem ) ;
	%
	% Desplazamientos de nodos del elemento en coordenadas locales
	desp = Q * U(gdlelem) ; 
	%
	% Vector de posición para los gráficos en coordenalas locales
	X = 0 : paso : l ;
	% Nuevos vectores de coordenadas para ploteo
	X_plot = x(1):(x(2)-x(1))/num:x(2) ;
	%~ Y_plot = y(1):(y(2)-y(1))/num:y(2) ;
	if y(1) != y(2)
		Y_plot = y(1):(y(2)-y(1))/num:y(2) ;
	else
		Y_plot = [y(1) y(1) y(1) y(1)] ;
	end
	% --- Solicitaciones ---
	%
	V = zeros(size(X));
	M = zeros(size(X));
	R = zeros(size(X));
	
	for i=1:length(V),
	  %
	%~ cd funciones_de_forma
		N = formater(X(i),l) ;
		V(i) = N * desp([2,3,5,6])*E*I ;
	    N = formaseg(X(i),l);
	    M(i) = -N * desp([2,3,5,6]) * E*I ;
		N = formatrusspri(X(i),l);
		R(i) = N * desp([1,4]) * E * A ;
	%~ cd ..
	  %
	end
	V_tot([1+(num+1)*(elem-1):(num+1)*elem]) = V ;
	M_tot([1+(num+1)*(elem-1):(num+1)*elem]) = M ;
	R_tot([1+(num+1)*(elem-1):(num+1)*elem]) = R ;

end


% Escalo solictaciones para que se vean bien
if max(Largos) < 2*min(Largos)
	e = min([ min([max(abs(coordnod(:,1))) max(abs(coordnod(:,2)))])/4 0.4 ]);
else
	e = max([ min([max(abs(coordnod(:,1))) max(abs(coordnod(:,2)))])/4 0.4 ]);
end
%~ e = max(coordnod(:,2))/rel ;

% Escala de solicitaciones
V_max = max(abs(V_tot));
M_max = max(abs(M_tot));
R_max = max(abs(R_tot));
%
V_tot = V_tot*e/V_max ; % Cortante
M_tot = M_tot*e/M_max ; % Momento
R_tot = R_tot*e/R_max ; % Directa

% Vectores nulos para el grafico de Solicitaciones
x_V = zeros(nelem*(num+1+2),1) ;
y_V = zeros(nelem*(num+1+2),1) ;
x_M = zeros(nelem*(num+1+2),1) ;
y_M = zeros(nelem*(num+1+2),1) ;
x_N = zeros(nelem*(num+1+2),1) ;
y_N = zeros(nelem*(num+1+2),1) ;

% Vectores nulos para comparar los signos de las solicitaciones
V_plot = zeros(nelem*(num+1+2),1) ;
M_plot = zeros(nelem*(num+1+2),1) ;
N_plot = zeros(nelem*(num+1+2),1) ;


for elem = 1:nelem
	%
	% Coordenadas globales de los nodos segun X e Y 
	x = coordnod( conectiv(elem,:) ,1 ) ;
	y = coordnod( conectiv(elem,:) ,2 ) ;
	DeltaX = x(2)-x(1) ; DeltaY = y(2)-y(1) ;
	l = sqrt(DeltaX^2+DeltaY^2) ;
	% Matriz de giro de [u,v]
	Q = [ DeltaX/l   DeltaY/l    ;...
		 -DeltaY/l   DeltaX/l  ] ;
	% Entradas de solicitación para el elemento
	gdlElem = [(num+1)*elem-num (num+1)*elem-(num-1) ...
				(num+1)*elem-(num-2) (num+1)*elem-(num-3)] ;
	%
	X_plot =[ x(1):(x(2)-x(1))/num:x(2)] ;
	%~ Y_plot = y(1):(y(2)-y(1))/num:y(2) ;
	if y(1) != y(2)
		Y_plot = y(1):(y(2)-y(1))/num:y(2) ;
	else
		Y_plot = [y(1) y(1) y(1) y(1)] ;
	end
	V_elem = V_tot(gdlElem) ;
	M_elem = M_tot(gdlElem) ;
	N_elem = R_tot(gdlElem) ;
	%
	% Escribo coordenadas de solicitación para plotear referente al punto
	for i=1:num+1
		VG_elem = Q' * [0 ; V_elem(i) ] ; %Coordenada (x,y) del cortante
		x_v(i) = VG_elem(1) + X_plot(i) ; %Coordenada x del cortante
		y_v(i) = VG_elem(2) + Y_plot(i) ; %coordenada y del cortante
		MG_elem = Q' * [0 ; M_elem(i) ] ; %Coordenada (x,y) del momento
		x_m(i) = MG_elem(1) + X_plot(i) ; %Coordenada x del momento
		y_m(i) = MG_elem(2) + Y_plot(i) ; %coordenada y del momento
		NG_elem = Q' * [0 ; N_elem(i) ] ; %Coordenada (x,y) de directa
		x_n(i) = NG_elem(1) + X_plot(i) ; %Coordenada x del directa
		y_n(i) = NG_elem(2) + Y_plot(i) ; %coordenada y del directa
	end
	%
	% Creo vectores de coordenadas, agregando las coordenadas de los nodos
	% de cada elemento, para que grafique rectángulos y no líneas
	x_v_plot = [x(1) x_v x(2)]' ;
	y_v_plot = [y(1) y_v y(2)]' ;
	x_V([1+(num+1+2)*(elem-1):(num+1+2)*elem]) = x_v_plot ;
	y_V([1+(num+1+2)*(elem-1):(num+1+2)*elem]) = y_v_plot ;
	x_m_plot = [x(1) x_m x(2)]' ;
	y_m_plot = [y(1) y_m y(2)]' ;
	x_M([1+(num+1+2)*(elem-1):(num+1+2)*elem]) = x_m_plot ;
	y_M([1+(num+1+2)*(elem-1):(num+1+2)*elem]) = y_m_plot ;
	x_n_plot = [x(1) x_n x(2)]' ;
	y_n_plot = [y(1) y_n y(2)]' ;
	x_N([1+(num+1+2)*(elem-1):(num+1+2)*elem]) = x_n_plot ;
	y_N([1+(num+1+2)*(elem-1):(num+1+2)*elem]) = y_n_plot ;
	%
	% Creo nuevo vector con valores de solicitaciones repetidos en nodos para poder
	% comparar unos con otros y ver su signo
	v_plot = [V_elem(1) V_elem' V_elem(end)]' ;
	V_plot([1+(num+1+2)*(elem-1):(num+1+2)*elem]) = v_plot ;
	m_plot = [M_elem(1) M_elem' M_elem(end)]' ;
	M_plot([1+(num+1+2)*(elem-1):(num+1+2)*elem]) = m_plot ;
	n_plot = [N_elem(1) N_elem' N_elem(end)]' ;
	N_plot([1+(num+1+2)*(elem-1):(num+1+2)*elem]) = n_plot ;
	%
end

tiempo_solicitaciones = toc ;
if Language == 1
	printf(' The time for calculating the stresses was %.2f seconds. \n',tiempo_solicitaciones)
elseif Language == 2
	printf(' El tiempo para calcular las solicitaciones fue de %.2f segundos \n',tiempo_solicitaciones)
end

%==================================================
%========= Ploteo de cada solicitación ============


% Vectores de posición para el numero de los nodos
esc_numeros = 0.05 ;
offset = max([ min(Largos)*esc_numeros 0.1 ]);

tic

x = coordnod( : ,1 ) ;
y = coordnod( : ,2 ) ;
%
if Ploteos(3) == 1
	% ============= Cortante ===============
	% Define posición y tamaño de la figura en función del tamaño de la pantalla
	figure(3)
	scrsz = get(0,'ScreenSize');
	set(gcf,'Position',[scrsz(3)*0.2 scrsz(4)*0.3 scrsz(3)*0.7 scrsz(4)*.6])
	% Plot de la estructura indeformada
	plot(x,y,'k-')
	hold on
	% Plot del diagrama
	for i = 1:length(x_V)/6
		gdlelem = [6*i-5 6*i-4 6*i-3 6*i-2 6*i-1 6*i];
		DeltaX = x_V(gdlelem(6))-x_V(gdlelem(1)); DeltaY = y_V(gdlelem(6))-y_V(gdlelem(1)) ;
		l = sqrt(DeltaX^2+DeltaY^2) ;
		if sign(V_plot(6*i-5)) == 1
			if VerVal == 1
				text( x_V(gdlelem(2))-offset/2,y_V(gdlelem(2))+offset/2, num2str(V_plot(6*i-5)/e*V_max,'%10.2f') ...
				,'Color','b',"Rotation",DeltaX/l*180/pi)
			end
			plot(x_V(gdlelem),y_V(gdlelem),'b-','LineWidth', 2)
		else
			if VerVal == 1
				text( x_V(gdlelem(2))-offset/2,y_V(gdlelem(2))-offset/2, num2str(V_plot(6*i-5)/e*V_max,'%10.2f'),...
				'Color','r',"Rotation",DeltaX/l*180/pi)
			end
			plot(x_V(gdlelem),y_V(gdlelem),'r-','LineWidth', 2)
		end
	end

	hold off
	title('Cortante')
	grid on
	axis([min([ min(coordnod(:,1)) min(x_V)])-e/2  max([ max(coordnod(:,1)) max(x_V)])+e/2 -(e/2-min([min(coordnod(:,2)) min(y_V)]))  max([ max(coordnod(:,2)) max(y_V)])+e/2 ])
	axis equal
	xlabel('x [m]')
	ylabel('y [m]')
	%
end

if Ploteos(4) == 1
	% =============== Momento ===============
	% Define posición y tamaño de la figura en función del tamaño de la pantalla
	figure(4)
	scrsz = get(0,'ScreenSize');
	set(gcf,'Position',[scrsz(3)*0.2 scrsz(4)*0.3 scrsz(3)*0.7 scrsz(4)*.6])
	plot(x,y,'k-')
	hold on
	for i = 1:length(x_M)/6
		gdlelem = [6*i-5 6*i-4 6*i-3 6*i-2 6*i-1 6*i];
		if sign(M_plot(6*i-5)) == 1
			if VerVal == 1
				text( x_M(gdlelem(2))-offset/2,y_M(gdlelem(2))+offset/2, num2str(M_plot(6*i-5)/e*M_max,'%10.2f') ...
				,'Color','b',"Rotation",DeltaX/l*180/pi)
			end
			plot(x_M(gdlelem),y_M(gdlelem),'b-','LineWidth', 2)
		else
			if VerVal == 1
				text( x_M(gdlelem(2))-offset/2,y_M(gdlelem(2))-offset/2, num2str(M_plot(6*i-5)/e*M_max,'%10.2f'),...
				'Color','r',"Rotation",DeltaX/l*180/pi)
			end
			plot(x_M(gdlelem),y_M(gdlelem),'r-','LineWidth', 2)
		end
	end
	hold off
	title('Momento')
	grid on
	axis([min([ min(coordnod(:,1)) min(x_M)])-e/2  max([ max(coordnod(:,1)) max(x_M)])+e/2 -(e/2-min([min(coordnod(:,2)) min(y_M)]))  max([ max(coordnod(:,2)) max(y_M)])+e/2 ])
	axis equal
	xlabel('x [m]')
	ylabel('y [m]')
	%
end

if Ploteos(5) == 1

	% =============== Directa ===============
	% Define posición y tamaño de la figura en función del tamaño de la pantalla
	figure(5)
	scrsz = get(0,'ScreenSize');
	set(gcf,'Position',[scrsz(3)*0.2 scrsz(4)*0.3 scrsz(3)*0.7 scrsz(4)*.6])
	plot(x,y,'k-')
	hold on
	for i = 1:length(x_N)/6
		gdlelem = [6*i-5 6*i-4 6*i-3 6*i-2 6*i-1 6*i];
		if sign(N_plot(6*i-5)) == 1
			if VerVal == 1
				text( x_N(gdlelem(2))-offset/2,y_N(gdlelem(2))+offset/2, num2str(N_plot(6*i-5)/e*R_max,'%10.2f') ...
				,'Color','b',"Rotation",DeltaX/l*180/pi)
			end
			plot(x_N(gdlelem),y_N(gdlelem),'b-','LineWidth', 2)
		else
			if VerVal == 1
				text( x_N(gdlelem(2))-offset/2,y_N(gdlelem(2))-offset/2, num2str(N_plot(6*i-5)/e*R_max,'%10.2f'),...
				'Color','r',"Rotation",DeltaX/l*180/pi)
			end
			plot(x_N(gdlelem),y_N(gdlelem),'r-','LineWidth', 2)
		end
	end
	hold off
	title('Directa')
	grid on
	axis([min([ min(coordnod(:,1)) min(x_N)])-e/2  max([ max(coordnod(:,1)) max(x_N)])+e/2 -(e/2-min([min(coordnod(:,2)) min(y_N)]))  max([ max(coordnod(:,2)) max(y_N)])+e/2 ])
	axis equal
	xlabel('x [m]')
	ylabel('y [m]')

end

tiempo_plotsolicitaciones = toc ;

if Ploteos(3) == 1 || Ploteos(4) == 1 || Ploteos(5) == 1
	if Language == 1
		printf(' The time for plotting the stresses was %.2f seconds. \n',tiempo_plotsolicitaciones)
	elseif Language == 2
		printf(' El tiempo para plotear las solicitaciones fue de %.2f segundos \n',tiempo_plotsolicitaciones)
	end
end






