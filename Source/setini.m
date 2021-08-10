
% Geometric matrix
rg    = sqrt(I/A) ; % Radius of gyration
G    =   [ 1   0       0        ;
		   0	4*rg^2	2*rg^2  ;
		   0	2*rg^2	4*rg^2  ] ;

% Imperfection added in vertical position of nodes
if exist('addimperfection') == 1 && addimperfection == 1 
	angle = angle*pi/180 ;
	for i = 1:nelem
		coordnod(i+1,2) = coordnod(i+1,2) + coordnod(i+1,1)*tan(angle) ;
	end
end


% Degrees of freedom
% I suppose everything fixed and then I free fixities
% Let's put 0 where's no fixity
fixeddofs = [ 1  2  3 3*nnod-2 3*nnod-1 3*nnod ] ;
for i=1:2
	if rest(i) == 1
		fixeddofs([3*i-2,3*i-1,3*i]) = 0 ;
	elseif rest(i) == 2
		fixeddofs([3*i-2,3*i]) = 0 ;
	elseif rest(i) == 3
		fixeddofs([3*i]) = 0 ;
	end
end
% I remove 0s from fixeddof vector
fixeddofs(fixeddofs==0) = [] ;

freedofs = (1:(3*nnod))';
freedofs(fixeddofs) = [];

LoadFactors = 0;

% --- compute lengths and inclination of undeformed elements ---

% Initial length
Lini = sqrt( ( coordnod( conectiv(:,2),1) - coordnod( conectiv(:,1),1) ).^2 ...
		 + ( coordnod( conectiv(:,2),2) - coordnod( conectiv(:,1),2) ).^2 ) ;

% Dimension maxima segun X y segun Y
Largos = [ max(coordnod(:,1))-min(coordnod(:,1)) max(coordnod(:,2))-min(coordnod(:,2)) ];


%~ % Inicial slope
beta0 = atan2( ( coordnod( conectiv(:,2),2) - coordnod( conectiv(:,1),2) ) , ...
				   ( coordnod( conectiv(:,2),1) - coordnod( conectiv(:,1),1) ) ) ;

%~ % Cosines and sines
cosini   = cos( beta0 ) ; sinini  = sin( beta0 ) ;

%  x & y positions of every node
xelems   = reshape( coordnod( conectiv(:,1:2) ,1 )', nelem,2 ) ;
yelems   = reshape( coordnod( conectiv(:,1:2) ,2 )', nelem,2 ) ;

% Curvature of elements
curvature = zeros(length(xelems),2) ;
