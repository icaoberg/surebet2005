function avgArea = iecb_avgAreaIm( image )
% IECB July 24, 2005
% Given an image, it will calculate the average are of the objects in the image
% Input
% -----
% image: a binary image
% Output
% ------
% avgArea: the average area of the objects in the image
% Comment
% -------
% Since I am using the built-in function bwarea, the area of the area
% is not equivalent to the amount of pixels of the objects.

image = +image;
if ~isa( image, 'logical' )
    %Is it a binary image?
    warning('Error in iecb_avgAreaIm: Input needs to be a binary image')
    return
else
    [label numObjs]=bwlabel( image );
    avgArea = bwarea( image )/numObjs;
end