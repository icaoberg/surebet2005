function eg_wrapperVoroni(path, dnapath, extension);

% This function is the wrapper for eg_er_atto_segment3.m
% The input 'path' is the directory for which you'd like
% to create crop images.
%
% dnapath is the name of the directory that contains the 
% DNA images. 
%
% Extension is the image file type (tif, jpg, etc)
% All inputs should be in single quotes

eg_er_atto_segment3(path, dnapath, extension);
