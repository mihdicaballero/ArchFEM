# ------------------------------------------------------
# implemented following Section 4.4.2 de Souza Neto et al
# ------------------------------------------------------

FextG  = Fext * currLoadFactor ;

% Residual
Resred = FintGk(freedofs) - FextG(freedofs) ;

% incremental displacement
indepterm = [ -Resred  Fext(freedofs) ] ;

aux = KTred \ indepterm ;

deltauast = aux(:,1) ;
deltaubar = aux(:,2) ;

if dispIter == 1
  if loadIter == 1
  	deltalambda = targetLoadFactor / nLoadSteps ;
  else
    aux = sign( convDeltau' * deltaubar ) ;
    deltalambda =   incremarclen * aux / ( sqrt( deltaubar' * deltaubar ) ) ;
  end
else
  ca =    deltaubar' * deltaubar ;
  cb = 2*(currDeltau + deltauast)' * deltaubar ;
  cc = (currDeltau + deltauast)' * (currDeltau + deltauast) - incremarclen^2 ; 
  disc = sqrt(cb^2-4*ca*cc) ;
  
  sols = -cb/(2*ca) + disc/(2*ca)*[-1 +1]' ;
  
  vals = [ ( currDeltau + deltauast + deltaubar * sols(1) )' * currDeltau;
           ( currDeltau + deltauast + deltaubar * sols(2) )' * currDeltau ] ;
 
  deltalambda = sols( find( vals == max(vals) ) ) ;
end

currLoadFactor = currLoadFactor + deltalambda(1) ;

deltaured = deltauast + deltalambda(1) * deltaubar ;

normadeltau = norm( deltaured   )   ;
normaUk     = norm( Uk(freedofs ) ) ;

Uk ( freedofs ) = Uk(freedofs ) + deltaured ;
currDeltau      = currDeltau    + deltaured ;
