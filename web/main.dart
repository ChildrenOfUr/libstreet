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
