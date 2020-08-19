% ========================================================
% Herramienta realizada por estudiantes en el curso
% Métodos Computacionales Aplicados al Cálculo Estructural
%
% v1.0 Noviembre de 2014
% v2.0 Noviembre de 2015
%
% Mihdí Caballero / Yessica Rodríguez / Francisco Vidovich

% Enviar dudas y sugerencias a mcaballero@fing.edu.uy

% Introducción al programa y elección de tipo de problema
%
% Cerramos todo lo anterior abierto y borramos todas las variables existentes
%
close all, clc, clear all



disp(' ===========================================================================')
disp(' ===========================================================================')
disp('      ______   ______   ______   __  __   ______  ______   __    __      ')
disp('     /\  __ \ /\  == \ /\  ___\ /\ \_\ \ /\  ___\/\  ___\ /\ `-./  \     ')
disp('     \ \  __ \\ \  __< \ \ \____\ \  __ \\ \  __\\ \  __\ \ \ \-./\ \    ')
disp('      \ \_\ \_\\ \_\ \_\\ \_____\\ \_\ \_\\ \_\   \ \____ \\ \_\ \ \_\   ')
disp('       \/_/\/_/ \/_/ /_/ \/_____/ \/_/\/_/ \/_/    \/_____/ \/_/  \/_/   ')
disp('')
disp(' ===========================================================================')
disp(' ===========================================================================')
disp('')
disp('                Choose language          Elija idioma')
disp('                1 = English              2 = Espanol')


try
	Language = input('                                 ans: ') ;
	while length(Language) == 0 || (Language ~= 1 & Language ~= 2) 
		disp(" That's not an anavailable option, choose again. \n Esa no es una opcion disponible, elija de nuevo")
		Language = input(' ans: ') ;
	end
	%
catch
	disp(" The option entered is not correct, try again. \n La opcion ingresada no es correcta, pruebe de nuevo.")
	Language = input(' ans: ') ;
	while length(Language) == 0 || (Language ~= 1 & Language ~= 2) 
		disp(" That's not an anavailable option, choose again. \n Esa no es una opcion disponible, elija de nuevo")
		Language = input(' ans: ') ;
	end
	%
end

%
if Language == 1
%
	disp(' ===========================================================================')
	disp(' ========================== ARCHES ANALYSIS PROGRAM ========================')
	disp(' ===========================================================================')
	%
	printf('\n Choose which type of arch would you like to analyze: \n\n')
	disp(' 1 = Circular arch   ')
	disp('            , - ,             ')
	disp('        , "       " ,	  	    ')
	disp('      ,               ,       ')
	disp('     ,                 ,      ')
	disp('     ^                 ^	    ')
	disp('')
	disp(' 2 = Parabolic arch')
	disp('           , - ,             ')
	disp('        ,"       ",	  	   ')
	disp('       ,           ,         ')
	disp('      ,             ,        ')
	disp('     ,               ,       ')
	disp('     ^               ^       ')
	disp('')
	disp(' 3 = Catenary arch')
	disp('          ,-,               ')
	disp('        ,"   ",	          ')
	disp('       ,       ,            ')
	disp('      ,         ,           ')
	disp('     ,           ,          ')
	disp('     ^           ^          ')
	disp('')
	%

	try
	tipo = input(' Type: ') ;
	while length(tipo) == 0 || (tipo ~= 1 & tipo ~= 2 & tipo ~= 3) 
		disp(" That's not an anavailable option, choose again")
		tipo = input(' Type: ') ;
	end
	%
	catch
	disp(' The option entered is not correct, try again')
	tipo = input(' Type: ') ;
	while length(tipo) == 0 || (tipo ~= 1 & tipo ~= 2 & tipo ~= 3) 
		disp(" That's not an anavailable option, choose again")
		tipo = input(' Type: ') ;
	end
	%
	end

	if tipo == 1
	disp('')
	disp(' Edit the input values for this type of arch.')
	disp(' If you have already entered the input values, saved the file and wish')
	disp(' to continue, press Enter.') ; input('') ;
	cd Source
		cd preProcess
			pre_circular
		cd ..
		if ap_error == 1
			cd ..
			return
		end
		if nod_error == 1
			cd ..
			return
		end
		Process
		cd posProcess
			ploteos
			output
		cd ..
	cd ..
	elseif tipo ==2
	disp('')
	disp(' Edit the input values for this type of arch.')
	disp(' If you have already entered the input values, saved the file and wish')
	disp(' to continue, press Enter.') ; input('') ;
	cd Source
		cd preProcess
			pre_parabolico
		cd ..
		if ap_error == 1
			cd ..
			return
		end
		if nod_error == 1
			cd ..
			return
		end
		Process
		cd posProcess
			ploteos
			output
		cd ..
	cd ..
	else
	disp('')
	disp(' Edit the input values for this type of arch.')
	disp(' If you have already entered the input values, saved the file and wish')
	disp(' to continue, press Enter.') ; input('') ;
	cd Source
		cd preProcess
			pre_catenaria
		cd ..
		if ap_error == 1
			cd ..
			return
		end
		if nod_error == 1
			cd ..
			return
		end
		Process
		cd posProcess
			ploteos
			output
		cd ..
	cd ..
	end
