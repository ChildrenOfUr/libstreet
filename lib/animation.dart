library animation;
import 'package:stagexl/stagexl.dart';
import 'dart:html' as html;

class Animation extends Sprite {
  static ResourceManager _resources = new ResourceManager();
  static Juggler _juggler = new Juggler();

  static setJuggler(Juggler juggler) {
    _juggler = juggler;
  }


  Animation();

  num speed = 1;
  Map<String, FlipBook> state = {};
  String current;

  set flipped(bool flipped) {
    if (flipped) this.scaleX = -1;
    else this.scaleX = 1;
  }

  set(String name) {
    if (!state.containsKey(name)) {
      throw ('unloaded Animation $name!');
    }
    if (current == name) return;
    children.clear();
    children.add(state[name]);

    for (int i = state[name].frameDurations.length - 1; i >= 0; i--) {
      state[name].frameDurations[i] = 0.033 / speed;
    }

    state[name].gotoAndPlay(0);
    current = name;
  }

  /// Populates the [Animation] with the included states.
  load(var data) async {
    if (data is! List && data is! Map) {
      throw('Animation data must be a List or a Map!');
    }

    // if the data is a batch of animations, load each individually.
    if (data is List) {
      for (Map subdata in data) {
        await load(subdata);
      }
      return;
    } else if (data is Map) {
      BitmapData bitmapData;

      if (data['image'] is String) {
        if (!_resources.containsBitmapData(data['image'])) {
          _resources
              .addBitmapData(data['image'], data['image']);
        }
        await _resources.load();
        bitmapData =
            _resources.getBitmapData(data['image']);
      } else if (data['image'] is html.ImageElement) {
        await (data['image'] as html.ImageElement).onLoad.first;
        bitmapData = new BitmapData.fromImageElement(data['image']);
      }

      SpriteSheet sheet = new SpriteSheet(
          bitmapData,
          bitmapData.width ~/ data['width'],
          bitmapData.height ~/ data['height']);

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
              for (i;
                  i > 0;
                  i--) animationFrames.add(sheet.frames[frame[1] - i]);
            }
          }
        }
        if (animationData['bounce'] == true) {
          animationFrames.addAll(animationFrames.toList().reversed);
        }

        state[name] = new FlipBook(animationFrames);
        state[name]
          ..loop = animationData['loop'] ?? false
          ..setTransform(-state[name].width ~/ 2, -state[name].height);
        _juggler.add(state[name]);
      });

      if (data['animations'].keys.contains('default') && current == null) {
        set('default');
      }
      if (current != null) {
        set(current);
      }
    }
  }
}
