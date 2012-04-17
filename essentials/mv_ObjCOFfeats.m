function [meandist, stddist, maxmindist] = mv_ObjCOFfeats( dists)

% [MEANDIST, STDDIST, MAXMINDIST] = MV_OBJCOFFEATS( DISTS)
%
% Calculates the three features relating objects COF-s to a
% central COF:
% 1) The average object distance to central COF
% 2) The stddev of object distances to central COF
% 3) The Max/Min ratio of object distances to central COF
% DISTS is a vector of object distances to COF

meandist = mean( dists); % Average object dist to COF
stddist = std( dists); % Std.dev. of object dist to COF
if( min( dists) > 0)
  maxmindist = max( dists) / min( dists); % Ratio of smallest to 
					       % largest obj to COF
					       % dist
else
  maxmindist = 0;
end
