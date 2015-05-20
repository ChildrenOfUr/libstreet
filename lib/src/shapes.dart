part of libstreet;

class Platform extends CollisionLine {
  String id;
  // these colors determine the line's colors.
  int primaryColor = Color.Purple;
  int secondaryColor = Color.MediumPurple;
  Platform(this.id, Point a, Point b) : super(a,b);
}

class Ladder extends CollisionRect {
  String id;
  // these colors determine the rectangle's colors.
  int primaryColor = Color.Green;
  int secondaryColor = Color.Yellow;
  Ladder(this.id, Point a, Point b) : super(a,b);
}

class Wall extends CollisionLine {
  String id;
  // these colors determine the line's colors.
  int primaryColor = Color.Red;
  int secondaryColor = Color.Red;
  Wall(this.id, Point a, Point b) : super(a,b);
}


class CollisionRect extends Sprite {
  AnchorCircle A;
  AnchorCircle B;

  bool canEdit = true;

  Sprite _rect;

  num primaryColor = Color.Black;
  num secondaryColor = Color.Black;

  CollisionRect (Point a, Point b) {
    _rect = new Sprite();
    A = new AnchorCircle(5, primaryColor, Color.White, strokeWidth: 5);
    B = new AnchorCircle(5, secondaryColor, Color.White, strokeWidth: 5);

    A.x = a.x;
    A.y = a.y;

    B.x = b.x;
    B.y = b.y;

    Shape shape = new Shape();
    shape.graphics.rect(0,0, 1, 1);
    shape.graphics.fillColor(Color.White);
    shape.applyCache(0, 0, 1, 1);
    _rect.addChild(shape);
    _rect.alpha = 0.5;

    addChild(_rect);
    addChild(A);
    addChild(B);

    _rect.onMouseDown.listen((_) {
      if (canEdit)
        this.startDrag();
    });

    _rect.onMouseUp.listen((_) {
      if (canEdit)
        this.stopDrag();
    });
  }

  @override
  render(RenderState renderState) {
    _rect.x = A.x;
    _rect.y = A.y;
    _rect.children.first.width = B.x - A.x;
    _rect.children.first.height = B.y - A.y;

    if (canEdit) {
      A.visible = true;
      B.visible = true;
    }
    else {
      A.visible = false;
      B.visible = false;
    }

    super.render(renderState);
  }


}


class CollisionLine extends Sprite{
  AnchorCircle A;
  AnchorCircle B;

  bool canEdit = true;

  Sprite _line = new Sprite();

  num primaryColor = Color.Black;
  num secondaryColor = Color.Black;

  CollisionLine(Point a, Point b) {
    A = new AnchorCircle(5, primaryColor, Color.White, strokeWidth: 5);
    B = new AnchorCircle(5, secondaryColor, Color.White, strokeWidth: 5);

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
      if (canEdit)
      startDrag();
    });

    _line.onMouseUp.listen((_) {
      if (canEdit)
      stopDrag();
    });
  }

  @override
  render(RenderState renderState) {
    _line.x = A.x;
    _line.y = A.y;
    _line.children.first.width = new Point(A.x, A.y).distanceTo(new Point(B.x,B.y));
    _line.rotation = Math.atan2(B.y-A.y, B.x-A.x);

    if (canEdit) {
      A.visible = true;
      B.visible = true;
    }
    else {
      A.visible = false;
      B.visible = false;
    }

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

