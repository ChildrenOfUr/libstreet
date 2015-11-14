library libstreet;
import 'package:stagexl/stagexl.dart';
import 'dart:html' as html;
import 'dart:async';
part 'src/camera.dart';

ResourceManager resourceManager = new ResourceManager();

class StreetRenderer {
  Map streetData;
  Rectangle bounds;
  int groundY;

  // Return the TSID, starting with an L
  String _tsid;
  String get tsid {
    if (_tsid.startsWith('G')) {
      return _tsid.replaceFirst('G', 'L');
    } else {
      return _tsid;
    }
  }

  Completer _whenLoaded;
  Future loaded;

  StreetRenderer(this.streetData) {
    _whenLoaded = new Completer();
    loaded = _whenLoaded.future;

    // initialize the renderer
    if (!_initialized) _init();
    // set the current street
    current = this;
    layers.children.clear();
    _tsid = streetData['tsid'];

    bounds = new Rectangle(streetData['dynamic']['l'],
        streetData['dynamic']['t'],
        streetData['dynamic']['l'].abs() + streetData['dynamic']['r'].abs(),
        (streetData['dynamic']['t'] - streetData['dynamic']['b']).abs());

    String top = streetData['gradient']['top'];
    String bottom = streetData['gradient']['bottom'];
    canvas.style.background = "-webkit-linear-gradient(top, #$top, #$bottom)";
    canvas.style.background = "-moz-linear-gradient(top, #$top, #$bottom)";
    canvas.style.background = "-ms-linear-gradient(#$top, #$bottom)";
    canvas.style.background = "-o-linear-gradient(#$top, #$bottom)";

    if (!resourceManager.containsBitmapData('player'))
    resourceManager.addBitmapData('player', './testPlayer.png');

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
        layers.addChild(layerBitmap);
      }
      Bitmap player = new Bitmap(resourceManager.getBitmapData('player'))
        ..name = 'player';
      layers.addChild(player);

      _whenLoaded.complete();
    });
  }

  static render() {
    for (DisplayObject layerBitmap in layers.children) {
      num currentPercentX = (camera.x) / (current.bounds.width - camera.viewport.width);
      num currentPercentY = (camera.y) / (current.bounds.height - camera.viewport.height);
      num offsetX = (layerBitmap.width - camera.viewport.width) * currentPercentX;
      num offsetY = (layerBitmap.height - camera.viewport.height) * currentPercentY;

      if (layerBitmap.name != 'player') {
        layerBitmap
          ..x = -offsetX
          ..y = -offsetY;
      }
      else {
        // player icon
      layerBitmap.setTransform(camera.viewport.width/2 - (layerBitmap.width/2), camera.viewport.height/2 - (layerBitmap.height/2));
      };
    }
  }

// Static properties
  static StreetRenderer current;
  static Camera camera = new Camera._();
  static html.CanvasElement canvas = html.querySelector('canvas#street');
  static Sprite layers = new Sprite();
  static Stage stage = new Stage(
    html.querySelector('#street'),
    // whatever this is, we need to keep the same aspect ratios
    width: 1104,
    height: 621
  )
  ..addChild(layers);
  static RenderLoop _renderloop = new RenderLoop();
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
}
