import 'package:stagexl/stagexl.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:html' as html;
import 'package:libstreet/libstreet.dart';

ResourceManager resourceManager = new ResourceManager();

main() async {
  StreetRenderer.init();

  Timer periodic;

  html.querySelector('#snap').onClick.listen((_) async {
    String dataUrl = StreetRenderer.snap();
    html.document.body.append(new html.ImageElement(src: dataUrl));
  });

  html.querySelector('#load').onClick.listen((_) async {
    String file = (html.querySelector('#input') as html.InputElement).value;

    if (periodic != null) {
      periodic.cancel();
    }

    if (!resourceManager.containsTextFile(file)) {
      resourceManager.addTextFile(file, '$file.json');
      await resourceManager.load();
    }
    Map def = JSON.decode(resourceManager.getTextFile(file));

    await StreetRenderer.preload(def);
    Street street = new Street(def);
    StreetRenderer.stage.children.clear();
    StreetRenderer.juggler.clear();
    StreetRenderer.stage.addChild(street);

    Player paal = new Player('paal');
    await paal.load();
    paal.y = street.bounds.top + 200;
    paal.x = street.bounds.left + 200;
    paal.animation.set('idle');
    StreetRenderer.juggler.add(paal);
    street.entityLayer.addChild(paal);

    periodic = new Timer.periodic(new Duration(milliseconds: 15), (_) {
      StreetRenderer.camera.x = paal.x - street.bounds.left;
      StreetRenderer.camera.y = paal.y - 100 - street.bounds.top;
    });
  });
}
