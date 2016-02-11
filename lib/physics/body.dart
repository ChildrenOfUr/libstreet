part of physics;

class Body {
  int id;
  StreetPhysics _street;
  num width, height;
  num x, y;
  Rectangle get bounds => new Rectangle(x, y, width, height);
  Point get position => new Point(x, y);
  Vector velocity = new Vector.zero();

  bool simulate = false;
  bool _isOnGround = false;
  bool _isTouchingLadder = false;

  Body(this.id, this.x, this.y);

  impulse(num x, num y) {
    velocity += new Vector(x, y);
  }

  bool activeClimb = false;
  get climbing => activeClimb;
  set climbing(bool isClimbing) {
    activeClimb = isClimbing;
  }

  _updatePhysics(num delta) {
    Vector oldPos = new Vector(x, y);
    _updateVelocity();
    x += velocity.x * 60 * delta;
    y += velocity.y * 60 * delta;
    _processPlatformCollisions(oldPos);
    _processLadderCollisions();
  }

  _updateVelocity() {
    // friction and gravity
    if (velocity.x > 0.01 || velocity.x < -0.01) {
      velocity.x = velocity.x * (1 - _street.friction);
    } else if (velocity.x != 0) {
      velocity.x = 0;
    }

    if (!_isOnGround && !activeClimb) {
      velocity.y += _street.gravity;
    } else if (activeClimb && (velocity.y > 0.01 || velocity.y < -0.01)) {
      velocity.y = velocity.y * (1 - _street.friction);
    }

    // maximum velocity
    if (velocity.x > _street.maxVelocity.x) {
      velocity.x = _street.maxVelocity.x;
    } else if (velocity.x < -_street.maxVelocity.x) {
      velocity.x = -_street.maxVelocity.x;
    }
    if (velocity.y > _street.maxVelocity.y) {
      velocity.y = _street.maxVelocity.y;
    } else if (velocity.y < -_street.maxVelocity.y) {
      velocity.y = -_street.maxVelocity.y;
    }
  }

  _processPlatformCollisions(Vector old) {
    Platform bestPlatform;
    num bestDiffY = double.INFINITY;

    List list = _street.collisionObjects.values
        .where((CollisionObject child) => child is Platform)
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
      num diffY = (old.y - lineY).abs();

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

    num slope = bestPlatform.slope;
    num yInt = bestPlatform.start.y - slope * bestPlatform.start.x;
    num lineY = slope * x + yInt;
    if (y >= lineY && old.y <= lineY + 30 && velocity.y >= 0 && !activeClimb) {
      y = lineY;
      velocity.y = 0;
    }
    if (y >= lineY - 10 && y <= lineY + 10) {
      _isOnGround = true;
    } else {
      _isOnGround = false;
    }
  }

  _processLadderCollisions() {
    List ladders = _street.collisionObjects.values
        .where((CollisionObject child) => child is Ladder);
    for (Ladder ladder in ladders) {
      _isTouchingLadder = ladder.bounds.containsPoint(position);
      if (_isTouchingLadder) break;
    }
  }
}
