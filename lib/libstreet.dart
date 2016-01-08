library libstreet;

import 'package:stagexl/stagexl.dart';
import 'dart:html' as html;
import 'dart:math' as Math;
import 'dart:async';

part 'src/keyboard.dart';

part 'src/entities/entity.dart';
part 'src/entities/player.dart';
part 'src/entities/quoin.dart';
part 'src/entities/npc.dart';

part 'src/street/camera.dart';
part 'src/street/layers.dart';
part 'src/street/street.dart';
part 'src/street/lines.dart';

part 'src/animation.dart';
part 'src/entities/physics.dart';

abstract class StreetRenderer {
  // Static properties
  static Street current;
  static Camera camera = new Camera._();
  static html.CanvasElement canvas = html.querySelector('canvas#street');
  static Stage stage = new Stage(canvas, width: 1024, height: 768);
  static Juggler get juggler => stage.juggler;
  static RenderLoop _renderloop = new RenderLoop();
  static ResourceManager resourceManager = new ResourceManager();
  static BitmapData pixel;

  static preload(Map streetData) async {
    // load layer images.
    String tsid = streetData['tsid'].replaceRange(0, 1, 'L');
    for (Map layer in streetData['dynamic']['layers'].values) {
      String layerName = layer['name'].replaceAll(' ', '_');
      String url =
          'http://childrenofur.com/assets/streetLayers/$tsid/$layerName.png';
      if (!StreetRenderer.resourceManager
          .containsBitmapData(layerName + tsid)) StreetRenderer.resourceManager
          .addBitmapData(layerName + tsid, url);
    }
    await StreetRenderer.resourceManager.load();
  }

  /// Sets up the initial stage variables.
  static init() {
    Keyboard.init();
    StageXL.stageOptions
      ..antialias = true
      ..transparent = true
      ..backgroundColor = 0x00000000
      ..stageScaleMode = StageScaleMode.NO_SCALE
      ..stageAlign = StageAlign.TOP_LEFT;
    StageXL.bitmapDataLoadOptions.corsEnabled = true;
    _renderloop.addStage(stage);

    // create a general purpose white pixel bitmapdata.
    Shape shape = new Shape();
    shape.graphics.rect(0, 0, 10, 10);
    shape.graphics.fillColor(Color.White);
    shape.applyCache(0, 0, 10, 10);
    pixel = new BitmapData.fromRenderTextureQuad(shape.cache);
  }

  /// set the gradient of the background.
  static setGradient(String top, String bottom) {
    canvas.style.background = "-webkit-linear-gradient(top, #$top, #$bottom)";
    canvas.style.background = "-moz-linear-gradient(top, #$top, #$bottom)";
    canvas.style.background = "-ms-linear-gradient(#$top, #$bottom)";
    canvas.style.background = "-o-linear-gradient(#$top, #$bottom)";
  }

  /// Converts a 'stage' coordinate to a 'street' coordinate.
  /// Takes two [num] and spits out a [Point].
  static Point localToStreet(Point stage) {
    num x = stage.x +
        StreetRenderer.camera.x -
        StreetRenderer.camera.viewport.width / 2 +
        StreetRenderer.current.bounds.left;
    num y = stage.y +
        StreetRenderer.camera.y -
        StreetRenderer.camera.viewport.height / 2 +
        StreetRenderer.current.bounds.top;
    return new Point(x, y);
  }

  static String snap([BitmapFilter filter]) {
    if (filter != null) {
      StreetRenderer.stage.children.first.filters.add(filter);
    }
    StreetRenderer.stage.children.first.applyCache(
        0,
        0,
        StreetRenderer.camera.viewport.width,
        StreetRenderer.camera.viewport.height);
    String dataUrl = new BitmapData.fromRenderTextureQuad(
        StreetRenderer.stage.children.first.cache).toDataUrl();
    if (filter != null) {
      StreetRenderer.stage.children.first.filters.remove(filter);
    }
    StreetRenderer.stage.children.first.removeCache();

    return dataUrl;
  }
}
