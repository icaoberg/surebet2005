function bg_value = mv_get_bg( image, mask)

% BG_VALUE = MV_SUB_BG( IMAGE, MASK)
%
% IMAGE can be any dimensional.
% if MASK is specified, then ackground will be found within
%  mask region only

if( nargin > 1) use_mask = 1;
else use_mask = 0;
end

im = double(image);
if( use_mask)
  im = im(find(mask)); % leave only masked area
end

  MAX = max(im(:));
  MIN = min(im(:));
  % Find histogram of graylevel values, with one bin for each
  % graylevel value (from MIN to MAX).
  h = hist(im(:),MAX-MIN+1);
  bg_values = find( h == max(h)) + MIN - 1; %sub 1 because of
					    %matlab indexing
  bg_value = bg_values(1); %if there are several most common values
                           %then the first lowest one will get chosen