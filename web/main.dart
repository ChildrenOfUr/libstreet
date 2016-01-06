import 'package:stagexl/stagexl.dart';
import 'dart:convert';
import 'dart:async';
import 'package:libstreet/libstreet.dart';
import 'dart:html' as html;

ResourceManager resourceManager = new ResourceManager();

main() async {
  resourceManager.addTextFile('groddle', 'mira.json');
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

  new Timer.periodic(new Duration(milliseconds:15), (_) {
    StreetRenderer.camera.x = paal.x - groddle.bounds.left;
    StreetRenderer.camera.y = paal.y - groddle.bounds.top;
  });

  html.document.onKeyPress.listen((event) {
	  if(event.keyCode == 97) {
			paal.impulse(-10, 0);
    }
		if(event.keyCode == 100) {
		  paal.impulse(10, 0);
    }
		if(event.keyCode == 119) {
      if (paal.isOnGround)
		  paal.impulse(0, -20);
    }
		if(event.keyCode == 115) {
		  paal.impulse(0, 10);
    }
	});
}
