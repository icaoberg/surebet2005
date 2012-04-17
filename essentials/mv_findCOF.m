function COF = mv_findCOF( sparseimg)

% COF = MV_FINDCOF( SPARSEIMG)
%
% Finds the Center of Fluorescence (COF) of the image
% SPARSEIMG. SPARSEIMG must be mv_sparse.

if( mv_issparse( sparseimg))
  % Get graylevel weighted coordinate average
    graylevel = double( sparseimg.val);
    graysum = sum( graylevel);
    [Y,X,Z] = ind2sub( double(sparseimg.dim), double(sparseimg.pos));
    COF(1,1) = sum(Y .* graylevel)/graysum;
    COF(2,1) = sum(X .* graylevel)/graysum;
    COF(3,1) = sum(Z .* graylevel)/graysum;
else
  error('I want a sparse image!');
end
