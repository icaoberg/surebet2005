function s = mv_sparse( matrix)

% S = MV_SPARSE( MATRIX)
%
% Makes a sparse N-D matrix from a full N-D matrix
%
% Note that matlab's SPARSE/FULL functions only handle 2D matrices.

dimensions = size( matrix);
positions = uint32(find( matrix));
values = matrix( positions);
if( length( positions) == 0)
  values = matrix(1);
else
  if( length( find(values == 1)) == length( values))
    values = values(1); % in this case we have a binary image
  end
end
s = struct('dim',dimensions,'pos',positions,'val',values);
