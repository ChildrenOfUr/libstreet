part of physics;

class Wall extends CollisionLine {
  Wall(String id, Point a, Point b): super(id, a, b);
}

class Platform extends CollisionLine {
  Platform(String id, Point a, Point b): super(id, a, b);
}

class Ladder extends CollisionRect {
  Ladder(String id, Point a, Point b) : super(id, a, b);
}



abstract class CollisionRect extends CollisionObject {
  Rectangle bounds;
  CollisionRect(String id, Point a, Point b) : super(id) {
    this.bounds = new Rectangle.fromPoints(a, b);
  }
}

abstract class CollisionLine extends CollisionObject {
  Point a;
  Point b;

  CollisionLine(String id, this.a, this.b) : super(id);

  Point get start {
    if (a.x < b.x)
      return a;
    else
      return b;
  }
  Point get end {
    if (a.x > b.x)
      return a;
    else
      return b;
  }
  num get slope {
    return (end.y - start.y) / (end.x - start.x);
  }
}

abstract class CollisionObject {
  String id;
  CollisionObject(this.id);
}