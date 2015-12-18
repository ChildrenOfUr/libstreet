part of libstreet;

/// a static representation of a camera. Makes sure it's in bounds;
class Camera {
  Camera._();

  num _x = 0;
  num _y = 0;

  num get x {
    if (_x >= StreetRenderer.current.bounds.width - viewport.width/2 + StreetRenderer.current.bounds.left)
      return StreetRenderer.current.bounds.width - viewport.width/2 + StreetRenderer.current.bounds.left;
    if (_x <= viewport.width/2 + StreetRenderer.current.bounds.left)
      return viewport.width/2 + StreetRenderer.current.bounds.left;
    return _x;
  }

  num get y {
    if (_y <= viewport.height/2 + StreetRenderer.current.bounds.top)
      return viewport.height/2 + StreetRenderer.current.bounds.top;
    if (_y >= StreetRenderer.current.bounds.height - viewport.height/2 + StreetRenderer.current.bounds.top)
      return StreetRenderer.current.bounds.height - viewport.height/2 + StreetRenderer.current.bounds.top;
    return _y;
  }
  set x(num x) => _x = x;
  set y(num y) => _y = y;

  Rectangle get viewport =>
    new Rectangle(_x, _y,
      StreetRenderer.stage.stageWidth * (StreetRenderer.canvas.width / StreetRenderer.stage.stageWidth),
      StreetRenderer.stage.stageHeight * (StreetRenderer.canvas.height / StreetRenderer.stage.stageHeight));

  @override
  toString() => 'x:$x y:$y';
}
