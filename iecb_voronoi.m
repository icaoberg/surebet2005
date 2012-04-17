function iecb_voronoi( classDir, dnaDir, extension )
% Modified ER_ATTO_SEGMENT3
% Original code constructed by Ed Roques and Mel Velliste
% Updates and modifications
% EGO 06/02/05
% IECB 07/90/05


% INPUT CHECK
% -----------
% Check number of arguments
if nargin ~= 3
    warning('Wrong number of arguments.');
    return
end

% FILE HANDLING
% -------------
% Verify the contents of the folder
[files, num_files, cDir] = er_file_check([classDir '/' dnaDir '/']);

% Assuming a pattern in file names, get index
dnaInd = [];
for i = 1:num_files
    if findstr(files{i}, extension)
        dnaInd = [dnaInd i];
    end
end

unix(['cd ' classDir]);
unix(['mkdir ' classDir 'crop']);

% PROCESSING
% ----------
% Insert a way of selecting a single image from the 3D stack

for fi = 1:(num_files) 
    clc
    % Read raw image and convert to double
    dna = mv_readimage([cDir files{dnaInd(fi)}]);
    fprintf(1, '%s\n', [cDir files{dnaInd(fi)}]);
    
    % dna = double(dna(:,:,1)); 
    % Comment: If this line is left in dwarf
    % produces errors. Verify Elvira's results for possible
    % incompabilities
    
    disp('Remove background...')
    dna = mv_sub_bg(dna);
    dna = (dna*255)/max(max(dna));
    disp('Threshold...')
    % If the mv_choosethresh function fails use 
    threshDna = graythresh( dna );
    % threshDna = mv_choosethresh(dna)/255;
    dnaBin = im2bw(uint8(dna), threshDna); 
    
    % OBJECTFINDING
    % -------------
    disp('Find objects...')
    findholes = 0;
    dnaobj = mv_3dfindobj( dnaBin, findholes, 10); 
    % Find those objects that are large enough to be nuclei and are
    % not touching the edge of the image
    % dnaobj is a structure
    nuclei_obj = filter_nuclei( dnaobj, size(dnaBin) );
    
    % SEED IMAGE
    % ----------
    disp('Seed image...')
    % Create empty image
    seedimg = uint16( zeros( size( dnaBin ) ) );
    % Determine the number of nuclei
    number_of_nuclei = length( nuclei_obj );
    for i = 1 : number_of_nuclei
        % Get the voxels that describe the nuclear object
        v = double(nuclei_obj{i}.voxels);
        seedimg(sub2ind(size(dnaBin),v(1,:),v(2,:))) = i;
    end
    % Add an additional seed region containing the edges of the image
    % This is to help get rid of partial cells
    seedimg(:,[1 end]) = number_of_nuclei + 1;
    seedimg([1 end],:) = number_of_nuclei + 1;    
    
    % LOCATION FINDER
    % ---------------
    % Find the center of fluorescence of each of the objects
    [totalCof, objCofs] = mv_findCOFs( nuclei_obj, dna);
    [totalCofAll, objCofsAll] = mv_findCOFs( dnaobj, dna );
    % Turn the center of fluorescence into seeds for Delaunay tesselation
    objy = objCofsAll(1,:);
    objx = objCofsAll(2,:);
    
    % DELAUNAY TESSELATION
    % --------------------
    disp('Voronoi...')
    [vx, vy] = voronoi( objx, objy );
    % Create empty image
    newIm = zeros(size(dna));
    %Connects all the vertices of the Voronoi diagram
    for i = 1:size(vx,2) 
        newIm = er_draw_line2(vy(1,i), vx(1, i), vy(2, i), vx(2, i), newIm, 30);
    end
    %Connects the four corners of the image
    newIm = er_draw_line2(1,1,1,size(newIm,2),newIm, 30);
    newIm = er_draw_line2(1,size(newIm,2),size(newIm,1), ...
        size(newIm,2),newIm, 30);
    newIm = er_draw_line2(size(newIm,1),size(newIm,2), ...
        size(newIm,1),1, newIm, 30);
    newIm = er_draw_line2(size(newIm,1),1,1,1,newIm, 30);
    % Creates binary image    
    segLines = im2bw(newIm, 1);
    
    dnaBin2 = double(dnaBin);
    segLines2 = double(segLines);
    totimg = segLines2+dnaBin2;
    totimg = 255*totimg;
    totimg = uint8(totimg);
    
    % MASK
    % ----    
    disp('Save mask...')
    segLabel = bwlabel(imcomplement(segLines),4);
    
    list = [];
    exc = [];
    for i = 1:size(objCofs,2)
        r = segLabel(round(objCofs(1,i)), round(objCofs(2,i)));
        if (find(list==r))
            exc = [exc r];
        else
            list = [list r];
        end
    end
    
    
    for i = 1 : number_of_nuclei
        mask = zeros(size(dna));
        % get nuclei region number;
        reg = segLabel(round(objCofs(1,i)), round(objCofs(2,i)));
        if (find(exc~=reg))
            mask(find(segLabel == reg)) = 1;
        end
        masks{i} = mask;
    end
    
    % SAVE MASK TO FILE
    disp('Save to file')
    dirNameMin = files{dnaInd(fi)}(1:length(files{dnaInd(fi)})-4);
    dirNameMin(find(dirNameMin==' ')) = '_';
    dirName = [classDir 'crop/' dirNameMin '/']
    unix(['mkdir ' dirNameMin ]);
    for i = 1:number_of_nuclei
        if ((max(max(masks{i}))) == 0) 
            continue; 
        end
        imwrite(masks{i}, [dirName 'crop_' num2str(i) '.tif'], 'tiff');
    end
    disp('Done')
end
disp('Finished')
