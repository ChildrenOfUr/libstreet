part of libstreet;


List _decoPool = [];

class Deco extends Bitmap {
  DecoLayer layer;
  Map def;
  int z;

  Deco._();

  factory Deco(Map def, {layer}) {
    Deco deco;
    if (_decoPool.isNotEmpty)
      deco = _decoPool.take(1).single;
    else
      deco = new Deco._();

    deco.bitmapData = RESOURCES.getBitmapData(def['filename']);

    deco.pivotX = deco.width/2;
    deco.pivotY = deco.height;
    deco.x = def['x'];
    deco.y = def['y'];
    deco.z = def['z'];

    // Set width
    if (def['h_flip'] == true)
      deco.width = -def['w'];
    else
      deco.width = def['w'];
    // Set height
    if (def['v_flip'] == true)
      deco.height = -def['h'];
    else
      deco.height = def['h'];

    if (def['r'] != null) {
      deco.rotation = def['r'] * Math.PI/180;
    }

    deco.def = def;
    deco.layer = layer;

    return deco;
  }

  dispose() {
    bitmapData.renderTexture.dispose();
    _decoPool.add(this);
    if (parent != null);
      parent.removeChild(this);
    print('Decos in pool: ${_decoPool.length}');
  }
}