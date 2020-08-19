# -------------------------------------
# newton raphson iteration
# -------------------------------------

% assign current load factor adding a multiple of the incremental load 
currLoadFactor =  targetLoadFactor/nLoadSteps + targetLoadFactor/nLoadSteps * (loadIter-1) ;
LoadFactors(loadIter) = currLoadFactor ;

FextG  = Fext * currLoadFactor ;

% Residual
Resred = FintGk(freedofs) - FextG(freedofs) ;

% incremental displacement
deltaured = KTred \ ( - Resred ) ;

normadeltau = norm( deltaured   )   ;
normaUk     = norm( Uk(freedofs ) ) ;
normaR      = norm( Resred ) ;

Uk ( freedofs ) = Uk(freedofs ) + deltaured ;
