part of libstreet;


class Player extends Entity {
  static Player current;
  String name;
  Animation animation;

  load() async {
    animation = new Animation();
    await animation.load(playerBaseAnim);
    await animation.load(playerClimbAnim);
    await animation.load(playerIdleAnim);
    await animation.load(playerJumpAnim);

    _xlObject = animation;
  }

  Player(this.name);
}



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

Map playerClimbAnim = {
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
};

Map playerIdleAnim = {
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
};

Map playerJumpAnim = {
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
};
