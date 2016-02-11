library physics;

import 'dart:math';
import 'dart:convert';
part 'body.dart';
part 'collision.dart';

class StreetPhysics {
  Rectangle bounds;
  Map<String, Body> bodies = {};
  Map<String, CollisionObject> collisionObjects = {};

  Vector maxVelocity = new Vector(10, 30);
  num friction = 0.25;
  num gravity = 1;

  Body queryId(String id) => bodies[id];

  simulate(num delta) {
    for (Body body in bodies.values) {
      if (body.simulate) {
        body._updatePhysics(delta);
      }
    }
  }

  StreetPhysics(String streetJson) {
    Map streetData = JSON.decode(streetJson)['dynamic'];
    bounds = new Rectangle.fromPoints(
        new Point(streetData['l'], streetData['t']),
        new Point(streetData['r'], streetData['b']));
    addCollisionObjects(streetData['layers']);
  }

  addCollisionObjects(List<Map> layers) {
    for (Map layer in layers) {
      List ladders = new List.from(layer['ladders']);
      for (Map ladderMap in ladders) {
        Ladder ladder = new Ladder(
            ladderMap['id'],
            new Point(ladderMap['x'] - ladderMap['w'] / 2,
                ladderMap['y'] - ladderMap['h']),
            new Point(ladderMap['x'] + ladderMap['w'] / 2, ladderMap['y']));
        collisionObjects[ladderMap['id']] = ladder;
      }

      List lines = new List.from(layer['platformLines']);
      for (Map lineMap in lines) {
        Platform line = new Platform(
            lineMap['id'],
            new Point(
                lineMap['endpoints'].last['x'], lineMap['endpoints'].last['y']),
            new Point(lineMap['endpoints'].first['x'],
                lineMap['endpoints'].first['y']));
        collisionObjects[lineMap['id']] = line;
      }

      List walls = new List.from(layer['walls']);
      for (Map wallMap in walls) {
        Wall wall = new Wall(
            wallMap['id'],
            new Point(
                wallMap['x'] - wallMap['w'] / 2, wallMap['y'] - wallMap['h']),
            new Point(wallMap['x'] + wallMap['w'] / 2, wallMap['y']));
        collisionObjects[wallMap['id']] = wall;
      }
    }
  }
}

class Vector {
  num x = 0;
  num y = 0;
  Vector(this.x, this.y);
  Vector.zero();
  operator /(num other) {
    return new Vector(x / other, y / other);
  }

  operator *(num other) {
    return new Vector(x * other, y * other);
  }

  operator +(Vector other) {
    return new Vector(x + other.x, y + other.y);
  }

  operator -(Vector other) {
    return new Vector(x - other.x, y - other.y);
  }

  @override toString() {
    return '$x, $y';
  }
}
