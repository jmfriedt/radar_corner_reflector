# Modelling a RADAR corner reflector coated with various dielectric layer geometries

Various authors have been considering the use of RADAR corner reflectors for assessing
snow cover layer thickness and properties (see https://www.mdpi.com/2072-4292/11/8/988 
by E. Trouve & al). 

Our own measurements in Spitsbergen hint at a dramatic reflectivity loss as soon as even
a slight snow layer covers some of the faces of the corner reflector, and even in case
of apparently dense homogeneous dry snow filling the corner reflector.

The GNU Octave raytracing software aims at assessing the impact of a various dielectric
layers coating one side of a trihedral square corner reflector of unit size. While a 
homogeneous layer parallel to one side has hardly any impact, the realistic case of even
a slight angle between the deposited layer and the reflecting mirror surface induces
dramatic loss by directing the rays away from the monostatic RADAR.

<img src="reflection.png">

In the above figure, ``nd`` represents the normal vector of the layer defining the dielectric
layer interface, with [1 0 0] representing a layer parallel to the face in the yOz plane
and [1 1 1] a layer filling the corner reflector.

## Experimental results

The following chart displays the snow depth measurement in Ny-Alesund station and
the inverse (maximum - measurement) of the corner reflector intensity as recorded
by the spaceborne Sentinel1 RADAR operating in the C-band (5.405 GHz).

<img src="measurements.png">

