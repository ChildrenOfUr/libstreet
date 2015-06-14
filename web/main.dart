import 'package:libstreet/libstreet.dart';
import 'package:stagexl/stagexl.dart';
import 'dart:html' as html;
import 'dart:convert';

ResourceManager RESOURCES = new ResourceManager();

main() async {

  RESOURCES.addTextFile('groddle', 'GLI3272LOTD1B1F.json');
  await RESOURCES.load();

    // We turn the JSON into a map before we generate a street from it.
    // This allows us to dynamically create Maps and render Streets
    // from them without a JSON conversion process.
    Map groddleDef = JSON.decode(RESOURCES.getTextFile('groddle'));

	Street groddle = new Street(groddleDef);

	StreetRenderer renderer = new StreetRenderer();
	renderer.render(groddle);


	print(groddle.height.toString() + ' ' + groddle.width.toString());

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
}