classDir = '/home/jnewberg/images/Hela/3D/Nucl';
dnaDIR = 'cell03';
extension = 'bmp';

[files, num_files, cDir] = er_file_check([classDir '/' dnaDIR '/' ]);

dnaInd = [];

for i=1:1:num_files
    if findstr(files{i}, extension)
        dnaInd = [dnaInd i];
    end
end

for fi=1:1:num_files
    index=dnaInd(fi);
    file=[cDir files{index}];
    dna = mv_readimage( file );
    fprintf(1, '%s\n', [cDir files{dnaInd(fi)}]);
    dna = double(dna(:,:,1));
    dna = mv_sub_bg(dna);
    dna = (dna*65535)/max(max(dna));
    threshDna = 0;
    eval('threshDna = mv_choosethresh(dna);','disp(''could not get threshold''); threshDna = 1000');
    dnaBin = im2bw(uint16(dna), threshDna/65535);  
    findholes = 0;
    dnaobj = mv_3dfindobj( dnaBin, findholes, 10); 
    nuclei_obj = filter_nuclei( dnaobj, size(dnaBin));
    seedimg = uint16(zeros(size(dnaBin)));
    number_of_nuclei = length( nuclei_obj);
    for i = 1 : number_of_nuclei
        v = double(nuclei_obj{i}.voxels);
        seedimg(sub2ind(size(dnaBin),v(1,:),v(2,:))) = i;
    end
    seedimg(:,[1 end]) = number_of_nuclei + 1;
    seedimg([1 end],:) = number_of_nuclei + 1;  
    [totalCof, objCofs] = mv_findCOFs( nuclei_obj, dna);
    [totalCofAll, objCofsAll] = mv_findCOFs(dnaobj, dna);
    objy = objCofsAll(1,:);
    objx = objCofsAll(2,:);
    TRI = delaunay(objx, objy);
    [vx, vy] = voronoi(objx, objy, TRI);
    newIm = zeros(size(dna));
    for i = 1:size(vx,2) 
        newIm = er_draw_line2(vy(1,i), vx(1, i), vy(2, i), vx(2, i), newIm, 30);
    end

    newIm = er_draw_line2(1,1,1,size(newIm,2),newIm, 30);
    newIm = er_draw_line2(1,size(newIm,2),size(newIm,1), size(newIm,2),newIm, 30);
    newIm = er_draw_line2(size(newIm,1),size(newIm,2), size(newIm,1),1, newIm, 30);
    newIm = er_draw_line2(size(newIm,1),1,1,1,newIm, 30);
    segLines = im2bw(newIm, 1);
    dnaBin2 = double(dnaBin);
    segLines2 = double(segLines);
    totimg = segLines2+dnaBin2;
    totimg = 255*totimg;
    totimg = uint8(totimg);
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
   
    for i = 1:number_of_nuclei
        if ((max(max(masks{i}))) == 0) 
            continue; 
        end
        imwrite(masks{i}, [classDir  '/crop/crop_' num2str(i) '.tif'], 'tiff');
    end
  end
end
