function newimage = mv_sub_bg( image, bg_value)

% NEWIMAGE = MV_SUB_BG( IMAGE)
%
% Subtracts the background of IMAGE by finding the most common
% pixel value and subtracting that from every pixel in the image.
% Note that NEWIMAGE is of type double regardless of the type of
% IMAGE.
%
% IMAGE can be any dimensional.

im = double(image);
if( nargin < 2)
  bg_value = mv_get_bg( im);
end
newimage = im - bg_value;
newimage( find(newimage<0)) = 0;
