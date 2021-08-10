% Nonlinear analysis of arches with corotational finite element
% Mihdi Caballero - November 2017
nLoadSteps = 2; solutionMethod = 1; targetLoadFactor = 1;
NRtoldeltau = 1e-6; NRtolits = 20 ; numbercontroldof = 1 ; controldof_1 = 3*10+2

% Initialization of variables for iteration
Uk      = zeros( 3*nnod,   1 ) ;  % Displacement and slopes of nodes in equilibrium
uks1     = zeros( nLoadSteps, 1 ) ;  % Displacement and slopes of nodes in every load step
uks2     = zeros( nLoadSteps, 1 ) ;  % Displacement and slopes of nodes in every load step
fks     = zeros( nLoadSteps, 1 ) ;  % Forces in the structure in every load step
Thetask = zeros( nelem,     1 ) ;  % Slope of nodes in every load step
Itsnums = zeros( nLoadSteps, 1 ) ;  % Numver of iteration in every load step
factorescriticos = [] ;

reachedtargetLF = 0; % reach target load factor flag
loadIter = 0 ; % counter of the load iterations

loadfactors = 0; % first load factor

convDeltau = zeros(length(freedofs),1) ; % Convergence Delta u
%~ currDeltau = zeros(length(freedofs),1) ; % Current Delta u

currLoadFactor = 0; % Current load factor

% print in screen starts with header row
fprintf('----------------------------------------------- \n')
%~ fprintf([ 'loadIncr & LoadFactr & dispits  & maxStrain (%%) & BucklingFac ' ...
%~ ' & npos & nneg  & \n'] )
fprintf([ 'loadIncr  & LoadFactr & iter & BucklingFactr &  npos & nneg\n'] )
prodvals=1;

%~ filestressoutput = [outputdir  '/output_stresses.txt' ];
%~ fidstress = fopen(filestressoutput,'w');


tic;

% load step increment stopping criteria: target load
while ( reachedtargetLF == 0 ) % while the flag is still 0

	loadIter += 1 ; 	% increase load iterarion counter
	dispConverged = 0 ; % Display convergence
	dispIter      = 0 ; % Display interation counter
	currDeltau = zeros(length(freedofs),1) ; % Current Delta u
	%~ % ----------------------------------
	%~ % iteration in displacements (NR) or load-displacements (NR-AL)
	%~ % stopping criteria: convergence in forces
	while ( dispConverged == 0 ) % While there's no coenvergence iterate for one load step
		dispIter += 1 ; % Increase display iteration

		assembly

		if solutionMethod == 1
		  % performs one newton-raphson iteration
		  NR_iter

		elseif solutionMethod == 2
		  % performs one newton-raphson-arc-length iteration
		  NR_AL_iter
		end

		% stopping criteria
		%~ if ( ( normaR < NRtolR ) || dispIter > NRtolits )
	    if ( ( normadeltau < ( normaUk * NRtoldeltau ) ) || dispIter > NRtolits )
		  if dispIter > NRtolits,
			stopcritpar = 2;
			fprintf('Warning: displacements iteration stopped by max iterations.\n');
		  else,
			stopcritpar = 1;
		  end
		  dispConverged = 1 ;
		  Itsnums( loadIter ) = dispIter;
		end
		% -------------------------

	end

	  % ----------------------------------

	loadfactors(loadIter) = currLoadFactor ;
	if numbercontroldof == 1
		uks1(loadIter)         = sign(controldof_1) * Uk(abs(controldof_1)) ;
	else
		uks1(loadIter)         = sign(controldof_1) * Uk(abs(controldof_1)) ;
		uks2(loadIter)         = sign(controldof_2) * Uk(abs(controldof_2)) ;
	end
	fks(loadIter)		  = currLoadFactor;
	convDeltau            = currDeltau ;

	% load stopping criteria
	if (abs(currLoadFactor) >= abs(targetLoadFactor)) || ( loadIter > nLoadSteps )
		reachedtargetLF = 1 ;
	end

	% -----------------------------------
	% buckling analysis
	[vec,vals] = eig( KTred ) ;
	Keigvals = diag(vals) ;
	nKeigpos = length( find(Keigvals >  0 ) );
	nKeigneg = length( find(Keigvals <= 0 ) );

	% [a, lambtech ] = eig( KTred ,  KG0red ) ;
	% lambtech = diag(lambtech) ;
	% %
	% if length( find( lambtech >  0 ) ) > 0
	% 	lambdatech_crit = min ( lambtech ( find( lambtech >  0 ) ) ) ;
	% 	lambda_crit  = 1 / ( 1 - lambdatech_crit ) ;
	% 	factor_crit = lambda_crit * loadfactors( loadIter ) ;
	% else
	% 	factor_crit = 0;
	% end

	%~ % linearized according to Bathe
	%~ if (loadIter == 1)
		%~ KG0redBathe = KGred / currLoadFactor ;
		%~ [a,b] = eig( KL0red , - KG0redBathe ) ;
		%~ factor_crit_lin_Bathe = min( diag(b) );
	%~ end
	% -----------------------------------

	% latex table output
	% fprintf(' %4i & %12.3e  & %4i & %12.5e & %5i & %3i \\\\\n', ...
	% loadIter, currLoadFactor,  dispIter , factor_crit , nKeigpos, nKeigneg)
	% -----------------------------------

end

fprintf('----------------------------------------------- \n')

total_iterations_time_in_seconds = toc
