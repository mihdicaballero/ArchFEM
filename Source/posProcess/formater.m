% --- shape functions third derivative ---
function N = formater (x , l)

N1 =  (12) / l^3 ;
N2 =  (6 ) / l^2 ;
N3 = -(12) /l^3 ;
N4 =  (6 ) /l^2 ;

N= [N1 N2 N3 N4] ;

end
