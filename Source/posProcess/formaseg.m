% --- shape functions second derivative ---
function N = formaseg (x , l)

N1 =  (12*x-6*l )  / l^3 ;
N2 =  (6*x-4*l )   / l^2 ;
N3 = -(12*x - 6*l) /l^3 ;
N4 =  (6*x - 2*l ) /l^2 ;

N= [N1 N2 N3 N4] ;

end
