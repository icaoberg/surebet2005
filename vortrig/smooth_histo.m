function sh = smooth_histo( h )    

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
