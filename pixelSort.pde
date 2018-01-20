import java.util.*;

OImage img;
//int X = 1200;
//int Y = 675;
ComparableColor[] colors;
ImageLine colorline;
String filename="ny.jpg";
float thresh;

void setup() {
  
  noLoop();
  
  print(filename + "\n");
  
  img = new OImage();
  img.noWrap();
  
  img.oLoadImage(filename);

  img.pixelRemove();
//  img.pixelSort(110, 5, 1.0/4.0);
  img.offset("red", 7);

  img.interlace(2, 0.8);

  size(img.X, img.Y);

  img.export("sorted.jpg");
  
}

void draw() {
  O_image(img, 0, 0);
}

void O_image( OImage img, int x, int y ) {
  image(img.img, x, y);
}

float distance( color c1, color c2 ) {
  return sqrt( pow(red(c1)-red(c2),2) + pow(blue(c1)-blue(c2),2) + pow(green(c1)-green(c2),2) );
}

float distance2( color c1, color c2 ) {
  float r1, r2, g1, g2, b1, b2;
  float lum1, lum2;

  r1 = red(c1)/255;
  g1 = green(c1)/255;
  b1 = blue(c1)/255;
  lum1 = r1*0.3 + b1*0.11 + g1*0.59;

  r2 = red(c2)/255;
  g2 = green(c2)/255;
  b2 = blue(c2)/255;
  lum2 = r2*0.3 + b2*0.11 + g2*0.59;
  
  return abs(lum1 - lum2);
  
}

class OImage {
  PImage img;
  int X;
  int Y;
  boolean wrap;
  
  OImage() {
    this.img = new PImage();
    this.wrap = true;
    return;
  }
  
  void noWrap() {
    this.wrap = false;
  }
  
  color write( int x, int y, color c ) {
    if (wrap) {
      while ( x < 0 ) { x+=this.X; }
      while ( y < 0 ) { y+=this.Y; }
      x = x%this.X;
      y = y%this.Y;
      this.img.pixels[y*this.X + x] = c;
    } else {
      if ( x < this.X && x > 0 && y > 0 && y < this.Y ) {
        this.img.pixels[y*this.X + x] = c;
      }
    }
    return c;
  }
  
  color read( int x, int y ) {
    if ( x < this.X && x > 0 && y > 0 && y < this.Y ) {
      return img.pixels[y*X + x];
    } else {
      return color(0);
    }
  }
  
  void oLoadImage( String filepath ) {
    img = loadImage(filepath);
    X = img.width;
    Y = img.height;
    return;
  }
  
  void export(String filename) {
    img.save(filename);
    return;
  }
  
  void pixelSort( int thresh, int sens, float lift ) {
    for (int x=0; x<this.X; x++) {
      int y=0;
      int snipsize=0;
      while ( y < (this.Y-1) ) {
        if ( distance( this.read(x, y), this.read(x, y+1) ) > thresh || (y == this.Y-2) ) {
          if ( snipsize > sens ) {
            colorline = new ImageLine(this, x, y-snipsize, snipsize ); // take full vertical line
            Arrays.sort( colorline.content, new ColorComparator()); // sort line
            for (int i=0; i<colorline.count; i++) { // write back to image
              this.write( colorline.startX, (int)(colorline.startY+i - snipsize*lift), colorline.content[i].old );
            }
          }
          
          snipsize=0;
        }
        y++;
        snipsize++;
      }
    }
    return;
  }
  
  void offset( String channel, int offset ) {
    float s;
    color d;
    for (int x=0; x<this.X; x++) {
      for (int y=0; y<this.Y; y++) {
        s = red( this.read(x+offset, y) ); // get the red on the offet pixel;
        d = this.read(x, y);
        d = color( s, green(d), blue(d) );
        this.write( x, y, d );
      }
    }
  }
  
  void interlace( int interval, float amount ) {
    color c;
    for (int x=0; x<this.X; x++) {
      for (int y=0; y<this.Y; y++) {
        if ( (y/interval)%2 == 1 ) {
          c = this.read(x, y);
          c = color( red(c)*amount, green(c)*amount, blue(c)*amount );
          this.write(x, y, c);
        }
      }
    }
  }
  
  void pixelRemove() {
    int offset = 0;
    PImage newimg = this.img;
    for (int i=0; max((i+offset),0)<this.img.pixels.length && i<this.img.pixels.length; i++) {
      newimg.pixels[i] = img.pixels[max(i+offset,0)];
      if ( random(100) > 99.998 ) {
        offset += (int)random(30)-10;
        print(offset);
        print(" ");
      }
    } 
    img = newimg;
  }
}

class ImageLine {
  int startX;
  int startY;
  int count;
  ComparableColor[] content;
  
  ImageLine( PImage source, int x, int y, int nb ) {
    startX = x;
    startY = y;
    count = nb;
    content = new ComparableColor[count];
    for (int i=0; i<count; i++) {
      content[i] = new ComparableColor( source.pixels[(y+i)*X + x] );
    }
  }
  ImageLine( OImage source, int x, int y, int nb ) {
    startX = x;
    startY = y;
    count = nb;
    content = new ComparableColor[count];
    for (int i=0; i<count; i++) {
      content[i] = new ComparableColor( source.read(x, (y+i)) );
    }
  }
  void writeToImage( PImage dest ) {
    for (int i=0; i<count; i++) {
      dest.pixels[(startY+i)*X + startX] = content[i].old;
    }
  }
}

class ComparableColor {
  color old;
  float value;
  
  ComparableColor( color orig ) {
    old = orig;
    value = brightness(orig);
  }
}

class ColorComparator implements Comparator<ComparableColor> {
  int compare( ComparableColor c1, ComparableColor c2 ) {
    int first = (int)-(c1.value - c2.value);
    if ( first != 0 ) {
      return first;
    } else {
      return (int)( hue(c1.old) - hue(c2.old) );
    }
  }
}
