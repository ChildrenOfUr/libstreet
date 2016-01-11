part of libstreet;


abstract class NPC extends PhysicsEntity {}

class Piggy extends NPC {
  load() async {
    await animation.load(animationDef);
    addChild(animation);
    int state = 0;

    Math.Random R = new Math.Random();
    new Timer.periodic(new Duration(seconds: 1), (_) {
      state = R.nextInt(3);
    });

    onUpdate.listen((_) {
      // ground animations
      if (isOnGround) {
        if (velocity.x.abs() > 0.5) {
          animation.set('walk');
        } else {
          animation.set('default');
        }
      }

      // walk left or right
      if(state == 1) {
        impulse(0.2, 0);
      } else if(state == 2) {
        impulse(-0.2, 0);
      } else {
        spawnBubble('Yo, dog.', 'Piggy');
      }

    });
  }

  Map animationDef = {
    'batch': [
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
      // TODO add rooked anims
    ]
  };
}
