function cleanimg = xc_mask( img, maskimg)

% CLEANIMG = XC_MASK( IMG, MASKIMG)
% 
% Masks IMG with MASKIMG. MASKIMG must be binary.  Support either 3D maskimg
% or 2D muskimg.
% Xiang Chen, Aug 14, 2002

if (size(img, 3) ~= size(maskimg, 3)) & (size(maskimg, 3) ~= 1)
     error('Muskimg must be either 2D or have same number of slices as Img.');
end

cleanimg = repmat( uint8(0), size(img));
maskstack = repmat( uint8(0), size(img));
if (size(maskimg, 3) > 1)
     maskstack = maskimg;
else
     for m = 1 : size(img, 3)
          maskstack(:,:,m) = maskimg;
     end
end
mask = find( maskstack);
cleanimg( mask) = img( mask);
