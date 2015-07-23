import 'package:libstreet/libstreet.dart';
import 'package:stagexl/stagexl.dart';
import 'dart:convert';

ResourceManager RESOURCES = new ResourceManager();

main() async {
  RESOURCES.addTextFile('groddle', 'groddle.json');
  await RESOURCES.load();
  Map groddleDef = JSON.decode(RESOURCES.getTextFile('groddle'));
	Street groddle = new Street(groddleDef);
	StreetRenderer renderer = new StreetRenderer();
	renderer.render(groddle);
}