%function avgSize = iecb_avg_nuc_size( classDir, dnaDir, extension )
%Returns the average size of the nuclei in pixels

%if nargin == 0
    %For example of dwarf.cbi.cmu.edu
    classDir = '/home/eog/iecb/imgdna';
    dnaDir = 'cell19';
    extension = 'bmp';
    %end

%File management
%---------------

%Verify folder and file contents
[files, num_files, cDir] = er_file_check([classDir '/' dnaDir '/']);

%Get the index for the filenames
dnaInd = [];
for i = 1:num_files
    if  findstr(files{i}, extension)
        info = imfinfo( [ classDir '/' dnaDir '/' files{i} ] );
        if info.FileSize > 2048 %Asks if greater than 2Kb
            dnaInd = [dnaInd i];
        end
    end
end

%Image processing
for index=1:1:size(dnaInd,2)
    % Read raw image and convert to double
    dna = mv_readimage([cDir files{dnaInd(index)}]);
    threshDna = graythresh( dna );
    dnaBW = im2bw( dna, threshDna ); 
    dnaBW = bwmorph( dnaBW, 'clean' );
    dnaBW = imfill( dnaBW, 'holes' );
    dnaBW = imclearborder( dnaBW, 8 );
    dnaBW = bwareaopen( dnaBW, 250 );
    [ label, numObjects ] = bwlabel( dnaBW, 8 );
    dnaBW = bwmorph( dnaBW, 'shrink', Inf );
    [x y] = find( dnaBW ~= 0 );
    [vx, vy] = voronoi(x, y);
    newIm = zeros(size(dna));
    for i = 1:size(vx,2) 
        newIm = er_draw_line2(vy(1,i), vx(1, i), vy(2, i), vx(2, i), newIm, 30);
    end
    
    newIm = er_draw_line2(1,1,1,size(newIm,2),newIm, 30);
    newIm = er_draw_line2(1,size(newIm,2),size(newIm,1), size(newIm,2),newIm, 30);
    newIm = er_draw_line2(size(newIm,1),size(newIm,2), size(newIm,1),1, newIm, 30);
    newIm = er_draw_line2(size(newIm,1),1,1,1,newIm, 30);
    segLines = im2bw(newIm, 1);
    segLines = im2bw(newIm, 1);
    dnaBin2 = double(dnaBW);
    segLines2 = double(segLines);
    totimg = segLines2+dnaBin2;
    totimg = 255*totimg;
    totimg = uint8(totimg);
    imwrite(newIm, [ 'newIm' num2str(index) '.jpg'], 'jpg')
    imwrite(newIm, [ 'totimg' num2str(index) '.jpg'], 'jpg')
end