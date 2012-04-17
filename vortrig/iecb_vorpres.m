function iecb_vorpres( filename, celltype )
% This simple function was only intented to create images for the final
% presentation of the Murphy Lab on August 4, 2005
% Enjoy!
% Ivan

% Creates a directory where it stores the images
mkdir([ filename ]);
cd([ filename ]);
% Read the image and load into workspace
dna = mv_readimage([ filename ]);
% Create a figure
figure(1)

% Show the original picture and save it accordingly
imshow(dna)
title(['Original image of ' celltype ])
saveas(1, 'original', 'jpg'])

% Create binary image
% Subtract background
disp('Binary image...');
dna = mv_sub_bg(dna);
% Stretch image
dna = 255 * dna / max( dna(:) );
dna = uint8( dna );
imshow( dna )
title([ 'Background subtraction of ' celltype ]);
saveas(1,[ filename 'backg_sub', 'jpg'])
disp('Threshold...')
threshDna = mv_choosethresh(dna) / 255;
dnaBin = im2bw( uint8(dna), threshDna );
imshow(dnaBin)
title('Binary image');
saveas(1, 'binary', 'jpg'])
findholes = 0;
dnaBin = uint8( dnaBin );
dnaobj = mv_3dfindobj( dnaBin, findholes, 10);
cleanfig = zeros( size(dna) );
for i=1:length(dnaobj)
    for j=1:length(dnaobj{i}.voxels(:,:,:))
        x=dnaobj{i}.voxels(:,j,:);
        cleanfig( x(1), x(2) ) = cleanfig( x(1), x(2) ) + 1;
    end
end
imshow( cleanfig );
title('Select good objects')
saveas(1, [filename 'clean', 'jpg'] );

% Find those objects that are large enough to be nuclei and are
% not touching the edge of the image
% dnaobj is a structure
% nuclei_obj = filter_nuclei( dnaobj, size(dnaBin) );
cleannuclei = cleanfig;
for i=1:length(nuclei_obj)
    for j=1:length(nuclei_obj{i}.voxels(:,:,:))
        x=nuclei_obj{i}.voxels(:,j,:);
        cleannuclei( x(1), x(2) ) = cleannuclei( x(1), x(2) ) + 1;
    end
end
imshow( cleannuclei );
title('Select good nuclei');
saveas(1, [filename 'cleannuclei', 'jpg'] );

disp('Seed image...')
% Create empty image
seedimg = uint8( zeros( size( dnaBin ) ) );
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

% Find the center of fluorescence of each of the objects
[totalCof, objCofs] = mv_findCOFs( nuclei_obj, dna);
[totalCofAll, objCofsAll] = mv_findCOFs( dnaobj, dna );
% Turn the center of fluorescence into seeds for Delaunay tesselation

objy = objCofs(1,:);
objx = objCofs(2,:);
%Corners as seeds
%[ n m ] = size(dna);
% objx( length(objx(:))+1 ) = 1;
% objy( length(objy(:))+1 ) = 1;
% 
% objx( length(objx(:))+2 ) = n;
% objy( length(objy(:))+2 ) = m;
% 
% objx( length(objx(:))+3 ) = 1;
% objy( length(objy(:))+3 ) = m;    
% 
% objx( length(objx(:))+4 ) = n;
% objy( length(objy(:))+4 ) = 1;
% cleanfig = zeros( size( dna ));
% for i=1:length(x)
%     cleanfig( x(i), y(i) ) = cleanfig( x(i), y(i) )+1;
% end
% imshow( cleanfig );
%saveas(1, [filename 'cleannuclei.jpg'] );

 disp('Voronoi...')
[vx, vy] = voronoi( objx, objy );
figure(2)
voronoi( objx, objy )
saveas(2, [filename 'voronoi.jpg'] );
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
    figure(2)
    imshow(segLines)
    title('Segmented Lines')
    saveas(1, [filename 'seglines.jpg'] );
 
    totimg = cleannuclei + segLines;
%     dnaBin2 = double(cleannuclei);
%     segLines2 = double(segLines);
%     totimg = segLines2+dnaBin2;
%     totimg = 255*totimg;
%     totimg = uint8(totimg);
    hold on
    imshow(totimg);
    plot( objx, objy, '+r' );
    figure(2)
    saveas(2, [filename 'final.jpg'])
    hold off
    title( 'Image with Voronoi diagram')
    
        hold on
    imshow(dna);
    plot( objx, objy, '+r' );
    figure(2)
    saveas(2, [filename 'cof.jpg'])
    hold off
    title( 'Center of Fluorescence')
 cd ..
