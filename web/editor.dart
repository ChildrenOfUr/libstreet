import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'package:libstreet/commander.dart';
import 'package:libstreet/animation.dart';


class Renderer {
  static html.CanvasElement canvas = html.querySelector('canvas#street');
  static Stage stage = new Stage(canvas, width: 1024, height: 768);
  static Juggler get juggler => stage.juggler;
  static RenderLoop _renderloop = new RenderLoop();
  static ResourceManager resourceManager = new ResourceManager();

  init() {
    Animation.setJuggler(juggler);
    StageXL.stageOptions
      ..antialias = true
      ..transparent = true
      ..inputEventMode = InputEventMode.MouseAndTouch
      ..backgroundColor = 0x00000000
      ..stageScaleMode = StageScaleMode.NO_SCALE
      ..stageAlign = StageAlign.TOP_LEFT;
    StageXL.bitmapDataLoadOptions.corsEnabled = true;
    _renderloop.addStage(stage);
  }
}

main() {


}
