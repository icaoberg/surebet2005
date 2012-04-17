function path = iecb_chooseMaxInt( classDir, dnaDir, extension )

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
disp( 'Choosing the image with the greatest pixel intensity frequency...');
for i = 1:1:(num_files) 
    % Read raw image and convert to double
    image = mv_readimage([cDir files{dnaInd(i)}]);
    disp('Analizing the file...')
	fprintf(1, '%s\n', [ classDir '/' dnaDir '/' files{dnaInd(i)}]);
    maxInt(i)  = max( image(:) );
    [ x y ] = find( image == maxInt(i) );
    maxIntFreq(i) = length(x);
end

maxInt = max( maxIntFreq(:) );
[ x y ] = find( image == maxInt );
path = [ classDir '/' dnaDir '/' files{dnaInd(y)} ];
disp('Done');
