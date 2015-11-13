import 'package:stagexl/stagexl.dart';
import 'dart:convert';
import 'package:libstreet/libstreet.dart';
import 'dart:html' as html;

ResourceManager RESOURCES = new ResourceManager();

main() async {
  RESOURCES.addTextFile('groddle', 'GLI3272LOTD1B1F.json');
  await RESOURCES.load();
    Map groddleDef = JSON.decode(RESOURCES.getTextFile('groddle'));

    StreetRenderer street = new StreetRenderer(groddleDef);
    await street.loaded;

    loop();

    html.document.onKeyPress.listen((event) {
		if(event.keyCode == 97)
			StreetRenderer.camera.x -= 30;
		if(event.keyCode == 100)
			StreetRenderer.camera.x += 30;
		if(event.keyCode == 119)
			StreetRenderer.camera.y -= 30;
		if(event.keyCode == 115)
			StreetRenderer.camera.y += 30;
	});
}


loop() async {
  await html.window.animationFrame;
  StreetRenderer.render();
  loop();
}
