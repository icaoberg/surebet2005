function avgArea = iecb_avgSize3DStack( classDir, dnaDir, extension )
% IECB July 14, 2005
% Description
% -----------
% Given an image folder the
% Input
% -----
% classDir: The path that leads to the well and/or plate folder
% dnaDir: The path that leads to the Hoechst or DNA probe channel (usually channel_0)
% extension: 
% Output
% ------
% avg_Size: the average size of the objects within the image folder.

% File management
if nargin ~= 3
    % Return control if incorrect number of inputs
    warning('Error in iecb_avg_size_3D: Wrong input');
    return
else
    if exist( [ classDir '/' dnaDir ] )
        %Verify folder existence and their contents
        [files, num_files, cDir] = er_file_check([classDir '/' dnaDir '/']);
    elseif ~exist( classDir )
        %Returns a warning if they don't exist
        warning([ 'Error in iecb_avg_size_3D: Directory ' classDir ' does not exist' ]);
        return
    elseif ~exist(  [ classDir '/' dnaDir ]  )
        warning([ 'Error in iecb_avg_size_3D: Directory ' dnaDir ' does not exist' ]);
        return
    end
end

dnaInd = [];
for i = 1:num_files
    %Get the indexes of the image files
    if findstr(files{i}, extension)
        dnaInd = [dnaInd i];
    end
end

% Area calculation
avgArea = 0;
for i = 1:1:num_files
  dna = mv_readimage([cDir files{dnaInd(i)}]);
  level = graythresh( dna );
  dna = im2bw( dna, level );  
  [ dna numObjects ] = bwlabel( dna );
  avgArea = avgArea + ( bwarea( dna ) )/ numObjects;
end

avgArea = floor( avgArea / num_files );
