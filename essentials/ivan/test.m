classdir = '/home/jnewberg/images/Hela/3D/Nucl';
dnaDIR = 'cell01';
extension = 'bmp';
exIm = 'Justin_050714_Hela_HML(6)_3D__A___6_T_001_ch_00_image_00001_Z_001.bmp';

finalResults = [];

%This check is not necessary for
[files, num_files, cDir] = er_file_check( [ classdir '/' dnaDIR '/']);

dnaInd = [];


for i = 1:num_files
    if findstr(files{i}, extension)
        dnaInd = [dnaInd i];
    end
end


