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

    if (x >= StreetRenderer.current.bounds.width - viewport.width)
      x = StreetRenderer.current.bounds.width - viewport.width;

    _x = x;
  }

  set y(num y) {
    if (y <= 0)
      y = 0;
    if (y >= StreetRenderer.current.bounds.height - viewport.height)
      y = StreetRenderer.current.bounds.height - viewport.height;

    _y = y;
  }

  Rectangle get viewport =>
    new Rectangle(x, y,
      StreetRenderer.stage.stageWidth * (StreetRenderer.stage.sourceWidth / StreetRenderer.stage.stageWidth),
      StreetRenderer.stage.stageHeight * (StreetRenderer.stage.sourceHeight / StreetRenderer.stage.stageHeight));

  @override
  toString() => 'x:$x y:$y';
}
