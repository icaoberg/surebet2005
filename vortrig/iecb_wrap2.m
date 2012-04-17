function iecb_wrap2( classDir, dnaDir, extension )

% Input Check
iecb_inputcheck( nargin, 3 )

%File Handling
%Verifies the contents of the folder
[files, num_files, cDir] = er_file_check([classDir '/' dnaDir '/' ]);

dnaInd = [];
for i=1:1:num_files
    if findstr(files{i}, extension)
    %The findstr finds a string within a string 
        dnaInd = [dnaInd i];
    end
end