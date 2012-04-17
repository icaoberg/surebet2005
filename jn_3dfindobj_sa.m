function objects = jn_3dfindobj_sa( binimg, findholes, min_obj_size)

% OBJECTS = MV_3DFINDOBJ_SA( BINIMG, FINDHOLES, MIN_OBJ_SIZE)
%
% Find the objects in binary image BINIMG. If FINDHOLES is nonzero then
% holes are found too. Works the same as mv_3dfindobj, just uses a standalone 
% program instead of a MEX file. The MEX program ran into trouble when allocating
% memory, probably because of a bug either in matlab or in
% malloc. If MIN_OBJ_SIZE is specified, then objects smaller than
% that size are ignored.

% Meel Velliste 5/20/02

if( ~exist( 'min_obj_size', 'var'))
    min_obj_size = 1;
end

tic
binpath = '/home/jnewberg/matlab/3Dfeatcal/bin/';
tempdir = '/home/jnewberg/temp';
fname1 = ml_fopentemp( tempdir);
fname2 = ml_fopentemp( tempdir);
full_imgfilename = [tempdir '/' fname1];
full_objfilename = [tempdir '/' fname2];
ml_save3di( uint8(binimg), full_imgfilename);
cmdline = [binpath '/mv_3dfindobj_sa ' full_imgfilename ' ' full_objfilename ...
          ' ' num2str(findholes) ' ' num2str(min_obj_size)];
[status, output] = unix( cmdline);
if( status ~= 0)
    disp( output);
    error('There was an error in the standalone **_3dfindobj executable');
end
ObjectFindingTime = toc
tic
% Read the object finding results
objects = readobjfile( full_objfilename);

% Remove temporary files
unix(['rm ' full_imgfilename]);
unix(['rm ' full_objfilename]);

ObjectFileReadingTime = toc


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function objlist = readobjfile(Filename)
% RETURN = XC_READ3DI(FILENAME)
% Read objects from Filename and convert them to the format 
% requied by mv_obj2feat.m
%
% Filename is the name of file contains this information
% Xiang Chen 5/20/02, modified by MV 5/20/02


fid = fopen(Filename);
if (fid == -1)
     error('Object file does not exsist');
end

% Read Number of Objects
objno = fread(fid, 1, 'uint32');
for m = 1 : objno
     % number of voxel in the object
     voxelno = fread(fid, 1, 'uint32');
     % number of holes in the object
     holeno = fread(fid, 1, 'uint32');
     % read in y, x, z for each voxel
     voxel = repmat(uint16(0), 3, voxelno);
     if (~feof(fid))
          voxel = fread(fid, [3 voxelno], 'uint16');
     else
          error('File corrupted');
     end

     % create the struct for this object
     temp = struct('size', voxelno, 'voxels', voxel, 'n_holes', holeno);

     % attach it to the result
     objlist{m} = temp;
end
objlist = objlist';
fclose(fid);
