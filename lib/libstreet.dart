library libstreet;
import 'package:stagexl/stagexl.dart';
import 'dart:html' as html;
import 'dart:async';
part 'src/camera.dart';

class StreetRenderer extends Animatable {
  Map streetData;
  Rectangle bounds;
  String tsid;
  Completer _whenLoaded;
  Future loaded;

  StreetRenderer(this.streetData) {
    _whenLoaded = new Completer();
    loaded = _whenLoaded.future;

    // initialize the renderer
    if (!_initialized) _init();

    // remove the old street from the juggler
    if (_renderloop.juggler.contains(current))
      _renderloop.juggler.remove(current);

    // set the current street
    current = this;
    stage.children.clear();

    // declare some useful properties.
    tsid = streetData['tsid'].replaceRange(0, 0, 'L');
    bounds = new Rectangle(streetData['dynamic']['l'],
        streetData['dynamic']['t'],
        streetData['dynamic']['l'].abs() + streetData['dynamic']['r'].abs(),
        (streetData['dynamic']['t'] - streetData['dynamic']['b']).abs());

    // set the canvas gradient.
    String top = streetData['gradient']['top'];
    String bottom = streetData['gradient']['bottom'];
    canvas.style.background = "-webkit-linear-gradient(top, #$top, #$bottom)";
    canvas.style.background = "-moz-linear-gradient(top, #$top, #$bottom)";
    canvas.style.background = "-ms-linear-gradient(#$top, #$bottom)";
    canvas.style.background = "-o-linear-gradient(#$top, #$bottom)";

    // load and inject the layer images.
    for (Map layer in streetData['dynamic']['layers'].values) {
      String layerName = layer['name'].replaceAll(' ', '_');
      String url = 'http://childrenofur.com/assets/streetLayers/$tsid/$layerName.png';
      if (!resourceManager.containsBitmapData(layerName+tsid))
      resourceManager.addBitmapData(layerName+tsid, url);
    }
    resourceManager.load().then((_) {
      List layerMaps = new List.from(streetData['dynamic']['layers'].values);
      layerMaps.sort( (Map A, Map B) => A['z'].compareTo(B['z']) );

      for (Map layer in layerMaps) {
        String layerName = layer['name'].replaceAll(' ', '_');
        Bitmap layerBitmap = new Bitmap(resourceManager.getBitmapData(layerName+tsid));
        layerBitmap.name = layerName;
        stage.addChild(layerBitmap);
      }
      _whenLoaded.complete();
    });
    _renderloop.juggler.add(this);
  }

  // Static properties
  static StreetRenderer current;
  static Camera camera = new Camera._();
  static html.CanvasElement canvas = html.querySelector('canvas#street');
  static Stage stage = new Stage(canvas, width: 1024, height: 768);
  static RenderLoop _renderloop = new RenderLoop();
  static ResourceManager resourceManager = new ResourceManager();

  static bool _initialized = false;
  /// Sets up the initial stage variables.
  static _init() {
    StageXL.stageOptions
          ..transparent = true
          ..backgroundColor = 0x00000000
          ..stageScaleMode = StageScaleMode.NO_BORDER;
    StageXL.bitmapDataLoadOptions.corsEnabled = true;
    _renderloop.addStage(stage);
  }

  // Adjusts the layers according to the camera position.
  @override
  advanceTime(num time) {
    for (DisplayObject layer in stage.children) {
      num currentPercentX = (camera.x) / (current.bounds.width - camera.viewport.width);
      num currentPercentY = (camera.y) / (current.bounds.height - camera.viewport.height);
      num offsetX = (layer.width - camera.viewport.width) * currentPercentX;
      num offsetY = (layer.height - camera.viewport.height) * currentPercentY;
        layer
          ..x = -offsetX
          ..y = -offsetY;
    };
  }
}
