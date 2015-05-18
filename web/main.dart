import 'package:libstreet/libstreet.dart';
import 'package:stagexl/stagexl.dart';
import 'dart:html';
import 'dart:convert';

main() async {
	StageXL.stageOptions.renderEngine = RenderEngine.WebGL;

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
		if(event.keyCode == 97)
			groddle.camera.x -= 30;
		if(event.keyCode == 100)
			groddle.camera.x += 30;
		if(event.keyCode == 119)
			groddle.camera.y -= 30;
		if(event.keyCode == 115)
			groddle.camera.y += 30;

		groddle.update();
	});

	groddle.update();
}