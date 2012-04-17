function enc_img = mv_rle( binimg)

% ENC_IMG = MV_RLE( BINIMG)
%
% Runlength encode a binary image of 0-s and 1-s.
% This results in better compression than, say PCX image format
% because binary input image is assumed, and therefore there is no
% need to record pixel values

tmp1 = uint8(binimg(1:end-1));
tmp2 = uint8(binimg(2:end));
change_pos = find( tmp1 ~= tmp2);
runlengths = uint32(diff( [0 change_pos]));
enc_img = struct('size',size(binimg),'runlengths',runlengths);
