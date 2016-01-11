part of libstreet;

abstract class Entity extends Sprite implements Animatable {
  String id;
  Animation animation = new Animation();
  StreamController<int> _onUpdate = new StreamController();
  Stream<int> get onUpdate => _onUpdate.stream;

  bool glowing = false;
  static BitmapFilter _glow = new GlowFilter()
    ..color = Color.Orange
    ..quality = 3
    ..blurX = 2
    ..blurY = 2;

  bool hasBubble = false;
  spawnBubble(String text, [username, int color, bool autoDismiss, Map gains]) async {
    if (hasBubble == true) {
      return;
    }
    hasBubble = true;

    num timeToLive =
        (text.length * 0.05) + 2; //minimum 3s plus 0.05 per character
    if (timeToLive > 10) {
      //max 10s
      timeToLive = 10; //messages over 10s will only display for 10s
    }
    ChatBubble cb = new ChatBubble(text, username, color, gains);
    addChild(cb);
    cb.y = -height + bounds.bottom;
    await cb.open();
    if (autoDismiss != false) {
      await new Future.delayed(new Duration(milliseconds: timeToLive * 1000));
      await cb.close();
      removeChild(cb);
      hasBubble = false;
    } else {
      await cb.onMouseClick.first;
      await cb.close();
      removeChild(cb);
      hasBubble = false;
    }
  }

  @override
  advanceTime(num time) {
    if (glowing && !animation.filters.contains(_glow)) {
      animation.filters.add(_glow);
      animation.filters.add(_glow);
      animation.filters.add(_glow);
      animation.filters.add(_glow);
    }
    if (!glowing && animation.filters.contains(_glow)) {
      animation.filters.clear();
    }
    _onUpdate.add(time);

    //keep in bounds.
    if (x < StreetRenderer.current.bounds.left + bounds.width / 4) {
      x = StreetRenderer.current.bounds.left + bounds.width / 4;
    }
    if (x > StreetRenderer.current.bounds.right - bounds.width / 4) {
      x = StreetRenderer.current.bounds.right - bounds.width / 4;
    }
  }

  Future load();
}
