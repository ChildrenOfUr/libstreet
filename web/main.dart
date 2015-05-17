import 'package:libstreet/libstreet.dart';
import 'package:stagexl/stagexl.dart';
import 'dart:html';
import 'dart:convert';




main() async {
  //StageXL.stageOptions.renderEngine = RenderEngine.Canvas2D;

  // Setting up the stageXL environment
  RESOURCES = new ResourceManager();
  STAGE = new Stage(querySelector('canvas'));
  new RenderLoop()
    ..addStage(STAGE);

  // load the JSON
  RESOURCES.addTextFile('groddle', 'groddle.json');
  await RESOURCES.load();

  // We turn the JSON into a map before we generate a street from it.
  // This allows us to dynamically create Maps and render Streets
  // from them without a JSON conversion process.
  Map groddleDef = JSON.decode(RESOURCES.getTextFile('groddle'));

  // Render the Street
  var groddle = new Street(groddleDef)
    ..activate();

  STAGE.addChild(groddle);

  document.onKeyPress.listen((event) {
    var key = event.keyCode;
    if (key == 100)
      groddle.camera.x += 5;
    if (key == 97)
      groddle.camera.x -= 5;
    if (key == 115)
      groddle.camera.y += 5;
    if (key == 119)
      groddle.camera.y -= 5;

    print(groddle.camera);

    print(key);
  });




}


