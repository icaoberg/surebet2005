function answer = change2double( filename )

answer = imread( filename );

if isa( answer, 'double' )
 return
else
 answer = double( answer );
end
