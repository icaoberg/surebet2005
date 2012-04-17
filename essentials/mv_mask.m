function cleanimg = mv_mask( img, maskimg)

% CLEANIMG = MV_MASK( IMG, MASKIMG)
% 
% Masks IMG with MASKIMG. MASKIMG must be binary.

cleanimg = repmat( uint8(0), size(img));
mask = find( maskimg);
cleanimg( mask) = img( mask);
