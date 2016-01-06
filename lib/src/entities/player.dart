part of libstreet;

class Player extends PhysicsEntity {
  static Player current;
  String name;
  Animation animation;

  load() async {
    animation = new Animation();
    await animation.load(animationBatch);
    addChild(animation);
  }
  Player(this.name);
}


// example of an animation 'batch'
Map animationBatch =  {
  'batch': [
    {
      'image': 'packages/libstreet/src/player/base.png',
      'height': 1,
      'width': 15,
      'animations': {
        'walk': {
          'frames': [
            [0,11]
          ],
          'loop': true
        },
        'default': {
          'frames': [14]
        },
        'flip': {
          'frames': [12],
          'loop': true
        }
      }
    },
    {
      'image': 'packages/libstreet/src/player/climb.png',
      'height': 1,
      'width': 19,
      'animations': {
        'climb up': {
          'frames': [
            [0, 18]
          ],
          'loop': true
        },
        'climb down': {
          'frames': [
            [18, 0]
          ],
          'loop': true
        }
      }
    },
    {
      'image': 'packages/libstreet/src/player/idle.png',
      'height': 2,
      'width': 29,
      'animations': {
        'idle': {
          'frames': [
            [0,57]
          ],
          'loop': true
        }
      }
    },
    {
      'image': 'packages/libstreet/src/player/jump.png',
      'height': 1,
      'width': 33,
      'animations': {
        'jump': {
          'frames': [
            [0,5]
          ]
        },
        'float up': {
          'frames': [
            [6,11]
          ]
        },
        'float down': {
          'frames': [
            [12,23]
          ]
        },
        'land': {
          'frames': [
            [24,32]
          ]
        }
      }
    }
  ]
};



// example of a single animation group
Map playerBaseAnim = {
  'image': 'packages/libstreet/src/player/base.png',
  'height': 1,
  'width': 15,
  'animations': {
    'walk': {
      'frames': [
        [0,11]
      ],
      'loop': true
    },
    'default': {
      'frames': [14]
    },
    'flip': {
      'frames': [12],
      'loop': true
    }
  }
};
