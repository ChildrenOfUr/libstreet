library libstreet;
import 'package:stagexl/stagexl.dart';
import 'dart:math' as Math;
import 'dart:html' as html;
part 'src/deco.dart';
part 'src/layer.dart';
part 'src/camera.dart';
part 'src/shapes.dart';

ResourceManager RESOURCES;
Stage _STAGE;


StreetRenderer _renderer = new StreetRenderer._();
class StreetRenderer {
  factory StreetRenderer() => _renderer;

  StreetRenderer._() {
    StageXL.stageOptions
      ..transparent = true
      ..backgroundColor = 0x00000000;

    // Setting up the stageXL environment
    RESOURCES = new ResourceManager();
    _STAGE = new Stage(html.querySelector('canvas'));
    new RenderLoop()
      ..addStage(_STAGE);
  }

  render(Street street) async {
    // Render the Street
    _STAGE.addChild(street);
    await street.activate();
  }
}



class Street extends DisplayObjectContainer {
  /// Map of the street's static properties
  Map def;
  html.Element gradient = html.querySelector('#world-gradient');

  Camera camera = new Camera();
  DisplayObjectContainer actorLayer;
  DisplayObjectContainer collisionLayer;

  String get label => def['label'];
  String get tsid => def['tsid'];

  @override
  Rectangle get bounds => new Rectangle(
      def['dynamic']['l'],
      def['dynamic']['t'],
      (def['dynamic']['l'].abs() + def['dynamic']['r'].abs()).toInt(),
      (def['dynamic']['t'].abs() + def['dynamic']['b'].abs()).toInt()
  );

  /// returns true if the decos are loaded into memory
  bool get loaded => _loaded;
  bool _loaded = false;

  Street(final this.def) {
    camera.street = this;
    _generateGradient();
  }

  destroy() {
    // Remove the cache's from the DecoLayers
    List decoLayers = children.where((child) => child is DecoLayer).toList();
    for (DecoLayer decoLayer in new List.from(decoLayers)) {
      for (Deco deco in new List.from(decoLayer.children)) {
        deco.dispose();
      }
      decoLayer.removeCache();
      decoLayer.children.forEach((Sprite sublayer) => sublayer.removeChildren());
    }
  }



  // Makes sure that the decos are loaded, then adds the street to the stage
  activate() async {
    await loadDecos();

    // Sort by z values
    List layerList = new List.from(def['dynamic']['layers'].values)
      ..sort((Map A, Map B) => A['z'].compareTo(B['z']));

    for (Map layerMap in layerList) {
      addDecoLayer(layerMap);
      print(layerMap);
      // After appending 'middleground' insert the actor layer.
      if (layerMap['name'] == 'middleground') {
        actorLayer = new ActorLayer();
        addChild(actorLayer);
      }
    }
    // After all deco,and actor layers, add the collision layer.
    collisionLayer = new CollisionLayer(this);
    addChild(collisionLayer);
  }

  /// Loads all the decos on this [Street] into memory
  loadDecos() async {
    var loadOptions = new BitmapDataLoadOptions()..corsEnabled = true;
    // Collect the url of each deco to load.
    for (Map layer in def['dynamic']['layers'].values) {
      for (Map deco in layer['decos']) {
        // Only download if not cached already.
        if (!RESOURCES.containsBitmapData(deco['filename'])) RESOURCES
        .addBitmapData(deco['filename'],
        'http://childrenofur.com/locodarto/scenery/' +
        deco['filename'] +
        '.png', loadOptions);
      }
    }
    await RESOURCES.load();
    _loaded = true;
  }

  /// Adds a layer defined by the layerDef to the STAGE
  DecoLayer addDecoLayer(Map layerDef) {
    DecoLayer newLayer = new DecoLayer(layerDef, street: this);
    addChild(newLayer);
    return newLayer;
  }

  /// TODO make this its own class
   _generateGradient() {
    gradient
      ..style.width = '${bounds.width}px'
      ..style.height = '${bounds.height}px';

    String top = def['gradient']['top'];
    String bottom = def['gradient']['bottom'];

    gradient.style.background = "-webkit-linear-gradient(top, #$top, #$bottom)";
    gradient.style.background = "-moz-linear-gradient(top, #$top, #$bottom)";
    gradient.style.background = "-ms-linear-gradient(#$top, #$bottom)";
    gradient.style.background = "-o-linear-gradient(#$top, #$bottom)";
  }

  // override render to offset gradient
  @override render(RenderState renderState) {
    // Position the individual layers
    for (Layer layer in children.where((child) => child is Layer)) {
      layer.updatePosition();
    }

    gradient.style.transform = 'translate(${-camera.x}px,${-camera.y}px)';

    super.render(renderState);
  }
}