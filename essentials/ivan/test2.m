classDir = '/home/jnewberg/images/Hela/3D/Nucl';
dnaDIR = 'cell01';
extension = 'bmp';

[files, num_files, cDir] = er_file_check([classDir '/' dnaDIR '/']);

dnaInd = [];

for i = 1:num_files
    if findstr(files{i}, extension)
        dnaInd = [dnaInd i];
    end
end

for fi = 1:( num_files )                                   
dna = mv_readimage([cDir files{dnaInd(fi)}]);               
fprintf(1, '%s\n', [cDir files{dnaInd(fi)}]);               
dna = double(dna(:,:,1));                                   
dna = mv_sub_bg(dna);                                       
dna = (dna*65535)/max(max(dna));                            
threshDna = 0;                                              
threshDna=mv_choosethresh(dna);
dnaBin = im2bw(uint16(dna), threshDna/65535);
findholes = 0;
dnaobj = mv_3dfindobj( dnaBin, findholes, 10); 
nuclei_obj = filter_nuclei( dnaobj, size(dnaBin));
seedimg = uint16(zeros(size(dnaBin)));
number_of_nuclei = length( nuclei_obj);
for i = 1 : number_of_nuclei
    v = double(nuclei_obj{i}.voxels);
    seedimg(sub2ind(size(dnaBin),v(1,:),v(2,:)))=i; 
end
seedimg(:,[1 end]) = number_of_nuclei + 1;
seedimg([1 end],:) = number_of_nuclei + 1;

[totalCof, objCofs] = mv_findCOFs( nuclei_obj, dna);
[totalCofAll, objCofsAll] = mv_findCOFs(dnaobj, dna);
end


