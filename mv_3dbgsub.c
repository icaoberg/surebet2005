#ifdef _MEX_
#include "mex.h"
#include "matrix.h"
#endif // #ifdef _MEX_
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <limits.h>
#include <float.h>
#include <memory.h>
#include <sys/time.h>
#include <sys/resource.h>
#include <unistd.h>
#include <sys/types.h>

unsigned char find_most_common( unsigned char *Image, unsigned long length)
{
  unsigned long hist[256];
  unsigned long highest_count;
  unsigned char most_common_idx;
  unsigned long i;
  
  for( i = 0; i < 256; i++) hist[i] = 0;
  for( i = 0; i < length; i++) hist[Image[i]]++;
  highest_count = hist[0];
  most_common_idx = 0;
  for( i = 1; i < 256; i++) {
    if( hist[i] > highest_count) {
      highest_count = hist[i];
      most_common_idx = i;
    }
  }
  return most_common_idx;
}

#ifdef _MEX_
void mexFunction(
		 int nlhs,
		 mxArray *plhs[], 
		 int nrhs,
		 const mxArray *prhs[])
{
    unsigned char* output ;     // Return value to Matlab

    int x, y, z, i;
    long n_voxels; // The total number of voxels in the image

    unsigned char *Image;
    long NDims;
    const int *Dims;
    int Width, Height, Depth;

    unsigned char MostCommonPixelValue;
    int newvalue;

    // Argument checking
    if (nrhs != 1) {
      mexErrMsgTxt("mv_3dbgsub() requires one input argument.") ;
    } else if (nlhs != 1) {
      mexErrMsgTxt("mv_3dbgsub() returns a single output.") ;
    }

    if (!mxIsUint8(prhs[0])) {
      mexErrMsgTxt("The argument to mv_3dbgsub() should be a 3D matrix\n."
			"of type uint8") ;
    }

    // Get Image size info etc
    NDims = mxGetNumberOfDimensions( prhs[0]);
    if( NDims != 3) {
      mexErrMsgTxt("Input image must be 3-dimensional");
    }
    Dims = mxGetDimensions( prhs[0]);
    Height = Dims[0];
    Width = Dims[1];
    Depth = Dims[2];
    n_voxels = Width * Height * Depth; 

    // Get hold of the input image
    Image = (unsigned char*) mxGetData( prhs[0]);

    // Create output image
    plhs[0] = mxCreateNumericArray(NDims, Dims, mxUINT8_CLASS, mxREAL) ;
    output = (unsigned char*) mxGetData(plhs[0]) ;

    //////////////////////////////////////////////////////////////////
    MostCommonPixelValue = find_most_common( Image, n_voxels);
    //printf("Most common value is %i",MostCommonPixelValue);
    for( i = 0; i < n_voxels; i++) {
      newvalue = Image[i] - MostCommonPixelValue;
      if( newvalue < 0) newvalue = 0;
      output[i] = newvalue;
    }
    //////////////////////////////////////////////////////////////////

    return ;
}

#endif // #ifdef _MEX_
