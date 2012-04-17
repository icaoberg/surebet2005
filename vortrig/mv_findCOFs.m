function [totalCOF, objCOFs] = mv_findCOFs( objlist, img)

% [TOTALCOF, OBJCOFS] = MV_FINDCOFS( OBJLIST, IMG)
%
% Finds the Center Of Fluorescence (COF) for each object in the
% OBJLIST list of objects, as well as the overall COF.
% IMG is the graylevel image (prior to binarization) that the 
% objects were found from. This is necessary because we want
% to weight the pixel coordinates with their respective graylevel
% values.

Size = size(img);
NObj = length( objlist);
objCOFs = zeros( 3, NObj);
TotalSum = [0;0;0];
TotalGray = 0;
for o = 1 : NObj % For each object
    % Get the (y,x,z) coordinates
    v = double( objlist{o}.voxels);
    % Get the graylevel values
    idx = sub2ind( Size, v(1,:), v(2,:), v(3,:));
    graylevel = double( img( idx));
    GraySum = sum( graylevel);
    % Do graylevel weighted coordinate sum
    graylevel = repmat( graylevel, [3 1]);
    CoordSum = sum(v .* graylevel, 2);
    % Find object COFs
    objCOFs(:,o) = CoordSum/GraySum;
    % Add up for Total COF
    TotalSum = TotalSum + CoordSum;
    TotalGray = TotalGray + GraySum;
end
totalCOF = TotalSum/TotalGray;
