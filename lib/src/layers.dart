part of libstreet;


class EntityLayer extends Layer {
  EntityLayer () {
    layerWidth = StreetRenderer.current.bounds.width;
    layerHeight = StreetRenderer.current.bounds.height;
  }
}

class ImageLayer extends Layer {
  ImageLayer(String tsid, String name) {
    this.mouseEnabled = false;
    this.name = name;
    Bitmap layerBitmap = new Bitmap(StreetRenderer.resourceManager.getBitmapData(name+tsid));
    addChild(layerBitmap);
    layerWidth = layerBitmap.width;
    layerHeight = layerBitmap.height;
  }
}

abstract class Layer extends DisplayObjectContainer implements Animatable {
  num layerWidth;
  num layerHeight;
  Layer();

  // Adjusts the layers according to the camera position.
  @override
  advanceTime(num time) {
    num currentPercentX = (StreetRenderer.camera.x - StreetRenderer.camera.viewport.width/2) / (StreetRenderer.current.bounds.width - StreetRenderer.camera.viewport.width);
    num currentPercentY = (StreetRenderer.camera.y - StreetRenderer.camera.viewport.height/2) / (StreetRenderer.current.bounds.height - StreetRenderer.camera.viewport.height);
    num offsetX = (layerWidth - StreetRenderer.camera.viewport.width) * currentPercentX;
    num offsetY = (layerHeight - StreetRenderer.camera.viewport.height) * currentPercentY;
    x = -offsetX;
    y = -offsetY;
  }
}
