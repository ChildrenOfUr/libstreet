library libstreet;
import 'package:stagexl/stagexl.dart';
import 'dart:math' as Math;

part 'src/deco.dart';
part 'src/layer.dart';
part 'src/camera.dart';

ResourceManager RESOURCES;
Stage STAGE;

class Street extends DisplayObjectContainer {
  /// Map of the street's static properties
  Map def;

  Camera camera = new Camera();

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
    _gradient = _generateGradient();
  }

  // Makes sure that the decos are loaded, then adds the street to the stage
  activate() async {
    await loadDecos();
    this.addChild(_gradient);

    // Sort by z values
    List layerList = new List.from(def['dynamic']['layers'].values)
      ..sort((Map A, Map B) => A['z'].compareTo(B['z']));

    for (Map layerMap in layerList) {
      addLayer(layerMap);
    }
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
    if (RESOURCES.pendingResources.isNotEmpty)
      throw('Could not load Decos: ${RESOURCES.pendingResources}');
    _loaded = true;
  }

  /// Adds a layer defined by the layerDef to the STAGE
  StreetLayer addLayer(Map layerDef) {
    StreetLayer newLayer = new StreetLayer._(layerDef, street: this);
      //..applyFilters();
    addChild(newLayer);
    return newLayer;
  }

  /// Returns a DisplayObject containing the background gradient of the street.
  DisplayObject _generateGradient() {
    var shape = new Shape();
    shape.graphics.rect(0, 0, bounds.width, bounds.height);
    shape.graphics.fillGradient(
        new GraphicsGradient.linear(0, 0, 0, bounds.height)
          ..addColorStop(0, int.parse('0xFF' + def['gradient']['top']))
          ..addColorStop(1, int.parse('0xFF' + def['gradient']['bottom']))
    );
    shape.applyCache(0,0, bounds.width, bounds.height);
    return new Sprite()..addChild(shape);
  }

  // override render to offset gradient
  @override render(RenderState renderState) {
    _gradient.x = -camera.x;
    _gradient.y = -camera.y;

    super.render(renderState);
  }
  Sprite _gradient;

}