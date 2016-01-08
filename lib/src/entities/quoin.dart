part of libstreet;

class Quoin extends Entity {

  int value = 1;

  load() async {
    animation = new Animation();
    await animation.load(animationDef);
    addChild(animation);
  }

  Map animationDef = {
    'image': 'packages/libstreet/images/quoins/quoins.png',
    'height': 8,
    'width': 24,
    'animations': {
      'img': {
        'frames': [
          [0, 23]
        ],
        'loop': true
      },
      'mood': {
        'frames': [
          [24, 47]
        ],
        'loop': true
      },
      'energy': {
        'frames': [
          [48, 71]
        ],
        'loop': true
      },
      'currant': {
        'frames': [
          [72, 95]
        ],
        'loop': true
      },
      'mystery': {
        'frames': [
          [96, 119]
        ],
        'loop': true
      },
      'favor': {
        'frames': [
          [120, 143]
        ],
        'loop': true
      },
      'time': {
        'frames': [
          [144, 167]
        ],
        'loop': true
      },
      'quarazy': {
        'frames': [
          [168, 191]
        ],
        'loop': true
      },

      // reuse mystery for default.
      'default': {
        'frames': [
          [96, 119]
        ],
        'loop': true
      }
    }
  };
}
