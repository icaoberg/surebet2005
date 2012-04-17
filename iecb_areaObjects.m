function area = iecb_areaObjects( image, x, y )
% IECB July 30, 2005
% This function calculates the area of one or more objects
% Input
% -----
% image: a binary image
% x: the abscissa points (i.e. horizontal axes)
% y: the ordinate points (i.e. vertical axes)
% Output
% ------
% area: the area of the objects.
% Comment
% -------
% Since I am using the built-in function bwarea, the area of the area
% is not equivalent to the amount of pixels of the objects.

image = +image;
if ~isa( image, 'logical' )
    %Is it a binary image?
    warning('Error in iecb_areaObjects: Input needs to be a binary image')
    return
else
    image = bwselect( image, x, y );
    area = bwarea( image );
end