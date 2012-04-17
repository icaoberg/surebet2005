function ml_save3di( img, filename)
% ML_SAVE3DI( IMAGE, FILENAME)
% Saves the matrix IMAGE in the 3D Image file format (.3di)
% which is consists of a simple header (X-dimension, Y-dimension,
% Z-dimension, Bytes per pixel, followed by pixel values).
% Useful for passing an image to a standalone program.

% Meel Velliste (Spring 2000)

ImageInfo = whos('img');
switch ImageInfo.class
case 'uint8',
  BYTES_PER_PIXEL = 1;
  DATA_TYPE = 'uint8';
  %disp('uint8');
otherwise
  BYTES_PER_PIXEL = 2;
  DATA_TYPE = 'uint16';
end;

f = fopen( filename, 'wb');
if( f == -1) fprintf( 2, 'Cannot open file for saving!\n'); return; end;

s = size( img);
dimensionality = length(s);
if( dimensionality == 2)
	Header = [ s, 1, BYTES_PER_PIXEL];
else
	Header = [ s, BYTES_PER_PIXEL];
end;

fwrite( f, Header, 'ulong');
fwrite( f, img, DATA_TYPE);

fclose( f);
