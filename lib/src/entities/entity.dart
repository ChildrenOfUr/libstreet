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

  @override
  advanceTime(num time) {
    if (glowing && !filters.contains(_glow)) {
      filters.add(_glow);
      filters.add(_glow);
      filters.add(_glow);
      filters.add(_glow);
    }
    if (!glowing && filters.contains(_glow)) {
      filters.clear();
    }
    _onUpdate.add(time);

    //keep in bounds.
    if (x < StreetRenderer.current.bounds.left + bounds.width/4) {
      x = StreetRenderer.current.bounds.left + bounds.width/4;
    }
    if (x > StreetRenderer.current.bounds.right - bounds.width/4) {
      x = StreetRenderer.current.bounds.right - bounds.width/4;
    }
  }

  Future load();
}
