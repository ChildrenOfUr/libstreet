part of libstreet;

/// a static representation of a camera. Makes sure it's in bounds;
class Camera {
  Camera._();

  num _x = 0;
  num _y = 0;

  num get x {
    if (_x >= StreetRenderer.current.bounds.width - viewport.width/2)
      return StreetRenderer.current.bounds.width - viewport.width/2;
    if (_x <= viewport.width/2)
      return viewport.width/2;
    return _x;
  }

  num get y {
    if (_y <= viewport.height/2)
      return viewport.height/2;
    if (_y >= StreetRenderer.current.bounds.height - viewport.height/2)
      return StreetRenderer.current.bounds.height - viewport.height/2;
    return _y;
  }
  set x(num x) => _x = x;
  set y(num y) => _y = y;

  Rectangle get viewport =>
    new Rectangle(0, 0,
      StreetRenderer.stage.stageWidth * (StreetRenderer.canvas.width / StreetRenderer.stage.stageWidth),
      StreetRenderer.stage.stageHeight * (StreetRenderer.canvas.height / StreetRenderer.stage.stageHeight));

  @override
  toString() => 'x:$x y:$y';
}
