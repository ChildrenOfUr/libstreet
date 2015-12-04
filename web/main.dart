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

  Animation player = new Animation()
    ..x = groddle.bounds.width/2
    ..y = groddle.bounds.height/2;
  await player.load(pigData);

  StreetRenderer.camera.x = player.x;
  StreetRenderer.camera.y = player.y - 30;

  groddle.entityLayer.addChild(player);
  player.onMouseClick.listen((_) {
    //player.set('flip');
  });

  html.document.onKeyPress.listen((event) {
    //player.set('walk');
	  if(event.keyCode == 97) {
      player.flipped = true;
			player.x -= 10;
    }
		if(event.keyCode == 100) {
      player.flipped = false;
			player.x += 10;
    }
		if(event.keyCode == 119)
		  player.y -= 10;
		if(event.keyCode == 115)
			player.y += 10;

    StreetRenderer.camera.x = player.x;
    StreetRenderer.camera.y = player.y - 30;
	});
  html.document.onKeyUp.listen((_) {
    //player.set('default');
  });
}
