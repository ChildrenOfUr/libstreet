part of libstreet;

abstract class Physics {
  static Vec gravity = new Vec(0, 1);
  static Vec maxVelocity = new Vec(0, 3);

  static simulate(PhysicsEntity entity) {
    // process collisions with these objects.
    for (Sprite collider in StreetRenderer.current.collisionLayer.children) {
      Type kind = collider.runtimeType;
    }

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
}
