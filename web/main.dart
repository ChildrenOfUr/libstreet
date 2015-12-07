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

  Player player = new Player('yolo');
  await groddle.addEntity(player, groddle.bounds.width/2, groddle.bounds.height/2);
  Player.current = player;


  StreetRenderer.stage.onMouseClick.listen((data) async {
    Player p = new Player('x');
    p.actions.add('pet');
    await groddle.addEntity(p, data.stageX + StreetRenderer.camera.x - StreetRenderer.camera.viewport.width/2, data.stageY + StreetRenderer.camera.y - StreetRenderer.camera.viewport.height/2);
    p.animation.flipped = true;
    p.animation.set('idle');
  });


  StreetRenderer.camera.x = player.x;
  StreetRenderer.camera.y = player.y - 30;

  html.document.onKeyPress.listen((event) {
	  if(event.keyCode == 97) {
      player.animation.set('walk');
      player.animation.flipped = true;
			player.x -= 10;
    }
		if(event.keyCode == 100) {
      player.animation.set('walk');
      player.animation.flipped = false;
			player.x += 10;
    }
		if(event.keyCode == 119) {
      player.animation.set('climb up');
		  player.y -= 10;
    }
		if(event.keyCode == 115) {
      player.animation.set('climb down');
			player.y += 10;
    }

    StreetRenderer.camera.x = player.x;
    StreetRenderer.camera.y = player.y - 30;
	});
}
