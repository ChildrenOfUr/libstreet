part of libstreet;

abstract class Entity extends Sprite implements Animatable {
  String id;
  Animation animation;
  StreamController<int> _onUpdate = new StreamController();
  Stream<int> get onUpdate => _onUpdate.stream;

  bool glowing = false;
  static BitmapFilter _glow = new GlowFilter()
    ..color = Color.Orange
    ..quality = 3
    ..blurX = 10
    ..blurY = 10;

  @override
  advanceTime(num time) {
    if (glowing && !filters.contains(_glow)) {
      filters.add(_glow);
      filters.add(_glow);
    }
    if (!glowing && filters.contains(_glow)) {
      filters.clear();
    }
    _onUpdate.add(time);
  }

  Future load();
}
