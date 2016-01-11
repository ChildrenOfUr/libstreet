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

    for (Map entdef in entities) {
      if (entdef['type'] == 'Img') {
        street.spawnQuoin(entdef['x'], entdef['y'], 'img', 0);
      }
      if (entdef['type'] == 'Mood') {
        street.spawnQuoin(entdef['x'], entdef['y'], 'mood', 0);
      }
      if (entdef['type'] == 'Quarazy') {
        street.spawnQuoin(entdef['x'], entdef['y'], 'quarazy', 0);
      }
      if (entdef['type'] == 'Energy') {
        street.spawnQuoin(entdef['x'], entdef['y'], 'energy', 0);
      }
      if (entdef['type'] == 'Currant') {
        street.spawnQuoin(entdef['x'], entdef['y'], 'currant', 0);
      }
      if (entdef['type'] == 'Mystery') {
        street.spawnQuoin(entdef['x'], entdef['y'], 'mystery', 0);
      }
      if (entdef['type'] == 'Favor') {
        street.spawnQuoin(entdef['x'], entdef['y'], 'favor', 0);
      }
      if (entdef['type'] == 'Time') {
        street.spawnQuoin(entdef['x'], entdef['y'], 'time', 0);
      }
      if (entdef['type'] == 'Piggy') {
        Piggy piggy = new Piggy();
        street.spawnNPC(entdef['x'], entdef['y'], piggy);
      }
    }

    Player paal = new Player('paal');
    Player.current = paal;
    await paal.load();
    paal.y = street.bounds.top + 200;
    paal.x = street.bounds.left + 200;
    StreetRenderer.juggler.add(paal);
    street.playerLayer.addChild(paal);

    ChatBubble cb = new ChatBubble('Howdy! Pardner!, Howdy! Pardner!, Howdy! Pardner!, Howdy! Pardner!, Howdy! Pardner!, Howdy! Pardner!, Howdy! Pardner!, Howdy! Pardner!, Howdy! Pardner!, Howdy! Pardner!, ');
    paal.addChild(cb);
    cb.y = -paal.height;

    new Timer.periodic(new Duration(milliseconds: 15), (_) {
      StreetRenderer.camera.x = paal.x - street.bounds.left;
      StreetRenderer.camera.y = paal.y - 100 - street.bounds.top;
    });
}
