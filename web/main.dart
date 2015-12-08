import 'package:stagexl/stagexl.dart';
import 'dart:convert';
import 'package:libstreet/libstreet.dart';
import 'dart:html' as html;

ResourceManager resourceManager = new ResourceManager();

main() async {
  resourceManager.addTextFile('groddle', 'GLI3272LOTD1B1F.json');
  await resourceManager.load();
  Map groddleDef = JSON.decode(resourceManager.getTextFile('groddle'));

  StreetRenderer.init();
  await StreetRenderer.preload(groddleDef);
  Street groddle = new Street(groddleDef);
  StreetRenderer.stage.addChild(groddle);


  AnchorCircle a = new AnchorCircle(10, Color.Purple, Color.White);

  groddle.collisionLayer.addChild(a);

  a.x = 100;
  a.y = 100;

  html.document.onKeyPress.listen((event) {
	  if(event.keyCode == 97) {
			StreetRenderer.camera.x -= 10;
    }
		if(event.keyCode == 100) {
			StreetRenderer.camera.x += 10;
    }
		if(event.keyCode == 119) {
		  StreetRenderer.camera.y -= 10;
    }
		if(event.keyCode == 115) {
			StreetRenderer.camera.y += 10;
    }
	});
}
