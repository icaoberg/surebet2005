function [new_str] = er_slash_check(old_str) 
%ER_SLASH_CHECK  Platform independent slash check
%    [NEW_STR] = ER_SLASH_CHECK(OLD_STR)
%    Takes a string (OLD_STR) and returns it with
%    a slash as the last character.
%
%    Useful for checking files.
%    If the string already contains a final slash then
%    it is returned as is.
%
% er_slash_check.m written by Edward Roques
%if (~exist(old_str))
%    warning('no input to er_slash_check');
%    new_str = '';
%    return;
%end

f = filesep;

if  (~strcmp(old_str(size(old_str,2)), f))
        new_str = cat(2, old_str, f);
else
	new_str = old_str;
end

