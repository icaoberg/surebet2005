function dir = jn_readdir(expression, tmpdir)
% FUNCTION DIR = JN_READDIR(EXPRESSION, TMPDIR)
% same as 'ls expression' in linux.  Support remote server
% @param tmpdir - the tmp directory used, '/tmp' as default.
% 
% modified by Justin Newberg 5/12/05 for Juggernaut

if (~exist('tmpdir', 'var'))
     tmpdir = '/tmp';
end

[f, tempfile] = ml_fopentemp(tmpdir);
fclose(f);
tempfullname = [tmpdir '/' tempfile];

pos = findstr(expression, ':');
if (pos > 1)
     server =  expression(1 : pos -1);
     name = expression(pos + 1 : length(expression));
     unix(['ssh ' server ' "ls ' name  '"  >' tempfullname]);
     dir = textread(tempfullname, '%s', 'delimiter', '\n');
     delete(tempfullname);
else
     unix(['ls ' expression ' >' tempfullname]);
     dir = textread(tempfullname, '%s', 'delimiter', '\n');
     delete(tempfullname);
end
dir = sort(dir);