elseif Language == 2
%                                 
	disp(' ===========================================================================')
	disp(' ======================= PROGRAMA DE ANALISIS DE ARCOS =====================')
	disp(' ===========================================================================')
	%
	printf('\n Elija que tipo de arco quiere estudiar: \n\n')
	disp(' 1 = Arco con forma circular   ')
	disp('            , - ,             ')
	disp('        , "       " ,	  	    ')
	disp('      ,               ,       ')
	disp('     ,                 ,      ')
	disp('     ^                 ^	    ')
	disp('')
	disp(' 2 = Arco con forma parabolica')
	disp('           , - ,             ')
	disp('        ,"       ",	  	   ')
	disp('       ,           ,         ')
	disp('      ,             ,        ')
	disp('     ,               ,       ')
	disp('     ^               ^       ')
	disp('')
	disp(' 3 = Arco con forma catenaria')
	disp('          ,-,               ')
	disp('        ,"   ",	          ')
	disp('       ,       ,            ')
	disp('      ,         ,           ')
	disp('     ,           ,          ')
	disp('     ^           ^          ')
	disp('')
	%

	try
	tipo = input(' Tipo: ') ;
		while length(tipo) == 0 || (tipo ~= 1 & tipo ~= 2 & tipo ~= 3) 
			disp(' Esa no es una opcion disponible, elija de nuevo')
			tipo = input(' Tipo: ') ;
		end
	%
	catch
	disp(' La opcion ingresada no es correcta, pruebe de nuevo')
		tipo = input(' Tipo: ') ;
		while length(tipo) == 0 || (tipo ~= 1 & tipo ~= 2 & tipo ~= 3) 
			disp(' Esa no es una opcion disponible, elija de nuevo')
			tipo = input(' Tipo: ') ;
		end
	%
	end

	if tipo == 1
	disp('')
	disp(' Edite los valores de entrada para este tipo de arco.')
	disp(' Si ya ha ingresado los datos de entrada, guardado el archivo y desea')
	disp(' continuar, oprima Enter.') ; input('') ;
	cd Source
		cd preProcess
			pre_circular
		cd ..
		if ap_error == 1
			cd ..
			return
		end
		if nod_error == 1
			cd ..
			return
		end
		Process
		cd posProcess
			ploteos
			output
		cd ..
	cd ..
	elseif tipo ==2
	disp('')
	disp(' Edite los valores de entrada para este tipo de arco.')
	disp(' Si ya ha ingresado los datos de entrada, guardado el archivo y desea')
	disp(' continuar, oprima Enter.') ; input('') ;
	cd Source
		cd preProcess
			pre_parabolico
		cd ..
		if ap_error == 1
			cd ..
			return
		end
		if nod_error == 1
			cd ..
			return
		end
		Process
		cd posProcess
			ploteos
			output
		cd ..
	cd ..
	else
	disp('')
	disp(' Edite los valores de entrada para este tipo de arco.')
	disp(' Si ya ha ingresado los datos de entrada, guardado el archivo y desea')
	disp(' continuar, oprima Enter.') ; input('') ;
	cd Source
		cd preProcess
			pre_catenaria
		cd ..
		if ap_error == 1
			cd ..
			return
		end
		if nod_error == 1
			cd ..
			return
		end
		Process
		cd posProcess
			ploteos
			output
		cd ..
	cd ..
	end
end























