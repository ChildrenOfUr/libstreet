part of libstreet;

abstract class Physics {
  static Vec gravity = new Vec(0, 1);
  static Vec maxVelocity = new Vec(0, 6);
}

abstract class PhysicsEntity extends Entity {
  // bools
  bool onGround = false;

  Vec velocity = new Vec(0, 0);
  Vec acceleration = new Vec(0, 0);

  @override
  advanceTime(num time) {
    super.advanceTime(time);
    num oldY = y;
    // update physics vars.
    velocity += acceleration;
    velocity += Physics.gravity;
    if (velocity.x > Physics.maxVelocity.x) {
      velocity = new Vec(Physics.maxVelocity.x, velocity.y);
    }
    if (velocity.y > Physics.maxVelocity.y) {
      velocity = new Vec(velocity.x, Physics.maxVelocity.y);
    }
    y += velocity.y;
    x += velocity.x;

    // process collisions with these objects.
    Platform bestPlatform = _getBestPlatform(oldY);
    if (bestPlatform != null) {
      num slope = bestPlatform.slope;
      num yInt = bestPlatform.start.y - slope * bestPlatform.start.x;
      num lineY = slope * x + yInt;

      if (y >= lineY && oldY <= lineY + 30) {
        onGround = true;
        y = lineY;
        acceleration = new Vec(acceleration.x, 0);
      } else if (onGround == true) {
        onGround = false;
      }

    }
  }

  impulse(int x, int y) {}

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
