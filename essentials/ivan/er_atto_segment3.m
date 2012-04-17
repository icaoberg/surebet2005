function er_atto_segment3(classDir)
% ER_ATTO_SEGMENT
%
%
%

%%%%%%%%%%%%%%% INPUT CHECK %%%%%%%%%%%%%%%%%%
if nargin < 1
    fprintf(1, 'Please enter class directory.\n');
    return;
end


%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%%%%

finalResults = [];

%%%%%%%%%%%%%% FILE HANDLING %%%%%%%%%%%%%%%%%
[files, num_files, cDir] = er_file_check([classDir '/Hoechst/']);

%if rem(num_files, 3) ~= 0
%    fprintf(1, 'Non triplet directory encountered.\n');
%    return
%end

dnaInd = []; mitInd = []; alxInd = [];

for i = 1:num_files
    if findstr(files{i}, 'KSR')
	dnaInd = [dnaInd i];
    end
    if findstr(files{i}, 'Mito')
	mitInd = [mitInd i];
    end
    if findstr(files{i}, 'Alexa')
	alxInd = [alxInd i];
    end
end
%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%% PROCESSING %%%%%%%%%%%%%%%%%%%%%%
for fi = 2:(num_files) 
     % Read raw image and convert to double
     dna = mv_readimage([cDir files{dnaInd(fi)}]);
     fprintf(1, '%s\n', [cDir files{dnaInd(fi)}]);
     dna = double(dna(:,:,1));
     %figure, imshow(dna, []); pause;
     % Remove background
     dna = mv_sub_bg(dna);
   
     % Scale image from 0 to 65535 ((2^16)-1)
     dna = (dna*65535)/max(max(dna));
     %figure; imshow(dna,[])
     % Threshold
     threshDna = 0;
     eval('threshDna = mv_choosethresh(dna);', ...
	  'disp(''could not get threshold''); threshDna = 2000');%2570');
     dnaBin = im2bw(uint16(dna), threshDna/65535);  
%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%% OBJECTFINDING %%%%%%%%%%%%%%%%%%%
    
     findholes = 0;
     dnaobj = mv_3dfindobj( dnaBin, findholes, 10);
     % Find those objects that are large enough to be nuclei and are
     % not touching the edge of the image
     nuclei_obj = filter_nuclei( dnaobj, size(dnaBin));
     %nuclei_obj = dnaobj;
%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%% SEEDIM %%%%%%%%%%%%%%%%%%%%%%%
 
     seedimg = uint16(zeros(size(dnaBin)));
     number_of_nuclei = length( nuclei_obj);
     for i = 1 : number_of_nuclei
	 v = double(nuclei_obj{i}.voxels);
	 seedimg(sub2ind(size(dnaBin),v(1,:),v(2,:))) = i;
     end
     % Add an additional seed region containing the edges of the image
     % This is to help get rid of partial cells
     seedimg(:,[1 end]) = number_of_nuclei + 1;
     seedimg([1 end],:) = number_of_nuclei + 1;    
    %figure; imshow(seedimg, []);

%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%


   
%%%%%%%%%%%%%%%% LOCATION FINDER %%%%%%%%%%%%%%%%%%
     addpath /imaging2/backup/imaging/usr/matlab6/toolbox/images/images/
     [totalCof, objCofs] = mv_findCOFs( nuclei_obj, dna);
     [totalCofAll, objCofsAll] = mv_findCOFs(dnaobj, dna);
%%%%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%%%%%

     objy = objCofsAll(1,:);
     objx = objCofsAll(2,:);

