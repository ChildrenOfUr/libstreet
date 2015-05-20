part of libstreet;


class CollisionLine extends Sprite{
  AnchorCircle A = new AnchorCircle(5, Color.Purple, Color.White, strokeWidth: 5);
  AnchorCircle B = new AnchorCircle(5, Color.Cyan, Color.White, strokeWidth: 5);

  Sprite _line = new Sprite();

  CollisionLine(Point a, Point b) {
    A.x = a.x;
    A.y = a.y;

    B.x = b.x;
    B.y = b.y;

    Shape shape = new Shape();
    shape.graphics.rect(0,-2, 1, 5);
    shape.graphics.fillColor(Color.White);
    shape.applyCache(0, -2, 1, 5);
    _line.addChild(shape);

    addChild(_line);
    addChild(A);
    addChild(B);


    _line.onMouseDown.listen((_) {
      this.startDrag();
    });

    _line.onMouseUp.listen((_) {
      this.stopDrag();
    });
  }

  @override
  render(RenderState renderState) {
    _line.x = A.x;
    _line.y = A.y;
    _line.children.first.width = new Point(A.x, A.y).distanceTo(new Point(B.x,B.y));
    _line.rotation = Math.atan2(B.y-A.y, B.x-A.x);
    super.render(renderState);
  }

}


class AnchorCircle extends Sprite {
  AnchorCircle(num r, int fill, int stroke, {num strokeWidth : 0}) {
    Shape shape = new Shape();
    shape.graphics.circle(0,0,r);
    if (stroke != null)
      shape.graphics.strokeColor(stroke, strokeWidth);
    shape.graphics.fillColor(fill);
    shape.applyCache(-r - strokeWidth, -r - strokeWidth, (r + strokeWidth)*2, (r + strokeWidth)*2);
    this.addChild(shape);

    this.onMouseDown.listen((_) {
      this.startDrag(true);
    });

    this.onMouseUp.listen((_) {
      this.stopDrag();
    });
  }
}

