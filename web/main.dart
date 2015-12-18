import 'package:stagexl/stagexl.dart';
import 'dart:convert';
import 'dart:async';
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

/*
  groddle.onMouseRightClick.listen((e) async {
    Point xy = StreetRenderer.localToStreet(new Point(e.stageX, e.stageY));
    Player player = new Player("Paal");
    await player.load();
    player.y = xy.y;
    player.x = xy.x;
    player.animation.set('idle');
    StreetRenderer.juggler.add(player);
    groddle.entityLayer.addChild(player);
  });
*/

  Player player = new Player("Paal");
  await player.load();
  player.y = groddle.bounds.top + 200;
  player.x = groddle.bounds.left + 200;
  player.animation.set('idle');
  StreetRenderer.juggler.add(player);
  groddle.entityLayer.addChild(player);


  new Timer.periodic(new Duration(milliseconds: 15), (_) {
    StreetRenderer.camera.x = player.x;
    StreetRenderer.camera.y = player.y;
  });

  html.document.onKeyPress.listen((event) {
	  if(event.keyCode == 97) {
			player.x -= 10;
    }
		if(event.keyCode == 100) {
			player.x += 10;
    }
		if(event.keyCode == 119) {
		  player.y -= 1000;
    }
		if(event.keyCode == 115) {
			player.y += 10;
    }
	});
}
