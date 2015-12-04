part of libstreet;

Map examplePlayer = {
  'image': 'packages/libstreet/src/base.png',
  'height': 1,
  'width': 15,
  'animations': {
    'walk': {
      'frames': [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11],
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

Map pigData = {
  'image': 'packages/libstreet/src/pig.png',
  'height': 5,
  'width': 10,
  'animations': {
    'default': {
      'frames': [
        0,
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20,
        21,
        22,
        23,
        24,
        25,
        26,
        27,
        28,
        29,
        30,
        31,
        32,
        33,
        34,
        35,
        36,
        37,
        38,
        39,
        40,
        41,
        42,
        43,
        44,
        45,
        46,
        47
      ],
      'loop': true,
      'bounce': true
    }
  }
};

class Animation extends Sprite {
  Map<String, FlipBook> state = {};
  String current;

  set flipped(bool flipped) {
    if (flipped) this.scaleX = -1;
    else this.scaleX = 1;
  }

  set(String name) {
    if (current == name) return;
    children.clear();
    children.add(state[name]);
    state[name].gotoAndPlay(0);
    current = name;
  }

  /// Populates the [Animation] with the included states.
  load(Map data) async {
    // TODO lets do the loading properly as soon as we can.
    html.ImageElement image = new html.ImageElement(src: data['image']);
    await image.onLoad.first;
    BitmapData bitmapData = new BitmapData.fromImageElement(image);
    SpriteSheet sheet = new SpriteSheet(bitmapData,
        bitmapData.width ~/ data['width'], bitmapData.height ~/ data['height']);

    data['animations'].forEach((String name, Map animationData) {
      List animationFrames = [];
      for (int frame in animationData['frames']) {
        animationFrames.add(sheet.frames[frame]);
      }
      if (animationData['bounce'] == true) {
        animationFrames.addAll(animationFrames.toList().reversed);
      }

      state[name] = new FlipBook(animationFrames);
      state[name]
        ..loop = animationData['loop'] ?? false
        ..setTransform(-state[name].width ~/ 2, -state[name].height)
        ..onComplete.listen((_) {
          if (!animationData['loop'] && animationData[name] != 'default') {
            set('default');
          }
        });
      StreetRenderer.stage.juggler.add(state[name]);
    });

    if (data['animations'].keys.contains('default')) {
      set('default');
    }
  }
}
