part of libstreet;

abstract class Entity extends Sprite implements Animatable {
  String id;
  List actions = [];

  static BitmapFilter glow = new GlowFilter()
    ..color = Color.Orange
    ..quality = 3
    ..blurX = 10
    ..blurY = 10;

  @override
  advanceTime(num time) {
    if (Player.current != null) {
      bool closeToPlayer = this != Player.current &&
          new Point(x, y)
                  .distanceTo(new Point(Player.current.x, Player.current.y)) <=
              200;

      if (closeToPlayer && !filters.contains(Entity.glow)) {
        filters.add(Entity.glow);
        filters.add(Entity.glow);
      }
      if (!closeToPlayer && filters.contains(Entity.glow)) {
        filters.clear();
      }
    }
  }

  Future load();
}
