part of libstreet;

/// a static representation of a camera. Makes sure it's in bounds;
class Camera {
  Camera._();

  num _x = 0;
  num _y = 0;

  num get x {
    if (_x >= StreetRenderer.current.bounds.width - viewport.width)
      return StreetRenderer.current.bounds.width - viewport.width;
    if (_x <= 0)
      return 0;
    return _x;
  }

  num get y {
    if (_y <= 0)
      return 0;
    if (_y >= StreetRenderer.current.bounds.height - viewport.height)
      return StreetRenderer.current.bounds.height - viewport.height;
    return _y;
  }
  set x(num x) => _x = x;
  set y(num y) => _y = y;

  refresh() {
    x = _x;
    y = _y;
  }

  Rectangle get viewport =>
    new Rectangle(0, 0,
      StreetRenderer.stage.stageWidth * (StreetRenderer.canvas.width / StreetRenderer.stage.stageWidth),
      StreetRenderer.stage.stageHeight * (StreetRenderer.canvas.height / StreetRenderer.stage.stageHeight));

  @override
  toString() => 'x:$x y:$y';
}
