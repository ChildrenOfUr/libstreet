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

class Wall extends CollisionRect {
  String id;
  // these colors determine the line's colors.
  int primaryColor = Color.Red;
  int secondaryColor = Color.Red;
  Wall(this.id, Point a, Point b) : super(a,b);
}


class CollisionRect extends Sprite {
  AnchorCircle A;
  AnchorCircle B;

  Sprite _rect = new Sprite();

  bool canEdit = true;
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

    _rect.addChild(new Bitmap(StreetRenderer.pixel));
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

    if (A.x > B.x - 1 && A.dragging) {
      A.x = B.x;
      A.dragging = false;
      A.stopDrag();
    }
    if (B.x < A.x + 5 && B.dragging) {
      B.x = A.x;
    }

    if (A.y > B.y - 1 && A.dragging) {
      A.y = B.y;
    }
    if (B.y < A.y + 5 && B.dragging) {
      B.y = A.y;
    }

    _rect.width = B.x - A.x + 4;
    _rect.height = B.y - A.y + 4;
    _rect.x = A.x - 2;
    _rect.y = A.y - 2;
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

  num get slope {
    return (B.street.y - A.street.y) / (B.street.x - A.street.x);
  }
  Point get start => new Point(A.x, A.y);
  Point get end => new Point(B.x, B.y);

  CollisionLine(Point a, Point b) {
    mouseCursor = 'pointer';
    A = new AnchorCircle(5, primaryColor, Color.White, strokeWidth: 5);
    B = new AnchorCircle(5, secondaryColor, Color.White, strokeWidth: 5);


    A.x = a.x;
    A.y = a.y;

    B.x = b.x;
    B.y = b.y;

		_line.addChild(new Bitmap(StreetRenderer.pixel));
    _line.height = 5;
    _line.pivotY = 5;

    addChild(_line);
    addChild(A);
    addChild(B);

    A.onDragEnd.listen((_) {
      if (A.x < B.x) {
        A.x = B.x;
      }
    });
    B.onDragEnd.listen((_) {
      if (B.x > A.x) {
        B.x = A.x;
      }
    });

    print(A.x.toString() + "/" + a.x.toString());

    addChild(new AnchorCircle(50, Color.Aqua, Color.Red));
  }

  @override
  render(RenderState renderState) {

    if (B.x > A.x && B.dragging) {
      B.x = A.x;
    }

    if (A.x < B.x && A.dragging) {
      A.x = B.x;
    }

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


class AnchorCircle extends StreetSprite {
  bool dragging = false;
  StreamController _draggingStream = new StreamController.broadcast();
  Stream get onDragEnd => _draggingStream.stream;

  AnchorCircle(num r, int fill, int stroke, {num strokeWidth : 0}) {
    mouseCursor = 'pointer';
    Shape shape = new Shape();
    shape.graphics.circle(0,0,r);
    if (stroke != null)
      shape.graphics.strokeColor(stroke, strokeWidth);
    shape.graphics.fillColor(fill);
    shape.applyCache(-r - strokeWidth, -r - strokeWidth, (r + strokeWidth)*2, (r + strokeWidth)*2);
    this.addChild(shape);

    this.onMouseDown.listen((_) {
      dragging = true;
      this.startDrag(true);
    });

    this.onMouseUp.listen((_) {
      dragging = false;
      this.stopDrag();
      _draggingStream.add(null);
    });
  }
}
