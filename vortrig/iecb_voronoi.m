function iecb_voronoi( classDir, dnaDir, extension )

% ----- %
% Input %
% ----- %
[files, num_files, cDir] = er_file_check([classDir '/' dnaDir '/']);


%If the option is 2D find all the images
dnaInd = [];
for i=1:1:num_files
    if findstr(files{i}, extension)
        %The findstr finds a string within a string
        dnaInd = [dnaInd i];
    end
end

% ---------------- %
% Image Processing %
% ---------------- %
%Image processing
for index = 1 : 1: size(dnaInd, 2)
    % Read raw image and convert to double
    dna = mv_readimage([cDir files{dnaInd(index)}]);
    %Calculates threshold value
    threshDna = graythresh( dna );
    %Creates binary image of intensity image dna
    dnaBW = im2bw( dna, threshDna ); 
    %Performs morphological operations to enhance image 
    dnaBW = bwmorph( dnaBW, 'clean' );              %Removes isolated pixels
    dnaBW = imclearborder( dnaBW, 8 );              %Clears objects along the borders
    %mv_filter_nuclei( obj, imgsize )
    dnaBW = bwareaopen( dnaBW, 250 );               %Removes objects smaller than 250
    [ label, numObjects ] = bwlabel( dnaBW, 8 );    %Creates a label image of dnaBW
    %dnaobj = mv_3dfindobj( BINARY_IMAGE, FINDHOLES, MIN_OBJECT_SIZE);
    dnaBW = bwmorph( dnaBW, 'shrink', Inf );        %Reduces dnaBW objects to single points
    [x y] = find( dnaBW == 1 );                     %Get coordinates of those points
    TRI = delaunay(x, y);                           %Use qhull algorithm to calculate the vertices of the Delaunay triangulation
    [vx, vy] = voronoi(x, y, TRI);                  %Use these points as seeds for the Delaunay triangulation
    [width length height]=size(dna);
    newIm = zeros(width, length);                   %Create empty image to use later
    
    %Connect all the vertices of the Delaunay triangulation
    for i = 1:size(vx,2)
        newIm = er_draw_line2(vy(1,i), vx(1, i), vy(2, i), vx(2, i), newIm, 1);
    end
    
    %Connects the four corners of the image creating a frame around it
    newIm = er_draw_line2(1,1,1,size(newIm,2),newIm, 1);
    newIm = er_draw_line2(1,size(newIm,2),size(newIm,1), size(newIm,2),newIm, 1);
    newIm = er_draw_line2(size(newIm,1),size(newIm,2), size(newIm,1),1, newIm, 1);
    newIm = er_draw_line2(size(newIm,1),1,1,1,newIm, 1);
       
    %Total Image
    totimg = newIm + dnaBW; %Add images
    totimg = 255*totimg;       %Stretch image
    totimg = uint8(totimg);    %Change to uint8
    imwrite(newIm, [ 'vor' num2str(index) '.jpg'] ,'jpg');
end

% ------ %
% Output %
% ------ %

clc
disp('Ok!')



