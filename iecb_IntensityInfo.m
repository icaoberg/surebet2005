function [maxIntensity numPixel] = iecb_IntensityInfo( image )

%Determines the max intensity of the pixel
maxIntensity = max( image(:) );
% Determines the number of pixels with this intensity
[ x y ] = find( image == maxIntensity );
numPixel = size(x);