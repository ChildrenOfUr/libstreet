part of libstreet;

/// A Sprite, aware of its position on a street.
abstract class StreetSprite extends Sprite {
  Point get street {
    return StreetRenderer.localToStreet(localToGlobal(new Point(x, y)));
  }
}

class Street extends DisplayObjectContainer {
  Map streetData;

  @override
  Rectangle get bounds => new Rectangle(
      streetData['dynamic']['l'],
      streetData['dynamic']['t'],
      (streetData['dynamic']['l'].abs() + streetData['dynamic']['r'].abs()).toInt(),
      (streetData['dynamic']['t'].abs() + streetData['dynamic']['b'].abs()).toInt()
  );
  String get tsid => streetData['tsid'].replaceRange(0, 1, 'L');
  num get groundY => -(streetData['dynamic']['ground_y'] as num).abs();

  // Entity Management
  EntityLayer entityLayer;
  CollisionLayer collisionLayer;

  // Constructor
  Street(this.streetData) {
    StreetRenderer.current = this;

    // set the canvas gradient.
    String top = streetData['gradient']['top'];
    String bottom = streetData['gradient']['bottom'];
    StreetRenderer.setGradient(top, bottom);

    // adds layers
    List layerMaps = new List.from(streetData['dynamic']['layers'].values);
    layerMaps.sort( (Map A, Map B) => A['z'].compareTo(B['z']) );
    for (Map layer in layerMaps) {
      String layerName = layer['name'].replaceAll(' ', '_');
      addChild(new ImageLayer(tsid, layerName));
      if (layerName == 'middleground') {
        entityLayer = new EntityLayer(streetData);
        addChild(entityLayer);
      }
    }
    collisionLayer = new CollisionLayer(streetData);
    addChild(collisionLayer);
  }
}
