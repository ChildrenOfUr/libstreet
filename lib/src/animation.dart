part of libstreet;

class Animation extends Sprite {
  num speed = 1;
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

    for (int i = state[name].frameDurations.length - 1; i >= 0; i--) {
      state[name].frameDurations[i] = 0.033 / speed;
    }
    ;
    state[name].gotoAndPlay(0);
    current = name;
  }

  /// Populates the [Animation] with the included states.
  load(Map data) async {
    // if the data is a batch of animations, load each individually.
    if (data.keys.contains('batch')) {
      for (Map subdata in data['batch']) {
        await load(subdata);
      }
      return;
    }

    if (!StreetRenderer.resourceManager.containsBitmapData(data['image'])) {
      StreetRenderer.resourceManager
          .addBitmapData(data['image'], data['image']);
      await StreetRenderer.resourceManager.load();
    }

    BitmapData bitmapData = StreetRenderer.resourceManager.getBitmapData(data['image']);
    SpriteSheet sheet = new SpriteSheet(bitmapData,
        bitmapData.width ~/ data['width'], bitmapData.height ~/ data['height']);

    data['animations'].forEach((String name, Map animationData) {
      List animationFrames = [];
      for (var frame in animationData['frames']) {
        if (frame is int) {
          animationFrames.add(sheet.frames[frame]);
        } else if (frame is List<int>) {
          int i = frame[1] - frame[0];
          if (i.isNegative) {
            for (int j = i.abs(); j > 0; j--) {
              animationFrames.add(sheet.frames[frame[1] + j]);
            }
          } else {
            for (i; i > 0; i--) animationFrames.add(sheet.frames[frame[1] - i]);
          }
        }
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
