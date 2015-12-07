library libstreet;
import 'package:stagexl/stagexl.dart';
import 'dart:html' as html;
import 'dart:async';

part 'src/entity.dart';
part 'src/entities/player.dart';
part 'src/entities/npc.dart';

part 'src/camera.dart';
part 'src/layers.dart';
part 'src/street.dart';
part 'src/lines.dart';

part 'src/animation.dart';


abstract class StreetRenderer {
  // Static properties
  static Street current;
  static Camera camera = new Camera._();
  static html.CanvasElement canvas = html.querySelector('canvas#street');
  static Stage stage = new Stage(canvas, width: 1024, height: 768);
  static Juggler get juggler => stage.juggler;
  static RenderLoop _renderloop = new RenderLoop();
  static ResourceManager resourceManager = new ResourceManager();

  static preload(Map streetData) async {
    // load layer images.
    String tsid = streetData['tsid'].replaceRange(0, 1, 'L');
    for (Map layer in streetData['dynamic']['layers'].values) {
      String layerName = layer['name'].replaceAll(' ', '_');
      String url = 'http://childrenofur.com/assets/streetLayers/$tsid/$layerName.png';
      if (!StreetRenderer.resourceManager.containsBitmapData(layerName+tsid))
      StreetRenderer.resourceManager.addBitmapData(layerName+tsid, url);
    }
    await StreetRenderer.resourceManager.load();
  }

  /// Sets up the initial stage variables.
  static init() {
    StageXL.stageOptions
          ..antialias = false
          ..transparent = true
          ..backgroundColor = 0x00000000
          ..stageScaleMode = StageScaleMode.NO_SCALE
          ..stageAlign = StageAlign.TOP_LEFT;
    StageXL.bitmapDataLoadOptions.corsEnabled = true;
    _renderloop.addStage(stage);
  }

  static _setGradient(String top, String bottom) {
    canvas.style.background = "-webkit-linear-gradient(top, #$top, #$bottom)";
    canvas.style.background = "-moz-linear-gradient(top, #$top, #$bottom)";
    canvas.style.background = "-ms-linear-gradient(#$top, #$bottom)";
    canvas.style.background = "-o-linear-gradient(#$top, #$bottom)";
  }

  static _addLayer(Layer layer) {
    StreetRenderer.stage.addChild(layer);
    StreetRenderer.stage.juggler.add(layer);
  }

  static _clearLayers() {
    StreetRenderer.stage.children.clear();
    StreetRenderer.stage.juggler.clear();
  }
}
