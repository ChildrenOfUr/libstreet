part of libstreet;

Math.Random R = new Math.Random();

class NPC extends PhysicsEntity {
  Map definition;
  CommandNode nodes;
  List<String> flags;
  NPC(this.definition) {
    Vector acceleration = new Vector.zero();

    int threads = 0;
    Map functions = {
      "print": print,
      "setAnimation": animation.set,
      "impulseX": (x) => acceleration.x = x,
      "impulseY": (y) => acceleration.y = y,
      "reset": (_) async {
        await nodes.activate(flags);
      },
      "randomize": (String flag) {
        if (R.nextBool()) {
          if (!flags.contains(flag))
            flags.add(flag);
        } else {
          if (flags.contains(flag))
            flags.remove(flag);
        }
      }


    };
    nodes = new CommandNode(definition['nodes'], 0, functions);
    flags = definition['flags'];

    onUpdate.listen((_) {
      impulse(acceleration.x, acceleration.y);
    });
  }
  load() async {
    await animation.load(definition['animation']);
    addChild(animation);
    print(nodes);
    nodes.activate(flags);
  }
}



Map PIGGYDEF = {
  "physics" : {
    "gravity": -5
  },

  "flags" : [
    "walking",
    "left"
  ],


  // perhaps replace this with a 'state' system.
  "nodes" : {
    "children": [
      {
        "if": {
          "walking": {
            "setAnimation": 'walk',
            "if": {
              "left": {
                "impulseX": -0.2
              }
            }, "else": {
              "impulseX": 0.2
            }
          }
        }, "else" : {
          "setAnimation": 'default'
        }
      },

      {
        "wait": 3000,
        "randomize": "left",
        "reset": ''
      }
    ]
  },

  "animation": [
    {
      'image': 'packages/libstreet/images/piggy/walk.png',
      'height': 3,
      'width': 8,
      'animations': {
        'walk': {
          'frames': [
            [0, 23]
          ],
          'loop': true
        }
      }
    },
    {
      'image': 'packages/libstreet/images/piggy/look.png',
      'height': 5,
      'width': 10,
      'animations': {
        'default': {
          'frames': [
            [0, 47]
          ],
          'bounce': true
        }
      }
    },
    {
      'image': 'packages/libstreet/images/piggy/nibble.png',
      'height': 6,
      'width': 10,
      'animations': {
        'nibble': {
          'frames': [
            [0, 59]
          ],
          'loop': false
        }
      }
    },
    {
      'image': 'packages/libstreet/images/piggy/toomuchnibble.png',
      'height': 6,
      'width': 11,
      'animations': {
        'tooMuchNibble': {
          'frames': [
            [0, 64]
          ],
          'loop': false
        }
      }
    }
  ]
};
