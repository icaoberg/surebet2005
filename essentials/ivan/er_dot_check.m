function [new_filenames] = er_dot_check(old_filenames)
%ER_DOT_CHECK '.' Removal
%    [NEW_FILENAMES] = ER_DOT_CHECK(OLD_FILENAMES)
%    Taking a list of filenames (OLD_FILENAMES) a new
%    list is returned (NEW_FILENAMES) which contains no files
%    that begin with the character '.'
%
% er_dot_check.m written by Edward Roques


%if(~exist('old_filenames'))
%   warning('no input to er_dot_check.m');
%   new_filenames={};
%   return
%end

if(isempty(old_filenames))
   warning('input to er_dot_check.m is empty');
   new_filenames ={};
   return
end

%if(~strcmp(class(old_filenames), 'cell'))
%   warning('input to er_dot_check.m should be a cell array');
%   new_filenames = {};
%   return
%end
%
%if(~strcmp(class(old_filenames{1}), 'char'))
%   warning('input to er_dot_check.m should be a string cell array');
%   new_filenames = {};
%   return
%end

new_filenames = {};

for i=1:length(old_filenames)      
if (~strncmp(old_filenames{i}, '.', 1)) 
     new_filenames(length(new_filenames)+1) = {old_filenames{i}};	
end
end 
new_filenames = new_filenames';

