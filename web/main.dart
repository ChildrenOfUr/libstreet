import 'package:libstreet/libstreet.dart';
import 'package:stagexl/stagexl.dart';
import 'dart:html';
import 'dart:convert';




main() async {
  StageXL.stageOptions.renderEngine = RenderEngine.Canvas2D;

  // Setting up the stageXL environment
  RESOURCES = new ResourceManager();
  STAGE = new Stage(querySelector('canvas'));
  new RenderLoop()
    ..addStage(STAGE);

  print('${STAGE.stageWidth} ${STAGE.stageHeight}');


  // load the JSON
  RESOURCES.addTextFile('groddle', 'groddle.json');
  await RESOURCES.load();

  // We turn the JSON into a map before we generate a street from it.
  // This allows us to dynamically create Maps and render Streets
  // from them without a JSON conversion process.
  Map groddleDef = JSON.decode(RESOURCES.getTextFile('groddle'));

  // Render the Street
  Street groddle = new Street(groddleDef);
  STAGE.addChild(groddle);

  await groddle.load();

  document.onKeyPress.listen((event) {
    if (event.keyCode == 65)
      groddle.camera_x--;
    if (event.keyCode == 68)
      groddle.camera_x++;
    if (event.keyCode == 87)
      groddle.camera_y--;
    if (event.keyCode == 83)
      groddle.camera_y++;
    groddle.update();
  });


  groddle.update();


}


