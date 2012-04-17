function status = mv_issparse( matrix)

% STATUS = MV_ISSPARSE( MATRIX)
%
% Tells you whether MATRIX is an MV sparse type or not.

if( isfield( matrix, 'dim') & ...
    isfield( matrix, 'pos') & ...
    isfield( matrix, 'val'))
  if( (length(matrix.val) == 1) & (length(matrix.pos)) > 1)
        status = 2; % binary matrix
  else
	status = 1;
  end
else
	status = 0;
end
