library libstreet;
import 'package:stagexl/stagexl.dart';
import 'dart:html' as html;
import 'dart:async';
part 'src/camera.dart';
part 'src/layers.dart';

class StreetRenderer {
  Map streetData;
  Rectangle bounds;
  String tsid;
  Completer _whenLoaded;
  Future loaded;

  EntityLayer entities;

  StreetRenderer.Street(this.streetData) {
    _whenLoaded = new Completer();
    loaded = _whenLoaded.future;

    // initialize the renderer
    if (!_initialized) _init();

    // set the current street
    current = this;

    // declare some useful properties.
    tsid = streetData['tsid'].replaceRange(0, 1, 'L');
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

    // load layer images.
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
        addLayer(new ImageLayer(tsid, layerName));
        if (layerName == 'middleground') {
          entities = new EntityLayer();
          addLayer(entities);
        }
      }
      _whenLoaded.complete();
    });
  }

  addLayer(Layer layer) {
    stage.addChild(layer);
    stage.juggler.add(layer);
  }

  clear() {
    stage.children.clear();
    stage.juggler.clear();
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
          ..stageScaleMode = StageScaleMode.NO_SCALE
          ..stageAlign = StageAlign.TOP_LEFT;
    StageXL.bitmapDataLoadOptions.corsEnabled = true;
    _renderloop.addStage(stage);
  }

}
