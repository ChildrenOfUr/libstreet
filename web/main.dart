import 'package:stagexl/stagexl.dart';
import 'dart:convert';
import 'package:libstreet/libstreet.dart';
import 'dart:html' as html;

ResourceManager resourceManager = new ResourceManager();

main() async {
  resourceManager.addTextFile('groddle', 'GLI3272LOTD1B1F.json');
  await resourceManager.load();
  Map groddleDef = JSON.decode(resourceManager.getTextFile('groddle'));

  StreetRenderer street = new StreetRenderer.Street(groddleDef);
  await street.loaded;

  resourceManager.addBitmapData('player', 'testPlayer.png');
  await resourceManager.load();

  Bitmap player = new Bitmap(resourceManager.getBitmapData('player'));
  street.entities.addChild(player);

  html.document.onKeyPress.listen((event) {
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

}
