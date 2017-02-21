# Sketchup: Coordinate Tools
This extension is capable of *unwrapping* cylindrical surfaces into flat faces and *vice versa*.
This is achieved by converting the Cartesian coordinates of each vertex into cylindrical coordinates
and mapping those back to the XYZ axes. The mathematics behind it is very simple yet stunningly efficient.
With the extension you can write 3D text on the surface of a cylinder, or resize a curved surface so that
its radius remains the same, and much more. It can save you hours of work you'd spend doing this by hand.

This extension is currently in beta. In the future I plan to implement spherical and ellipsoidal coordinates
and then add some fancy tools like spherical push&pull (with automatic center recognition), cylindrical resize
tool and so on.

I'm open to your suggestions and complaints, feel free to file an issue!

<br/>

## How to install

1. Download the `.rbz` file from the [Latest release](https://github.com/m93a/Sketchup-Coord-Tool/releases/latest) page.
2. Launch Sketchup and select `Window > Extension Manager`
3. Click on `Install Extension` and select the downloaded file

<br/>

## How to use

### Unwrap Cylinder tool
1. Create a group/component containing your cylindrical surface.
2. Make sure the group is active and that there are no other groups/components inside it.
3. Make sure there are enough vertices. This extension doesn't curve straight edges, so feel free to divide them beforehand.
4. Activate the tool and select the Center point of your cylinder (any point laying on its axis).
5. Select the Zero point. The line from this point to the Center has to be perpendicular to the cylinder's axis.
  * This point and all points above and below it are invariant under this transformation.
6. Select the Reference point. The line from it to the Center also has to be perpendicular to the axis.
  * The distance between Zero and Reference will stay the same under the transformation.
7. Now your cylinder should be a flat surface. Notice how the singularity at the pole has turned
   the Center point into a line segment (called "Pole line").


### Wrap Cylinder tool
1. Create a group/component containing the surface you want to wrap.
2. Make sure the group is active and that there are no other groups/components inside it.
3. Make sure there are enough vertices. This extension doesn't curve straight edges, so feel free to divide them beforehand.
4. Activate the tool and select the end points of the Pole line. The order doesn't matter.
5. Select one Reference point. The plane defined by these 3 points has to be perpendicular to the axis.
7. Now your faces should form a cylindrical surface.
