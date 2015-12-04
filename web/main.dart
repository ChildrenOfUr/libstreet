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

  Animation player = new Animation();
  await player.load(playerData);
  groddle.entityLayer.addChild(player);

  html.document.onKeyPress.listen((event) {
    player.set('walk');
	  if(event.keyCode == 97)
			player.x -= 30;
		if(event.keyCode == 100)
			player.x += 30;
		if(event.keyCode == 119)
		  player.y -= 30;
		if(event.keyCode == 115)
			player.y += 30;

    StreetRenderer.camera.x = player.x;
    StreetRenderer.camera.y = player.y;
	});
  html.document.onKeyUp.listen((_) {
    player.set('default');
  });
}
