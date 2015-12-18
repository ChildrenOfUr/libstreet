part of libstreet;

abstract class Physics {
  static Vec gravity = new Vec(0, 1);
  static Vec maxVelocity = new Vec(0, 5);

  static simulate(PhysicsEntity entity) {
    num oldY = entity.y;

    // update physics vars.
    entity.velocity += entity.acceleration;
    entity.velocity += gravity;
    if (entity.velocity.x > Physics.maxVelocity.x) {
      entity.velocity = new Vec(Physics.maxVelocity.x, entity.velocity.y);
    }
    if (entity.velocity.y > Physics.maxVelocity.y) {
      entity.velocity = new Vec(entity.velocity.x, Physics.maxVelocity.y);
    }
    entity.y += entity.velocity.y;
    entity.x += entity.velocity.x;

    // process collisions with these objects.
    Platform bestPlatform = entity._getBestPlatform(oldY);
    if (bestPlatform != null) {
      num goingTo = entity.y;
      num slope = bestPlatform.slope;
      num yInt = bestPlatform.start.y - slope * bestPlatform.start.x;
      num lineY = slope * entity.x + yInt;

      if (goingTo >= lineY - 10 && goingTo <= lineY + 10) {
        entity.y = lineY;
        entity.acceleration = new Vec(entity.acceleration.x, 0);
      }
    }
  }
}

abstract class PhysicsEntity extends Entity {
  Vec velocity = new Vec(0, 0);
  Vec acceleration = new Vec(0, 0);

  @override
  advanceTime(num time) {
    super.advanceTime(time);
    Physics.simulate(this);
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
