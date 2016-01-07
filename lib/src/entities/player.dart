part of libstreet;

class Player extends PhysicsEntity {
  static Player current;
  String name;
  Player(this.name);

  load() async {
    animation = new Animation();
    await animation.load(animationBatch);
    addChild(animation);

    onUpdate.listen((_) async {
      // flipping;
      if (velocity.x < 0) {
        animation.flipped = true;
      } else if (velocity.x > 0) {
        animation.flipped = false;
      }

      // ground animations
      if (isOnGround) {
        if (velocity.x.abs() > 0.5) {
          animation.set('walk');
        } else {
          animation.set('default');
        }
      } else if (activeClimb) {
        if (velocity.y > 0) {
          animation.set('climb up');
        } else {
          animation.set('climb down');
        }
        if (velocity.y == 0) {
          animation.speed = 0;
        } else {
          animation.speed = 1;
        }
      } else {
        if (velocity.y >= 2) {
          if (animation.current != 'float down') animation.set('float down');
        } else if (velocity.y <= -2) {
          if (animation.current != 'float up') animation.set('float up');
        }
      }

      if (Keyboard.pressed(68)) {
        impulse(2.5, 0);
      }
      if (Keyboard.pressed(65)) {
        impulse(-2.5, 0);
      }
      if (Keyboard.pressed(32) && isOnGround) {
        impulse(0, -20);
      }
      if (Keyboard.pressed(87) && isTouchingLadder) {
        activeClimb = true;
        impulse(0, -2.5);
      } else if (Keyboard.pressed(83) && isTouchingLadder) {
        activeClimb = true;
        impulse(0, 2.5);
      } else if (!isTouchingLadder) {
        activeClimb = false;
      }
    });
  }
}

// example of an animation 'batch'
Map animationBatch = {
  'batch': [
    {
      'image': 'packages/libstreet/images/player/base.png',
      'height': 1,
      'width': 15,
      'animations': {
        'walk': {
          'frames': [
            [0, 11]
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
      'image': 'packages/libstreet/images/player/climb.png',
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
      'image': 'packages/libstreet/images/player/idle.png',
      'height': 2,
      'width': 29,
      'animations': {
        'idle': {
          'frames': [
            [0, 57]
          ],
          'loop': true
        }
      }
    },
    {
      'image': 'packages/libstreet/images/player/jump.png',
      'height': 1,
      'width': 33,
      'animations': {
        'float up': {
          'frames': [
            [1, 11]
          ],
          'bounce': true
        },
        'float down': {
          'frames': [
            [12, 32]
          ],
          'bounce': true
        }
      }
    }
  ]
};

// example of a single animation group
Map playerBaseAnim = {
  'image': 'packages/libstreet/images/player/base.png',
  'height': 1,
  'width': 15,
  'animations': {
    'walk': {
      'frames': [
        [0, 11]
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
