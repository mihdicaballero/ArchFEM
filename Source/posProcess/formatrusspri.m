% --- truss shape functions first derivative ---
function N = formatrusspri (x , l)

N1 =  -1/l ;
N2 =  1/l ;

N= [N1 N2] ;
