% function for nodes-to-dof conversion
function [dofs] = nodes2dofs( nodes , degreespernode )
n    = length(nodes);
dofs = zeros( n*degreespernode , 1 ) ;
for i=1:n
  for j=1:degreespernode
    dofs( (i-1)*degreespernode +j )= degreespernode * (nodes(i)-1) +j;
  end
end
