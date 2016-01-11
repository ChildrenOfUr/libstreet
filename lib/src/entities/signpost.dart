part of libstreet;


class Signpost extends Entity {
  Map data;
  Signpost(this.data);

  load() async {
    if (!StreetRenderer.resourceManager.containsBitmapData('signpost')) {
    StreetRenderer.resourceManager.addBitmapData('signpost', 'http://childrenofur.com/locodarto/scenery/sign_pole.png');
    }
    await StreetRenderer.resourceManager.load();

    Bitmap pole = new Bitmap(StreetRenderer.resourceManager.getBitmapData('signpost'));
    pole.pivotX = pole.width/2;
    pole.pivotY = pole.height - 20;
    addChild(pole);
  }
}
