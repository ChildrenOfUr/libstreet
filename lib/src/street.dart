part of libstreet;


class Street {
  Map streetData;
  Rectangle _bounds;
  get bounds => _bounds;
  String tsid;
  num groundY;

  // Entity Management

  EntityLayer entityLayer;

  List<Entity> _entities = [];
  get entities => _entities.toList();

  addEntity(Entity entity) async {
    await entity.load();
    _entities.add(entity);
    entityLayer.addChild(entity._xlObject);
    print('added');
    if (entity._xlObject is Animatable)
      StreetRenderer.stage.juggler.add(entity._xlObject as Animatable);
  }

  removeEntity(Entity entity) {
    _entities.remove(entity);
    entityLayer.removeChild(entity._xlObject);
    if (entity._xlObject is Animatable)
      StreetRenderer.stage.juggler.remove(entity._xlObject as Animatable);
  }

  // Constructor
  Street(this.streetData) {
    StreetRenderer._clearLayers();
    StreetRenderer.current = this;

    // declare some useful properties.
    tsid = streetData['tsid'].replaceRange(0, 1, 'L');
    groundY = -(streetData['dynamic']['ground_y'] as num).abs();
    _bounds = new Rectangle(streetData['dynamic']['l'],
        streetData['dynamic']['t'],
        streetData['dynamic']['l'].abs() + streetData['dynamic']['r'].abs(),
        (streetData['dynamic']['t'] - streetData['dynamic']['b']).abs());

    // set the canvas gradient.
    String top = streetData['gradient']['top'];
    String bottom = streetData['gradient']['bottom'];
    StreetRenderer._setGradient(top, bottom);

    // adds layers
    List layerMaps = new List.from(streetData['dynamic']['layers'].values);
    layerMaps.sort( (Map A, Map B) => A['z'].compareTo(B['z']) );
    for (Map layer in layerMaps) {
      String layerName = layer['name'].replaceAll(' ', '_');
      StreetRenderer._addLayer(new ImageLayer(tsid, layerName));
      if (layerName == 'middleground') {
        entityLayer = new EntityLayer();
        StreetRenderer._addLayer(entityLayer);
      }
    }
  }
}
