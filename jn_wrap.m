function [dna,dnabin,masks] = jn_wrap;

dnapath = '/home/jnewberg/images/Hela/3D/cell02/Nucl';
% dnapath = '/home/jnewberg/images/Hela/3D/cell23/Nucl';
% dnapath = '/home/jnewberg/images/Hela/3D/cell07/Nucl';
d = dir( dnapath);
d(1:2) = [];

for i=1:length(d),
  dna(:,:,i) = imread( [ dnapath '/' d(i).name]);
end

dnaimg = ml_3dbgsub( dna);

dnaimg = double(dnaimg);
dnaimg = uint8(dnaimg*255/max(dnaimg(:)));
dnaimg = ml_3dbgsub( dnaimg);
dnaCOF = ml_findCOF( ml_sparse( dnaimg));
dnathresh = 255*ml_threshold( dnaimg);
dnabin = ml_binarize( dnaimg, uint8(floor(dnathresh)));

dnaobj = ml_3dfindobj_sa( dnabin, 1, 2);
[DnaCOF, DnaCOFs] = ml_findCOFs( dnaobj, dnaimg);

% Add more to preprocessing

br = 0;  bc = 0;  tr = 480; tc = 640;
X = [-1000 -1000;  1500 -1000;  1500 1500;  -1000 1500;  DnaCOFs(1:2,:)'];
% X = [br bc;  tr bc;  tr tc;  br tc;  DnaCOFs(1:2,:)'];
masks = jn_vor( X, br, bc, tr, tc);

for i=1:size(masks,3)
  compressed_masks{i} = ml_rle(masks(:,:,i));
end


if 1==1,
figure(1);  clf;
plot(X(5:size(X,1),1),-X(5:size(X,1),2),'b.');

figure(2);  clf;
img = zeros( size(masks,1), size(masks,2)); 
for i=1:size(masks,3),  img = img + double(masks(:,:,i))*i;  end
img = uint8(img); imagesc(img);

figure(3); clf; imagesc( sum(dnaimg,3));
figure(4); clf; imagesc( double(img) - double(dnabin(:,:,8)));
end

% save( '/home/jnewberg/images/crop/voronoi/test.mat' , 'compressed_masks');
% clear
% load( '/home/jnewberg/images/crop/voronoi/test.mat');

dnabin = double(dnabin);
masks = double(masks);

for i=1:size(masks,3),
  mid = ceil( size(dnabin,3)/2);
  img = dnabin(:,:,mid).*masks(:,:,i);

  A = sum( img(:));
  img = jn_2dbin2edge( img);
  a(i) = A;
  c(i) = sum( img(:));

  b = sqrt( A/pi);
  C(i) = pi*(6*b-4*sqrt(b^2));
end

ind = (C-c)>0;

dnabin = uint8(dnabin(:,:,mid));
masks = uint8(masks(:,:,ind));

return
