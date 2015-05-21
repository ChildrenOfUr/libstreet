import 'package:libstreet/libstreet.dart';
import 'package:stagexl/stagexl.dart';
import 'dart:html' as html;
import 'dart:async';
import 'dart:convert';

main() async {
	//StageXL.stageOptions.renderEngine = RenderEngine.WebGL;

	// Setting up the stageXL environment
	RESOURCES = new ResourceManager();
	STAGE = new Stage(html.querySelector('canvas'));
	new RenderLoop()
		..addStage(STAGE);

  Street groddle;
  // load the JSON
  RESOURCES.addTextFile('groddle', 'groddle.json');
  await RESOURCES.load();

  //new Timer.periodic(new Duration(seconds:10), (_) async {
    print('Loop start');
    STAGE.removeChildren();

		if (groddle != null)
			groddle.destroy();

    // We turn the JSON into a map before we generate a street from it.
    // This allows us to dynamically create Maps and render Streets
    // from them without a JSON conversion process.
    Map groddleDef = JSON.decode(RESOURCES.getTextFile('groddle'));

    // Render the Street
    groddle = new Street(groddleDef);
    STAGE.addChild(groddle);

    await groddle.activate();
    print('Loop end');
  //});

	// WASD
	html.document.onKeyPress.listen((event) {
		if(event.keyCode == 97)
			groddle.camera.x -= 30;
		if(event.keyCode == 100)
			groddle.camera.x += 30;
		if(event.keyCode == 119)
			groddle.camera.y -= 30;
		if(event.keyCode == 115)
			groddle.camera.y += 30;
	});

	html.querySelector('#toggleStreet').onClick.listen((_) {
    print('bam');
    groddle.destroy();
  });


}