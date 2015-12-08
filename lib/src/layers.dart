part of libstreet;

class CollisionLayer extends Layer {
  Map streetData;

  CollisionLayer(this.streetData) {
    layerWidth = StreetRenderer.current.bounds.width;
    layerHeight = StreetRenderer.current.bounds.height;

    // Add ladders.
    List ladders = new List.from(streetData['dynamic']['layers']['middleground']['ladders']);
    for (Map ladderMap in ladders) {
      Ladder ladder = new Ladder(
          ladderMap['id'],
          new Point(ladderMap['x'] - ladderMap['w'] / 2,
              ladderMap['y'] - ladderMap['h']),
          new Point(ladderMap['x'] + ladderMap['w'] / 2,
              ladderMap['y']));
      addChild(ladder);
    }

    // Add collision lines.
    List lines = new List.from(streetData['dynamic']['layers']['middleground']['platformLines']);
    for (Map lineMap in lines) {
      Platform line = new Platform(
          lineMap['id'],
          new Point(
              lineMap['endpoints'].first['x'], lineMap['endpoints'].first['y']),
          new Point(
              lineMap['endpoints'].last['x'], lineMap['endpoints'].last['y']));
      addChild(line);
    }

    List walls = new List.from(streetData['dynamic']['layers']['middleground']['walls']);
    for (Map wallMap in walls) {
      Wall wall = new Wall(
          wallMap['id'],
          new Point(
              wallMap['x'] - wallMap['w'] / 2,
              wallMap['y'] - wallMap['h']),
          new Point(
              wallMap['x'] + wallMap['w'] / 2,
              wallMap['y']));
      addChild(wall);
    }
  }

  // Adjusts the layers according to the camera position.
  @override
  render(RenderState renderState) {
    num currentPercentX = (StreetRenderer.camera.x -
            StreetRenderer.camera.viewport.width / 2) /
        (StreetRenderer.current.bounds.width -
            StreetRenderer.camera.viewport.width);
    num currentPercentY = (StreetRenderer.camera.y -
            StreetRenderer.camera.viewport.height / 2) /
        (StreetRenderer.current.bounds.height -
            StreetRenderer.camera.viewport.height);
    num offsetX =
        (layerWidth - StreetRenderer.camera.viewport.width) * currentPercentX;
    num offsetY =
        (layerHeight - StreetRenderer.camera.viewport.height) * currentPercentY;
    x = -offsetX - streetData['dynamic']['l'];
    y = -offsetY - streetData['dynamic']['t'];
    super.render(renderState);
  }

}

class EntityLayer extends Layer {
  EntityLayer() {
    layerWidth = StreetRenderer.current.bounds.width;
    layerHeight = StreetRenderer.current.bounds.height;
  }
}

class ImageLayer extends Layer {
  ImageLayer(String tsid, String name) {
    this.mouseEnabled = false;
    this.name = name;
    Bitmap layerBitmap =
        new Bitmap(StreetRenderer.resourceManager.getBitmapData(name + tsid));
    addChild(layerBitmap);
    layerWidth = layerBitmap.width;
    layerHeight = layerBitmap.height;
  }
  // Adjusts the layers according to the camera position.
  @override
  render(RenderState renderState) {
    num currentPercentX = (StreetRenderer.camera.x -
            StreetRenderer.camera.viewport.width / 2) /
        (StreetRenderer.current.bounds.width -
            StreetRenderer.camera.viewport.width);
    num currentPercentY = (StreetRenderer.camera.y -
            StreetRenderer.camera.viewport.height / 2) /
        (StreetRenderer.current.bounds.height -
            StreetRenderer.camera.viewport.height);
    num offsetX =
        (layerWidth - StreetRenderer.camera.viewport.width) * currentPercentX;
    num offsetY =
        (layerHeight - StreetRenderer.camera.viewport.height) * currentPercentY;
    x = -offsetX;
    y = -offsetY;
    super.render(renderState);
  }
}

abstract class Layer extends Sprite {
  num layerWidth;
  num layerHeight;
  Layer();
}
