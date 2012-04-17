function binimg = mv_unrle( enc_img)

% BINIMG = MV_UNRLE( ENC_IMG)
%
% Unencode runlength encoded binary image of 0-s and 1-s.
% Image must have been coded with MV_RLE.

binimg = repmat(uint8(0),enc_img.size);
change_pos = cumsum(double(enc_img.runlengths));
startpos = change_pos(1:2:end)+1;
endpos = change_pos(2:2:end);
for i = 1:length(startpos)
    binimg(startpos(i):endpos(i)) = 1;
end
