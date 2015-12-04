part of libstreet;

Map playerData = {
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
    }
  }
};

class Animation extends Sprite {
  Map<String, FlipBook> state = {};
  String current;

  set(String name) {
    if (current == name) return;
    children.clear();
    children.add(state[name]);
    StreetRenderer.stage.juggler.add(state[name]);
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
      print('a');
      List animationFrames = [];
      for (int frame in animationData['frames']) {
        print('b');
        animationFrames.add(sheet.frames[frame]);
      }
      print('c');
      state[name] = new FlipBook(animationFrames);

      state[name]
        ..loop = animationData['loop'] ?? false
        ..setTransform(
            -state[name].width ~/ 2, -state[name].height)
        ..onComplete.listen((_) {
          if (!animationData['loop'] && animationData[name] != 'default') {
            set('default');
          }
        });
    });

    if (data['animations'].keys.contains('default')) {
      set('default');
    }
  }
}
