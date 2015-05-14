import 'package:libstreet/libstreet.dart';
import 'package:stagexl/stagexl.dart';
import 'package:stagexl_particle/stagexl_particle.dart';
import 'dart:html';
import 'dart:convert';




main() async {
  StageXL.stageOptions.renderEngine = RenderEngine.Canvas2D;

  // Setting up the stageXL environment
  RESOURCES = new ResourceManager();
  STAGE = new Stage(querySelector('canvas'));
  new RenderLoop()
    ..addStage(STAGE);

  print('${STAGE.stageWidth} ${STAGE.stageHeight}');


  // load the JSON
  RESOURCES.addTextFile('groddle', 'groddle.json');
  await RESOURCES.load();

  // We turn the JSON into a map before we generate a street from it.
  // This allows us to dynamically create Maps and render Streets
  // from them without a JSON conversion process.
  Map groddleDef = JSON.decode(RESOURCES.getTextFile('groddle'));

  // Render the Street
  Street groddle = new Street(groddleDef);
  STAGE.addChild(groddle);

  await groddle.load();


  groddle.onMouseClick.listen((e) {
    print('${e.stageX} ${e.stageY}');
  });

  groddle.onMouseMove.listen((e) {
    camera.setCameraPosition(e.stageX, e.stageY);
    groddle.update();
  });


  var particleConfig = {
    "maxParticles":2000,
    "duration":0,
    "lifeSpan":0.7, "lifespanVariance":0.2,
    "startSize":16, "startSizeVariance":10,
    "finishSize":53, "finishSizeVariance":11,
    "shape":"circle",
    "emitterType":0,
    "location":{"x":0, "y":0},
    "locationVariance":{"x":5, "y":5},
    "speed":100, "speedVariance":33,
    "angle":0, "angleVariance":360,
    "gravity":{"x":0, "y":0},
    "radialAcceleration":20, "radialAccelerationVariance":0,
    "tangentialAcceleration":10, "tangentialAccelerationVariance":0,
    "minRadius":0, "maxRadius":100, "maxRadiusVariance":0,
    "rotatePerSecond":0, "rotatePerSecondVariance":0,
    "compositeOperation":"source-over",
    "startColor":{"red":1, "green":0.74, "blue":0, "alpha":1},
    "finishColor":{"red":1, "green":0, "blue":0, "alpha":0}
  };

  var particleEmitter = new ParticleEmitter(particleConfig);
  particleEmitter.setEmitterLocation(400, 300);
  STAGE.addChild(particleEmitter);
  STAGE.juggler.add(particleEmitter);

  var mouseEventListener = (me) {
    if (me.buttonDown) particleEmitter.setEmitterLocation(me.localX, me.localY);
  };
}



