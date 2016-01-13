part of libstreet;

class Street extends DisplayObjectContainer {
  Map streetData;

  @override
  Rectangle get bounds => new Rectangle(
      streetData['dynamic']['l'],
      streetData['dynamic']['t'],
      (streetData['dynamic']['l'].abs() + streetData['dynamic']['r'].abs())
          .toInt(),
      (streetData['dynamic']['t'].abs() + streetData['dynamic']['b'].abs())
          .toInt());
  String get tsid => streetData['tsid'].replaceRange(0, 1, 'L');
  num get groundY => -(streetData['dynamic']['ground_y'] as num).abs();

  // Entity Management
  EntityLayer playerLayer;
  EntityLayer quoinLayer;
  EntityLayer npcLayer;

  CollisionLayer collisionLayer;

  // Constructor
  Street(this.streetData) {
    StreetRenderer.current = this;
    // adds layers
    addChild(new GradientLayer(streetData));

    List layerMaps = new List.from(streetData['dynamic']['layers'].values);
    layerMaps.sort((Map A, Map B) => A['z'].compareTo(B['z']));
    for (Map layer in layerMaps) {
      String layerName = layer['name'].replaceAll(' ', '_');
      addChild(new ImageLayer(tsid, layerName, streetData));
      if (layerName == 'middleground') {
        quoinLayer = new EntityLayer(streetData);
        addChild(quoinLayer);
        npcLayer = new EntityLayer(streetData);
        addChild(npcLayer);
        playerLayer = new EntityLayer(streetData);
        addChild(playerLayer);
      }
    }
    for (Map layer in layerMaps) {
      for (Map signpost in layer['signposts']) {
        print(signpost);
        Signpost sp = new Signpost(signpost)
          ..x = signpost['x']
          ..y = signpost['y'];
        sp.load();
        npcLayer.addChild(sp);
      }
    }
    collisionLayer = new CollisionLayer(streetData);
    collisionLayer.visible = false;
    addChild(collisionLayer);
  }


  static Entity queryEntity(String id) {
    



  }


  spawnNPC(int x, int y, NPC npc) async {
    await npc.load();
    npc.x = x + bounds.left;
    npc.y = y + bounds.top;
    StreetRenderer.juggler.add(npc);
    npcLayer.addChild(npc);
  }

  spawnQuoin(int x, int y, String type, int value) async {
    Quoin quoin = new Quoin(type);
    await quoin.load();
    quoin.x = x + bounds.left;
    quoin.y = y + bounds.top;
    quoinLayer.addChild(quoin);
    StreetRenderer.juggler.add(quoin);
  }
}
