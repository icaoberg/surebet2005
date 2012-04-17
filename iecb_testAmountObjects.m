function answer = iecb_testAmountObjects( image, mask )
% July 30, 2005
% Description
% -----------
% Given an image and a mask for an object in the image, the function
% will test the mask by asking how many objects are found in the image after
% it is processed.

image =+image;
mask = +mask;

if ~isa( image, 'logical' )
    warning('Error in iecb_testAmountObjects: Input image must be binary');
    return
elseif ~isa( mask, 'logical' )
    warning('Error in iecb_testAmountObjects: Mask must be binary');
    return
else
    image = image .* mask;
    [image numObjects] = bwlabel( image );
    if numObjects == 1
        answer=1;
    else
        answer=0;
    end
end
end