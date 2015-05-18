part of libstreet;


class Deco extends Sprite {
  Map decoDef;
  Deco(final this.decoDef) {
    Bitmap b_deco = new Bitmap(RESOURCES.getBitmapData(decoDef['filename']));
    this.addChild(b_deco);

    pivotX = width/2;
    pivotY = height;
    x = decoDef['x'];
    y = decoDef['y'];

    // Set width
    if (decoDef['h_flip'] == true)
      width = -decoDef['w'];
    else
      width = decoDef['w'];
    // Set height
    if (decoDef['v_flip'] == true)
      height = -decoDef['h'];
    else
      height = decoDef['h'];

    if (decoDef['r'] != null) {
      rotation = decoDef['r'] * Math.PI/180;
    }
  }




}