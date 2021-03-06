part of libstreet;

class CollisionLayer extends Layer {
  Map streetData;

  CollisionLayer(this.streetData) {
    layerWidth = Street.current.bounds.width;
    layerHeight = Street.current.bounds.height;

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
              lineMap['endpoints'].last['x'], lineMap['endpoints'].last['y']),
          new Point(
              lineMap['endpoints'].first['x'], lineMap['endpoints'].first['y']));
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
        (Street.current.bounds.width -
            StreetRenderer.camera.viewport.width);
    num currentPercentY = (StreetRenderer.camera.y -
            StreetRenderer.camera.viewport.height / 2) /
        (Street.current.bounds.height -
            StreetRenderer.camera.viewport.height);
    num offsetX =
        (layerWidth - StreetRenderer.camera.viewport.width) * currentPercentX;
    num offsetY =
        (layerHeight - StreetRenderer.camera.viewport.height) * currentPercentY;
    x = -offsetX  - streetData['dynamic']['l'];
    y = -offsetY  - streetData['dynamic']['t'];
    super.render(renderState);
  }

}

class EntityLayer extends Layer {
  Map streetData;
  EntityLayer(this.streetData) {
    layerWidth = Street.current.bounds.width;
    layerHeight = Street.current.bounds.height;
  }

  // Adjusts the layers according to the camera position.
  @override
  render(RenderState renderState) {
    num currentPercentX = (StreetRenderer.camera.x -
            StreetRenderer.camera.viewport.width / 2) /
        (Street.current.bounds.width -
            StreetRenderer.camera.viewport.width);
    num currentPercentY = (StreetRenderer.camera.y -
            StreetRenderer.camera.viewport.height / 2) /
        (Street.current.bounds.height -
            StreetRenderer.camera.viewport.height);
    num offsetX =
        (layerWidth - StreetRenderer.camera.viewport.width) * currentPercentX;
    num offsetY =
        (layerHeight - StreetRenderer.camera.viewport.height) * currentPercentY;
        x = -offsetX  - streetData['dynamic']['l'];
        y = -offsetY  - streetData['dynamic']['t'];
    super.render(renderState);
  }
}

class ImageLayer extends Layer {
  Map streetData;
  ImageLayer(String tsid, String name, this.streetData) {
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
        (Street.current.bounds.width -
            StreetRenderer.camera.viewport.width);
    num currentPercentY = (StreetRenderer.camera.y -
            StreetRenderer.camera.viewport.height / 2) /
        (Street.current.bounds.height -
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

class GradientLayer extends Layer {
  Map streetData;
  GradientLayer(this.streetData) {
    String top = streetData['gradient']['top'];
    String bottom = streetData['gradient']['bottom'];

    Shape shape = new Shape();
    shape.graphics.rect(0, 0, Street.current.bounds.width, Street.current.bounds.height);
    var gradient = new GraphicsGradient.linear(0, 0, 0, Street.current.bounds.height);
    gradient.addColorStop(0, int.parse('0xFF$top'));
    gradient.addColorStop(1, int.parse('0xFF$bottom'));
    shape.graphics.fillGradient(gradient);
    shape.applyCache(0, 0, Street.current.bounds.width, Street.current.bounds.height);
    BitmapData bitmapData = new BitmapData.fromRenderTextureQuad(shape.cache);
    Bitmap layerBitmap = new Bitmap(bitmapData);
    addChild(layerBitmap);

    layerWidth = layerBitmap.width;
    layerHeight = layerBitmap.height;
  }

  @override
  render(RenderState renderState) {
    num currentPercentX = (StreetRenderer.camera.x -
            StreetRenderer.camera.viewport.width / 2) /
        (Street.current.bounds.width -
            StreetRenderer.camera.viewport.width);
    num currentPercentY = (StreetRenderer.camera.y -
            StreetRenderer.camera.viewport.height / 2) /
        (Street.current.bounds.height -
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