%%%%%%%%%%%%%%%%%%%% DELAUNAY %%%%%%%%%%%%%%%%%%%%%%%%
     TRI = delaunay(objx, objy);
     [vx, vy] = voronoi(objx, objy, TRI);
 %    plot(objx, objy, 'o'); hold on;
 %    plot(vx, vy); axis([1 size(dna,1) 1 size(dna,2)]); axis ij;
 
     newIm = zeros(size(dna));
     for i = 1:size(vx,2) 
	 newIm = er_draw_line2(vy(1,i), vx(1, i), vy(2, i), vx(2, i), ...
			      newIm, 30);
     end
 
     newIm = er_draw_line2(1,1,1,size(newIm,2),newIm, 30);
     newIm = er_draw_line2(1,size(newIm,2),size(newIm,1), ...
                           size(newIm,2),newIm, 30);
     newIm = er_draw_line2(size(newIm,1),size(newIm,2), ...
                           size(newIm,1),1, newIm, 30);
     newIm = er_draw_line2(size(newIm,1),1,1,1,newIm, 30);
     
   %  newIm = imresize(newIm, (5/10), 'bilinear');
   %  newIm = imresize(newIm, (10/5), 'bilinear');
     %figure;
     %imshow(newIm, []); %pause;
     segLines = im2bw(newIm, 1);
     dnaBin2 = double(dnaBin);
     segLines2 = double(segLines);
     totimg = segLines2+dnaBin2;
     totimg = 255*totimg;
     totimg = uint8(totimg);
     %imshow(totimg); 

%%%%%%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%%%%
     


%%%%%%%%%%%%%%%%% MASK %%%%%%%%%%%%%%%%%%%%%%%%%%%

    segLabel = bwlabel(imcomplement(segLines),4);
 %   figure, imshow(segLabel, []);
 %   pause;
 
    
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
%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%% SAVE SEG %%%%%%%%%%%%%%%%%%%%
   % temp = zeros(size(dna));
   % for i = 1 : number_of_nuclei
   %	i
   %	if ((max(max(masks{i}))) == 0) 
   %	    continue; 
   %	end;
%	alx = mv_readimage([cDir files{alxInd(fi)}]);
%	mit = mv_readimage([cDir files{mitInd(fi)}]);
%	temp = roifilt2(0, alx, ~masks{i});
%	figure, imshow(temp, []);pause;
%	temp2 = roifilt2(0, dna, ~masks{i});
%	figure, imshow(temp2, []);pause;
%	temp3 = roifilt2(0, mit, ~masks{i});
%	figure, imshow(temp3, []);pause;
%    end
    
%%%%%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%
     
     
     dirNameMin = files{dnaInd(fi)}(1:length(files{dnaInd(fi)})-4);
     dirNameMin(find(dirNameMin==' ')) = '_';
     dirName = [classDir 'crop/' dirNameMin '/']
     mkdir([classDir 'crop/'], dirNameMin);
     for i = 1:number_of_nuclei
	 if ((max(max(masks{i}))) == 0) 
	    continue; 
	 end
	 imwrite(masks{i}, [dirName 'crop_' num2str(i) '.tif'], 'tiff');
     end

end


function nucobj = filter_nuclei( obj, imgsize)
% Find the objects in the OBJ list that are likely to be nuclei
% and are not touching the edge

% Get a list of all object sizes
for i = 1 : length(obj)
    objsizes(i) = obj{i}.size;
end

% Figure out which ones touch the edge
edgetouch = ones(1,length(obj));
%im = uint16(zeros(imgsize));
%im2 = double(zeros(imgsize));
%im2 = im2*65535;
%cm = [0 0 0; 1 1 1; 1 0 0; 0 1 1];

for i = 1 : length(obj)
    o = obj{i};
    if( find(o.voxels([1 2],:)==1))
    else
        if( find(o.voxels(1,:)==imgsize(1)))
        else
            if( find(o.voxels(2,:)==imgsize(2)))
            else
                edgetouch(i) = 0;
            end
        end
    end
    
    k = convhull(double(o.voxels(2,:))',double(o.voxels(1,:))');
    ar = polyarea(double(o.voxels(2,k)),double(o.voxels(1,k)));
    if ar > 0 
	pc(i) = round(o.size*100/ar);
    else
	pc(i) = 0;
    end
    
%    fprintf('size = %3d, area = %3d, percent = %d\n', o.size, round(ar), pc);
end

%%%%%%%%%%% OBJECT SIZE FILTER %%%%%%%%%%%%
med = median(objsizes);
rng = round(med/3);
%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%
% Keep only nucleus candidates which are within range and do not
% touch the edge
goodnuclei = [ find(edgetouch==0 & objsizes>(med-rng) & objsizes<(med+rng) ...
		    & pc >= 50 )];
nucobj = obj(goodnuclei);
