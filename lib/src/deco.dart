part of libstreet;


class Deco extends Sprite {
  DecoLayer layer;
  Map def;

  int z;

  Deco._(final this.def, {this.layer}) {
    Bitmap b_deco = new Bitmap(RESOURCES.getBitmapData(def['filename']));

    addChild(b_deco);

    pivotX = width/2;
    pivotY = height;
    x = def['x'];
    y = def['y'];
    z = def['z'];

    // Set width
    if (def['h_flip'] == true)
      width = -def['w'];
    else
      width = def['w'];
    // Set height
    if (def['v_flip'] == true)
      height = -def['h'];
    else
      height = def['h'];

    if (def['r'] != null) {
      rotation = def['r'] * Math.PI/180;
    }
  }
}