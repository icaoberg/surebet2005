function path = iecb_chooseMaxArea( classDir, dnaDir, extension )
% The function returns the image with the greatest area among a 3D stack

% FILE HANDLING
% -------------
[files, num_files, cDir] = er_file_check([classDir '/' dnaDir '/']);

dnaInd = [];

for i = 1:num_files
    if findstr(files{i}, extension)
        dnaInd = [dnaInd i];
    end
end

% PROCESSING
% ----------
clc
disp( 'Choosing the image with the greatest area...');
for i = 1:1:(num_files) 
    % Read raw image and convert to double
    image = mv_readimage([cDir files{dnaInd(i)}]);
    disp('Analizing the file...')
	fprintf(1, '%s\n', [classDir '/' dnaDir '/' files{dnaInd(i)}]);
    % Remove background
    image = double( image );
    image = mv_sub_bg( image );
    % Scale image from 0 to 255 ((2^8)-1): uint8
    % Threshold
	 threshDna = graythresh( image );
    image = im2bw( uint8( image ), threshDna );
	area(i) = bwarea( image );
    disp('Area calculation status: OKAY :) ');
end

disp( 'Choosing the image with the greatest area...');
maxArea = max(area(:));
[ x y ] = find( area == maxArea );
path = [ classDir '/' dnaDir '/' files{dnaInd(y)} ];
disp('Done');
