part of libstreet;

class StreetLayer extends Sprite {
  Street street;
  Map def;
  StreetLayer(final this.def);

  // override render to support parallax
  @override render(RenderState renderState) {
    num currentPercentX = (street.camera.x) / (street.bounds.width - STAGE.stageWidth);
    num currentPercentY = (street.camera.y) / (street.bounds.height - STAGE.stageHeight);

    //modify left and top
    x = -(def['w'] - STAGE.stageWidth) * currentPercentX;// - (def['w']/2);
    y = -(def['h'] - STAGE.stageHeight) * currentPercentY;// - (def['h']/2);
    y += street._streetDef['dynamic']['ground_y'];

    super.render(renderState);
  }
}