# ps-corrupt
Script in processing to corrupt photos.

# Features

The script defines an image type called OImage that is a simple expansion of the original PImage type (adds wrapping option). There are four functions in OImage to corrupt photos:

1. img.pixelRemove
   This will randomly delete 10-20 pixels at a 0.002% chance on each pixel. This will shift all following pixels and will results in row chunks of the photo to be shifted to the left.
   
   ![pixelRemove](https://github.com/OdayMansour/ps-corrupt/blob/master/sample/pixelremove.jpg)

2. img.pixelSort
   This will pick columns of pixels that are closely similar (threshold of 110 shades by default) and will sort the pixels in that column.

   ![pixelSort](https://github.com/OdayMansour/ps-corrupt/blob/master/sample/pixelsort.jpg)
   
3. img.offset
   This will offset the red channel in the photo a predetermined value (default of 7 pixels).

   ![offset](https://github.com/OdayMansour/ps-corrupt/blob/master/sample/offset.jpg)

4. img.interlace
   This will add fake scan lines to the photo at a determined period (default of 2 pixels) and opacity (default of 0.8).
   
   ![interlace](https://github.com/OdayMansour/ps-corrupt/blob/master/sample/interlace.jpg)


You can combine functions to get an overall glitch effect:
![combo](https://github.com/OdayMansour/ps-corrupt/blob/master/sample/combo.jpg)
