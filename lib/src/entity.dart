part of libstreet;


class Player extends Entity {
  static Player current;
  String username;

  @override
  load() async {
    html.ImageElement idleSheet = new html.ImageElement(src: 'packages/libstreet/src/base.png');
    await idleSheet.onLoad.first;

    BitmapData data = new BitmapData.fromImageElement(idleSheet);
    _xlObject = new FlipBook(new SpriteSheet(data,data.width~/15,data.height~/1).frames);
    (_xlObject as FlipBook)
      ..play();

    StreetRenderer.stage.juggler
      ..add(_xlObject as FlipBook);
  }

  Player(this.username);
}


abstract class Entity extends Animatable{
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
    if (actions.isNotEmpty && !_xlObject.filters.contains(Entity.glow)) {
      _xlObject.filters.add(Entity.glow);
      _xlObject.filters.add(Entity.glow);
      _xlObject.filters.add(Entity.glow);
    }
    else if (actions.isEmpty && _xlObject.filters.contains(Entity.glow)) {
      _xlObject.filters.clear();
    }
  }

  Future load();
}
