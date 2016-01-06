part of libstreet;

abstract class Physics {
  static Vector maxVelocity = new Vector(10, 5);
  static num friction = 0.25;
  static num gravity = 1;
}

abstract class PhysicsEntity extends Entity {
  // bools
  bool isOnGround = false;
  Vector velocity = new Vector.zero();

  @override
  advanceTime(num time) {
    super.advanceTime(time);
    Vector old = new Vector(x,y);

    // friction and gravity
    if (velocity.x > 0.01 || velocity.x < -0.01) {
      velocity.x = velocity.x* (1 - Physics.friction);
    } else if (velocity.x != 0) {
      velocity.x = 0;
    }
    if (!isOnGround) {
      velocity.y += Physics.gravity;
    }

    // maximum velocity
    if (velocity.x > Physics.maxVelocity.x) {
      velocity.x = Physics.maxVelocity.x;
    } else if (velocity.x < -Physics.maxVelocity.x) {
      velocity.x = -Physics.maxVelocity.x;
    }

    // process velocity
    x += velocity.x;
    y += velocity.y;

    // process collisions with platforms.
    Platform bestPlatform = _getBestPlatform(old.y);
    if (bestPlatform != null) {
      num slope = bestPlatform.slope;
      num yInt = bestPlatform.start.y - slope * bestPlatform.start.x;
      num lineY = slope * x + yInt;

      if (y >= lineY && old.y <= lineY + 30) {
        isOnGround = true;
        y = lineY;
        velocity.y = 0;
      } else if (isOnGround == true) {
        isOnGround = false;
      }

    }
  }

  impulse(int x, int y) {
    velocity += new Vector(x,y);
  }

  Platform _getBestPlatform(num oldY) {
    Platform bestPlatform;
    num bestDiffY = double.INFINITY;

    List list = StreetRenderer.current.collisionLayer.children
        .where((Sprite child) => child is Platform)
        .where(
            (Platform platform) => x >= platform.start.x && x <= platform.end.x)
        .toList()
          ..sort((Platform a, Platform b) {
            num yIntA = a.start.y - a.slope * a.start.x;
            num yIntB = b.start.y - b.slope * b.start.x;
            return yIntA.compareTo(yIntB);
          });

    for (Platform platform in list) {
      num slope = platform.slope;
      num yInt = platform.start.y - slope * platform.start.x;
      num lineY = slope * x + yInt;
      num diffY = (oldY - lineY).abs();

      if (bestPlatform == null) {
        bestPlatform = platform;
        bestDiffY = diffY;
      } else {
        if (diffY < bestDiffY) {
          bestPlatform = platform;
          bestDiffY = diffY;
        }
      }
    }

    return bestPlatform;
  }
}

class Vector {
  num x = 0;
  num y = 0;

  Vector(this.x,this.y);
  Vector.zero();

  operator /(num other) {
    return new Vector(x/other, y/other);
  }
  operator *(num other) {
    return new Vector(x*other, y*other);
  }
  operator +(Vector other) {
    return new Vector(x+other.x, y+other.y);
  }
  operator -(Vector other) {
    return new Vector(x-other.x, y-other.y);
  }
  @override toString() {
    return '$x, $y';
  }
}
