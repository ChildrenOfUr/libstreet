library libstreet;
import 'package:stagexl/stagexl.dart';
import 'dart:math' as Math;

part 'src/deco.dart';
part 'src/layer.dart';
part 'src/camera.dart';


ResourceManager RESOURCES;
Stage STAGE;

/// This is the container that holds all of a Street's elements
/// when a [Street] is created or activated, this container is emptied and repopulated.

class Street extends DisplayObjectContainer {
  /// Map of the street's static properties
  Map _streetDef;

  Camera camera = new Camera();
  Sprite _gradient;

  Street(final this._streetDef) {
    camera.street = this;
    _gradient = _generateGradient();
  }

  /// returns true if the decos are loaded into memory
  bool get loaded => _loaded;
  bool _loaded = false;

  String get label => _streetDef['label'];
  String get tsid => _streetDef['tsid'];

  @override
  Rectangle get bounds => new Rectangle(
      _streetDef['dynamic']['l'],
      _streetDef['dynamic']['t'],
      (_streetDef['dynamic']['l'].abs() + _streetDef['dynamic']['r'].abs()).toInt(),
      (_streetDef['dynamic']['t'].abs() + _streetDef['dynamic']['b'].abs()).toInt()
  );

  activate() async {

    await _loadDecos();
    this.addChild(_gradient);

    // Sort by z values
    List layerList = new List.from(_streetDef['dynamic']['layers'].values)
      ..sort((Map A, Map B) => A['z'].compareTo(B['z']));


    for (Map layer in layerList) {
      this.addChild(_layer(layer));
    }
  }


  /// Loads all decos into memory
  _loadDecos() async {
    var loadOptions = new BitmapDataLoadOptions()..corsEnabled = true;

    // Collect the url of each deco to load.
    for (Map layer in _streetDef['dynamic']['layers'].values) {
      for (Map deco in layer['decos']) {
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


  List <Sprite> layers =[];

  /// Assembles a layer and returns the Sprite
  Sprite _layer(Map layerDef) {
    StreetLayer newLayer = new StreetLayer(layerDef)
      ..street = this;

    layers.add(newLayer);
    // Sort by z values
    List decoList = new List.from(layerDef['decos'])
      ..sort((Map A, Map B) => A['z'].compareTo(B['z']));

    for (Map decoMap in decoList) {
      if (loaded == false)
        throw("Decos not loaded!");

      Deco deco = new Deco(decoMap);
      if(layerDef['name'] == 'middleground')
      {
        //middleground has different layout needs
        deco.y += layerDef['h'];
        deco.x += layerDef['w'] ~/ 2;
      }

      // Add to the layer
      newLayer.addDeco(deco);
    }

    newLayer.harden();
    return newLayer;
  }

  /// Returns a DisplayObject containing the background gradient of the street.
  DisplayObject _generateGradient() {
    var shape = new Shape();
    shape.graphics.rect(0, 0, bounds.width, bounds.height);
    shape.graphics.fillGradient(
        new GraphicsGradient.linear(0, 0, 0, bounds.height)
          ..addColorStop(0, int.parse('0xFF' + _streetDef['gradient']['top']))
          ..addColorStop(1, int.parse('0xFF' + _streetDef['gradient']['bottom']))
    );
    shape.applyCache(0,0, bounds.width, bounds.height);
    return new Sprite()..addChild(shape);
  }

  // override render to support parallax
  @override render(RenderState renderState) {
    _gradient.x = -camera.x;
    _gradient.y = -camera.y;
    super.render(renderState);
  }


}