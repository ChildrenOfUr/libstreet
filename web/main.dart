import 'package:stagexl/stagexl.dart';
import 'dart:convert';
import 'package:libstreet/libstreet.dart';
import 'dart:html' as html;

ResourceManager resourceManager = new ResourceManager();

main() async {
  resourceManager.addTextFile('groddle', 'GLI3272LOTD1B1F.json');
  await resourceManager.load();
  Map groddleDef = JSON.decode(resourceManager.getTextFile('groddle'));

  StreetRenderer street = new StreetRenderer(groddleDef);
  await street.loaded;


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
