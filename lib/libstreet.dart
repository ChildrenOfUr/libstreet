import 'package:stagexl/stagexl.dart';
import 'dart:html' as html;
import 'dart:math' as Math;

ResourceManager RESOURCES;
Stage STAGE;








/// TODO We'll use the Street and StreetLayer classes
/// to proxy the DisplayObject containers instead of extending them
/// This will prevent us from getting confused by the four different x variables.




















class Street extends DisplayObjectContainer {
  Map _streetDef;

  String get label => _streetDef['label'];
  int get groundY => -(_streetDef['dynamic']['ground_y'] as int).abs();


  Rectangle get streetBounds => new Rectangle(
      _streetDef['dynamic']['l'],
      _streetDef['dynamic']['t'],
      (_streetDef['dynamic']['l'].abs() + _streetDef['dynamic']['r'].abs()).toInt(),
      (_streetDef['dynamic']['t'].abs() + _streetDef['dynamic']['b'].abs()).toInt()
  );

  num camera_x = 0;
  num camera_y = 0;
  setCamera(num x, num y) {
    camera_x = x;
    camera_y = y;
    update();
  }


  Street(final this._streetDef);

  load() async {
    await loadDecos();

    // Gradient Layer
    addChild(gradient());

    // Sort by z values
    List layerList = new List.from(_streetDef['dynamic']['layers'].values)
      ..sort((Map A, Map B) => A['z'].compareTo(B['z']));

    for (Map layerDef in layerList) {
      Sprite layer = new StreetLayer(layerDef, streetBounds, groundY);
      addChild(layer);

    }

  }

  /// Returns a DisplayObject containing the background gradient of the street.
  DisplayObject gradient() {
    var shape = new Shape();
    shape.graphics.rect(0, 0, streetBounds.width, streetBounds.height);
    shape.graphics.fillGradient(
        new GraphicsGradient.linear(0, 0, 0, streetBounds.height)
          ..addColorStop(0, int.parse('0xFF' + _streetDef['gradient']['top']))
          ..addColorStop(1, int.parse('0xFF' + _streetDef['gradient']['bottom']))
    );
    shape.applyCache(0,0, streetBounds.width, streetBounds.height);
    return shape;
  }


  /// Completes when each deco is loaded into memory.
  loadDecos() async {

    var loadOptions = new BitmapDataLoadOptions()
      ..corsEnabled = true;

    // Collect the url of each deco to load.
    for (Map layer in _streetDef['dynamic']['layers'].values)
    {
      for (Map deco in layer['decos'])
      {
        if ( !RESOURCES.containsBitmapData(deco['filename']) )
          RESOURCES.addBitmapData(
              deco['filename'],
            'http://childrenofur.com/locodarto/scenery/' + deco['filename'] + '.png',
            loadOptions
          );
      }
    }
    await RESOURCES.load();
    if (RESOURCES.failedResources.isNotEmpty)
      throw('failed to download decos ${RESOURCES.failedResources}');
  }

  update() {

    x= camera_x;
    y= camera_y;


    List layers = children.where((E) => E is StreetLayer);
    for (StreetLayer layer in layers) {
      layer.update();
    }
  }

}

class StreetLayer extends Sprite {
  Map layerDef;
  int groundY;
  Rectangle streetBounds;
  StreetLayer(this.layerDef, this.streetBounds, this.groundY) {

    // Sort by z values
    List decoList = layerDef['decos']
      ..sort((Map A, Map B) => A['z'].compareTo(B['z']));

    for (Map decoMap in decoList) {
      // Assume the deco BitmapData is loaded into memory, [Street] should do this.
      Bitmap b_deco = new Bitmap(RESOURCES.getBitmapData(decoMap['filename']));

      // debug
      Sprite deco = new Sprite()
        ..addChild(b_deco);

      deco.x = decoMap['x'] - decoMap['w'] ~/ 2;
      deco.y = decoMap['y'] - decoMap['h'] + groundY;

      if(layerDef['name'] == 'middleground')
      {
        //middleground has different layout needs
        deco.y += layerDef['h'];
        deco.x += layerDef['w'] ~/ 2;
      }

      // Set width
      if (decoMap['h_flip'] == true)
        deco.width = -decoMap['w'];
      else
        deco.width = decoMap['w'];
      // Set height
      if (decoMap['v_flip'] == true)
        deco.height = -decoMap['h'];
      else
        deco.height = decoMap['h'];

      if (decoMap['r'] != null) {
        deco.rotation = decoMap['r'] * Math.PI/180;
      }

      deco.onMouseClick.listen((_) {
        print(layerDef['name'] + ' ' + decoMap['filename']);
      });

      // Add to the layer
      this.addChild(deco);
    }

    update();
  }
  update() {

    num currentPercentX = camera.getX() / (streetBounds.width - STAGE.stageWidth);
    num currentPercentY = camera.getY() / (streetBounds.height - STAGE.stageHeight);

    //modify left and top for parallaxing
    num offsetX = (layerDef['w'] - STAGE.stageWidth) * currentPercentX - (layerDef['w']/2);
    num offsetY = (layerDef['h'] - STAGE.stageHeight) * currentPercentY - (layerDef['h']/2);
    offsetY += groundY;

    x = -offsetX;
    y = -offsetY;

  }

}