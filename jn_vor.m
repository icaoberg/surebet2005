function im = jn_vor( X, br, bc, tr, tc)

[V,C]=voronoin(X); 

maxr = [tr];
maxc = [tc];

im = uint8( zeros( maxr, maxc, size(X,1)-4));

next = 1;
for i=1:length(C)
  r = double(round(V(C{i},1)));
  c = double(round(V(C{i},2)));

  if ~isinf(sum(sum( [r c])))
    im(:,:,next) = roipoly( maxr, maxc, c, r);
    next = next+1;
  end
end
