function status = jn_createfile_excl( filefullpath) 

% STATUS = JN_CREATEFILE_EXCL( FILEFULLPATH)
%
% Create the file FILEFULLPATH only if it does not already exist.
% Return value is 0 if file was successfully created, or 1 if it
% already exists or 2 if it could not be created for some other
% reason (such as non-existent directory or not enough permission).

% Meel Velliste 5/20/02
% Modified 5/05 Justin Newberg for Juggernaut

% binpath = '/home/jnewberg/bin';
binpath = '/home/jnewberg/matlab/3Dfeatcal/bin';

% [status,output] = unix([binpath '/jn_createfile_excl ' filefullpath]);
[status,output] = unix([binpath '/ml_createfile_excl ' filefullpath]);
