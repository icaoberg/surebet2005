function [files, num_files,  new_dir] = er_file_check(old_dir)
%ER_FILE_CHECK Checks directory for the purposes of SImEC input
%    [FILES, NUM_FILES, NEW_DIR] = ER_FILE_CHECK(OLD_DIR)
%    Given a directory OLD_DIR, the list of files is returned as vector FILES
%    in lexicographical order with listing '.' and '..' removed.
%    The number of files returned is given by NUM_FILES and
%    a slash is added to the directory name is required and is returned
%    as NEW_DIR.
%
% er_file_check.m writtern by Edward Roques

if (~exist('old_dir'))
    warning('no input to er_file_check.m');
    files = {};
    num_files = 0;
    new_dir = '';
    return
end

if (isempty(old_dir))
    warning('input to er_file_check.m is empty');
    files = {};
    num_files = 0;
    new_dir = '';
    return
end

if (~isdir(old_dir))
    warning('input to er_file_check.m is not a valid directory');
    files = {};
    num_files = 0;
    new_dir = '';
    return
end

direc = dir(old_dir); 
%new_files = {};
[files{1:length(direc),1}] = deal(direc.name);
files = sort(er_dot_check(files));
new_dir = er_slash_check(old_dir);
num_files=length(files);
