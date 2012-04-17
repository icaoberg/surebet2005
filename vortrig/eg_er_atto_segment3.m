function eg_er_atto_segment3( classDir, dnaDir, extension )
% Modified ER_ATTO_SEGMENT3
% EGO 06/02/05
% IECB 07/90/05


%%%%%%%%%%%%%%% INPUT CHECK %%%%%%%%%%%%%%%%%%
if nargin < 3
    fprintf(1, 'Not enough input.\n');
    return;
end
%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%%%%

finalResults = [];

%%%%%%%%%%%%%% FILE HANDLING %%%%%%%%%%%%%%%%%
[files, num_files, cDir] = er_file_check([classDir '/' dnaDir '/']);

dnaInd = [];

for i = 1:num_files
    if findstr(files{i}, extension)
        dnaInd = [dnaInd i];
    end
end
%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%% PROCESSING %%%%%%%%%%%%%%%%%%%%%%
for fi = 1:(num_files) 
    % Read raw image and convert to double
    dna = mv_readimage([cDir files{dnaInd(fi)}]);
    
    % 
    fprintf(1, '%s\n', [cDir files{dnaInd(fi)}]);
    
    % dna = double(dna(:,:,1)); Comment: If this line is left in dwarf
    % produces errors. Verify Elvira's results for possible
    % incompabilities
    
    % Remove background
    dna = mv_sub_bg(dna);
    % Scale image from 0 to 65535 ((2^16)-1)
    dna = (dna*65535)/max(max(dna));
    % Threshold
    threshDna = 0;
    eval('threshDna = mv_choosethresh(dna);', ...
        'disp(''could not get threshold''); threshDna = 1000');%2570');
    dnaBin = im2bw(uint16(dna), threshDna/65535);
    dnaBin = uint8( dnaBin ); 
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
    [totalCof, objCofs] = mv_findCOFs( nuclei_obj, dna);
    [totalCofAll, objCofsAll] = mv_findCOFs(dnaobj, dna);
    %%%%%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    objy = objCofsAll(1,:);
    objx = objCofsAll(2,:);
    
    %%%%%%%%%%%%%%%%%%%% DELAUNAY %%%%%%%%%%%%%%%%%%%%%%%
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
