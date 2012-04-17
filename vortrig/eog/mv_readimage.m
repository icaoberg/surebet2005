function image = mv_readimage( filename)

% IMAGE = MV_READIMAGE( FILENAME)
%
% Reads a 2D image in any format, including TCL files.
% If FILENAME is an emtpy string, then an empty matrix
% is returned.
%

if( isempty( filename))
  image = [];
  return;
end

L = length( filename);
extension = filename(L-2:L);


    switch( extension)
     case '.gz'
        tempdir = '/imaging/tmp';
        [f,tempfilename] = mv_fopentemp(tempdir);
        tempfullpath = [tempdir '/' tempfilename];
        fclose(f);
        unix(['gunzip -c ' filename ' > ' tempfullpath]);
	image = imread( tempfullpath);
	unix(['rm ' tempfullpath]);
     case 'bz2'
        tempdir = '/imaging/tmp';
        [f,tempfilename] = mv_fopentemp(tempdir);
        tempfullpath = [tempdir '/' tempfilename];
        fclose(f);
        unix(['bunzip2 -c ' filename ' > ' tempfullpath]);
	image = imread( tempfullpath);
	unix(['rm ' tempfullpath]);
     case 'dat'
	image = mv_tclread( filename);
     otherwise
        image = imread( filename);
    end

