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
    groundY = -(streetData['dynamic']['ground_y'] as num).abs();

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
      layerMaps.forEach((Map layer) => print(layer['z']) );
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
      num currentPercentX = camera.x / (current.bounds.width);
      num currentPercentY = camera.y / (current.bounds.height);
      num offsetX = (layerBitmap.width - stage.width) * currentPercentX;
      num offsetY = (layerBitmap.height - stage.height) * currentPercentY;
      if (layerBitmap.name == 'middleground') offsetY -= current.groundY;


      if (layerBitmap.name != 'player')
      layerBitmap.setTransform(-offsetX, -offsetY);
      else
      layerBitmap.setTransform(camera.x, camera.y);
    }
    layers.setTransform(-camera.x/2, -camera.y/2);
  }

// Static properties
  static StreetRenderer current;
  static Camera camera = new Camera._();
  static html.CanvasElement canvas = html.querySelector('canvas#street');
  static Sprite layers = new Sprite();
  static Stage stage = new Stage(
    html.querySelector('#street'),
    width: 1024,
    height: 768
  )
  ..addChild(layers);
  static RenderLoop _renderloop = new RenderLoop();
  static bool _initialized = false;
  /// Sets up the initial stage variables.
  static _init() {
    StageXL.stageOptions
          ..transparent = true
          ..backgroundColor = 0x00000000;
    StageXL.bitmapDataLoadOptions.corsEnabled = true;

    _renderloop.addStage(stage);
  }
}
