import 'package:stagexl/stagexl.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:html' as html;
import 'package:libstreet/libstreet.dart';

ResourceManager resourceManager = new ResourceManager();

main() async {
  StreetRenderer.init();

  html.querySelector('#snap').onClick.listen((_) async {
    String dataUrl = StreetRenderer.snap();
    html.document.body.append(new html.ImageElement(src: dataUrl));
  });

    resourceManager.addTextFile('mira.json', 'mira.json');
    await resourceManager.load();
    Map def = JSON.decode(resourceManager.getTextFile('mira.json'));
    await StreetRenderer.preload(def);
    Street street = new Street(def);
    StreetRenderer.stage.children.clear();
    StreetRenderer.juggler.clear();
    StreetRenderer.stage.addChild(street);


    resourceManager.addTextFile('ents', 'ents.json');
    await resourceManager.load();
    Map ents = JSON.decode(resourceManager.getTextFile('ents'));
    List entities = ents['entities'];
    List quoinTypes = ['Img', 'Mood', 'Quarazy', 'Energy', 'Currant', 'Mystery', 'Favor', 'Time'];

    for (Map entdef in entities) {
      if (quoinTypes.contains(entdef['type'])) {
        await street.spawnQuoin(entdef['x'], entdef['y'], entdef['type'], 0);
      } else if (entdef['type'] == 'Piggy') {
        Piggy piggy = new Piggy();
        await street.spawnNPC(entdef['x'], entdef['y'], piggy);
      }
    }

    Player paal = new Player('paal');
    Player.current = paal;
    await paal.load();
    paal.y = street.bounds.top + 200;
    paal.x = street.bounds.left + 200;
    StreetRenderer.juggler.add(paal);
    street.playerLayer.addChild(paal);

    new Timer.periodic(new Duration(milliseconds: 15), (_) {
      StreetRenderer.camera.x = paal.x - street.bounds.left;
      StreetRenderer.camera.y = paal.y - 100 - street.bounds.top;
    });
}
