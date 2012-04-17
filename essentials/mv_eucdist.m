function Distances = mv_eucdist( Center, Points)

% DISTANCES = MV_EUCDIST( CENTER, POINTS)
%
% Finds the euclidian distance of each and every point in POINTS
% (a list of N points, DxN matrix, where columns are [y;x] or 
% [y;x;z] or whatever, depending on D, the number of dimensions),
% with respect to the CENTER point. CENTER is also in the form
% [y;x;z].

ScaleFactor = 203/48.8;
NPoints = size( Points, 2);
NDims = size( Points, 1);
diff = Points - repmat( Center, [1 NPoints]);
if( NDims == 3)
    diff(3,:) = diff(3,:) * ScaleFactor;
end
Distances = sqrt(sum( diff.^2, 1));

