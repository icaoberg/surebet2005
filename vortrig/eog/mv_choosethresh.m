function [threshold, h] = mv_choosethresh( img, plotgraph)
  
  % T = MV_CHOOSETHRESH( IMG)
  % PLOTGRAPH is 0 or 1 to indicate whether you want to plot graphs
  % of histograms showing how the stuff works
  
  if( ~exist('plotgraph','var'))
      plotgraph = 0;
  end
  
  MAX = max(img(:));
  if( MAX > 255)
    img = double(img);
    img = 255*img/MAX;
    img = uint8(round(img));
  end
  % get the histogram
  h = imhist(img)';
  % smooth it
  sh = smooth_histo( h);
  size(sh);
  sh = flipdim( sh, 2);
  d_sh = diff( sh); % First Derivative
  dd_sh = [0 diff( d_sh)]; % Second Derivative (0 is for aligning
                           % with the 0th differential)
  
  s_dd_sh = smooth_histo( dd_sh);

  % Find first local maximum of second derivative (where first
  % derivative is greater than average)
  i = 1;
  mn = mean(d_sh);
  while( (s_dd_sh(i) <= s_dd_sh(i+1)) | (d_sh(i) < mn))
    i = i + 1;
  end
  flm = i; % flm - first local maximum
  t = flm - sh(flm)/d_sh(flm);
  threshold = 256 - t;
  
  if( MAX > 255) threshold = MAX*threshold/255; end

  if( plotgraph)
  figure(3)
  subplot(311)
  thresh = zeros(1,256); thresh(round(t)+1:flm) = max(sh(207:255));
  plot([-49:-1],[sh(207:255);thresh(207:255)])
  subplot(312)
  plot([-49:-1],d_sh(207:255))
  subplot(313)
  plot([-49:-1],dd_sh(207:255))
  figure(3)
  end

  
function sh = smooth_histo( h)    
    
  % smoothe it
  L = length( h);
  N = 11;
  N2 = (N-1)/2;
  Filter = [0.05 0.1 0.15 0.25 0.4 1.0 0.4 0.25 0.15 0.1 0.05];
  sh = h;
  for i = 1 : L
    lower = max( 1, i-N2);
    upper = min( L, i+N2);
    flower = max( 1, N2-i+2);
    fupper = min( N, L+1-i+N2);
    sh(i) = sum( h(lower:upper) .* Filter(flower:fupper));
  end
  