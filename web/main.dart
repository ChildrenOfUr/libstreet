import 'package:stagexl/stagexl.dart';
import 'dart:convert';
import 'package:libstreet/libstreet.dart';
import 'dart:html' as html;

ResourceManager resourceManager = new ResourceManager();

main() async {
  resourceManager.addTextFile('groddle', 'cave.json');
  await resourceManager.load();
  Map groddleDef = JSON.decode(resourceManager.getTextFile('groddle'));

  StreetRenderer.init();
  await StreetRenderer.preload(groddleDef);
  Street groddle = new Street(groddleDef);
  StreetRenderer.stage.addChild(groddle);

  Player paal = new Player('paal');
  await paal.load();
  paal.y = groddle.bounds.top + 200;
  paal.x = groddle.bounds.left + 200;
  paal.animation.set('idle');
  StreetRenderer.juggler.add(paal);
  groddle.entityLayer.addChild(paal);

  html.document.onKeyPress.listen((event) {
	  if(event.keyCode == 97) {
			StreetRenderer.camera.x -= 50;
    }
		if(event.keyCode == 100) {
			StreetRenderer.camera.x += 50;
    }
		if(event.keyCode == 119) {
		 StreetRenderer.camera.y -= 50;
    }
		if(event.keyCode == 115) {
			StreetRenderer.camera.y += 50;
    }
	});
}
