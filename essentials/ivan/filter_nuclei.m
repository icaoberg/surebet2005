function nucobj = filter_nuclei( obj, imgsize)

% Find the objects in the OBJ list that are likely to be nuclei
% and are not touching the edge
% Get a list of all object sizes

for i = 1 : length(obj)
    objsizes(i) = obj{i}.size;
end

% Figure out which ones touch the edge
edgetouch = ones(1,length(obj));
%im = uint16(zeros(imgsize));
%im2 = double(zeros(imgsize));
%im2 = im2*65535;
%cm = [0 0 0; 1 1 1; 1 0 0; 0 1 1];

for i = 1 : length(obj)
    o = obj{i};
    if( find(o.voxels([1 2],:)==1))
    else
        if( find(o.voxels(1,:)==imgsize(1)))
        else
            if( find(o.voxels(2,:)==imgsize(2)))
            else
                edgetouch(i) = 0;
            end
        end
    end
 
    k = convhull(double(o.voxels(2,:))',double(o.voxels(1,:))');
    ar = polyarea(double(o.voxels(2,k)),double(o.voxels(1,k)));
    if ar > 0 
        pc(i) = round(o.size*100/ar);
    else
        pc(i) = 0;
    end
  
 %fprintf('size = %3d, area = %3d, percent = %d\n', o.size, round(ar), pc);
end


%%%%%%%%%%% OBJECT SIZE FILTER %%%%%%%%%%%%
med = median(objsizes);
rng = round(med/3);
%%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%%%%%

% Keep only nucleus candidates which are within range and do not

goodnuclei = [ find(edgetouch==0 & objsizes>(med-rng) & objsizes<(med+rng) ...
        & pc >= 50 )];

nucobj = obj(goodnuclei);
