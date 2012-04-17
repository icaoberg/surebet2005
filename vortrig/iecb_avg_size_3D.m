function avg_Size = iecb_avg_size_3D( classDir, dnaDir, extension, dna )

if nargin == 0
    warning('Error in iecb_avg_size_3D: Wrong input');
elseif nargin == 3
    if exist( classDir ) & exist( dnaDir )
        [files, num_files, cDir] = er_file_check([classDir '/' dnaDir '/']);
    else
        return
    end
elseif nargin == 1
    if ~isa( dna, 'logical' )
        threshDna = graythresh( dna );
        dnaBW = im2bw( dna, threshDna ); 
        dnaBW = bwmorph( dnaBW, 'clean' );
        dnaBW = imfill( dnaBW, 'holes' );
        dnaBW = imclearborder( dnaBW, 8 );
        dnaBW = bwareaopen( dnaBW, 250 );
    else
        dnaBW = dna;
        dnaBW = bwmorph( dnaBW, 'clean' );
        dnaBW = imfill( dnaBW, 'holes' );
        dnaBW = imclearborder( dnaBW, 8 );
        dnaBW = bwareaopen( dnaBW, 250 );
    end
end

DimSize = size(dnaBW);
avg_Size = 0;
for i = 1 : DimSize( 3 )
    [label numObjects] = bwlabel( dnaBW );
    avg_Size( i, 1 ) = bwarea( dnaBW ) / numObjects;
end

avg_Size = max( avg_Size );


