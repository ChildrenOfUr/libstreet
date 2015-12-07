part of libstreet;

abstract class Entity extends Animatable {
  String id;
  DisplayObject _xlObject;
  List actions = [];

  get x => _xlObject.x;
  get y => _xlObject.y;
  set x(num x) => _xlObject.x = x;
  set y(num y) => _xlObject.y = y;

  static BitmapFilter glow = new GlowFilter()
    ..color = Color.Orange
    ..quality = 3
    ..blurX = 10
    ..blurY = 10;

  @override
  advanceTime(num time) {
    if (Player.current != null) {
      bool closeToPlayer = this != Player.current &&
          new Point(_xlObject.x, _xlObject.y)
                  .distanceTo(new Point(Player.current.x, Player.current.y)) <=
              200;

      if (closeToPlayer && !_xlObject.filters.contains(Entity.glow)) {
        _xlObject.filters.add(Entity.glow);
        _xlObject.filters.add(Entity.glow);
      }
      if (!closeToPlayer && _xlObject.filters.contains(Entity.glow)) {
        _xlObject.filters.clear();
      }
    }
  }

  Future load();
}
