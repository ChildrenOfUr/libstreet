part of libstreet;

/// a static representation of a camera. Makes sure it's in bounds;
class Camera {
  Camera._();

  num _x = 0;
  num _y = 0;

  num get x => _x;
  num get y => _y;

  set x(num x) {
    if (x <= 0)
      x = 0;

    if (x + StreetRenderer.stage.stageWidth >= StreetRenderer.current.bounds.width)
      x = StreetRenderer.current.bounds.width - StreetRenderer.stage.stageWidth;

    _x = x;
  }

  set y(num y) {
    if (y <= 0)
      y = 0;
    if (y + StreetRenderer.stage.stageHeight >= StreetRenderer.current.bounds.height)
      y = StreetRenderer.current.bounds.height - StreetRenderer.stage.stageHeight;

    _y = y;
  }

  @override
  toString() => 'x:$x y:$y';
}
