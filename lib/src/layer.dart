part of libstreet;

class StreetLayer extends Sprite {
  Sprite _decoHolder = new Sprite();


  Street street;
  Map def;
  StreetLayer(final this.def) {
    addChild(_decoHolder);
  }


  addDeco(Deco deco) {
    _decoHolder.addChild(deco);
  }

  harden() {
    // Apply filters
    if (def['filters'] != null) {
      print('${def['name']} ${def['filters']}');
      ColorMatrixFilter layerFilter = new ColorMatrixFilter.identity();
      for (String filter in def['filters'].keys) {

        if (filter == 'blur') {
          //_decoHolder.filters.add(new BlurFilter(def['filters']['blur']));
        }

        if (filter == 'saturation') {
          layerFilter.adjustSaturation(def['filters']['saturation'] / 100);
        }

        if (filter == 'contrast') {
          layerFilter.adjustContrast(def['filters']['contrast'] / 100);
        }

        if (filter == 'brightness') {
          layerFilter.adjustBrightness(def['filters']['brightness'] / 100);
        }

        if (filter == 'tintAmount' && def['filters']['tintColor'] != null) {
          int color = def['filters']['tintColor'];
          num amount = def['filters']['tintAmount'];
          layerFilter.adjustColoration(color, amount / 100);
        }
      }
      _decoHolder.filters.add(layerFilter);
    }

    _decoHolder.applyCache(0,0, def['w'], def['h']);
  }

  // override render to support parallax
  @override render(RenderState renderState) {
    num currentPercentX = (street.camera.x) / (street.bounds.width - STAGE.stageWidth);
    num currentPercentY = (street.camera.y) / (street.bounds.height - STAGE.stageHeight);

    //modify left and top
    x = -(def['w'] - STAGE.stageWidth) * currentPercentX;
    y = -(def['h'] - STAGE.stageHeight) * currentPercentY;

    super.render(renderState);
  }
}