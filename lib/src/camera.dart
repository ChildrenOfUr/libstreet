part of libstreet;

/// a static representation of a camera. Makes sure it's in bounds;
class Camera {
  Street street;

  num _x = 0;
  num _y = 0;

  num get x => _x;
  num get y => _y;

  set x(num x) {
    if (x <= 0)
      x = 0;

    if (x + street.stage.stageWidth >= street.bounds.width)
      x = street.bounds.width - street.stage.stageWidth;

    _x = x;
  }

  set y(num y) {
    if (y <= 0)
      y = 0;
    if (y + street.stage.stageHeight >= street.bounds.height)
      y = street.bounds.height - street.stage.stageHeight;

    _y = y;
  }

  @override
  toString() => 'x:$x y:$y';
}