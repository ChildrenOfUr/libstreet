part of libstreet;


class DecoLayer extends Layer {
  Street street;
  Map def;

  @override
  num get width => def['w'];
  @override
  num get height => def['h'];
  num get z => def['z'];

  DecoLayer(final this.def, {this.street}) {
    // Sort decos by z value
    List decoList = new List.from(def['decos'])
      ..sort((Map A, Map B) => A['z'].compareTo(B['z']));

    // Create and append decos
    for (Map decoMap in decoList) {
      if (street.loaded == false) throw ("Decos not loaded!");
      Deco deco = new Deco(decoMap, layer: this);
      if (def['name'] == 'middleground') {
        //middleground has different layout needs
        deco.y += height;
        deco.x += width ~/ 2;
      }
      addDeco(deco);
    }
    applyFilters();
    html.ImageElement image = new html.ImageElement(src: new BitmapData.fromRenderTextureQuad(this.cache).toDataUrl());
    html.document.body.append(image);
  }

  addDeco(Deco deco) {
    addChild(deco);
  }


  applyFilters() {
    ColorMatrixFilter layerFilter = new ColorMatrixFilter.identity();
    for (String filter in def['filters'].keys) {
      if (filter == 'tintColor') {
        int color = def['filters']['tintColor'];
        num amount = def['filters']['tintAmount'];
        if (amount == null)
          layerFilter.adjustColoration(color);
        else
          layerFilter.adjustColoration(color, amount/255);
      }
      if (filter == 'brightness') {
        layerFilter.adjustBrightness(def['filters']['brightness'] / 255);
      }
      if (filter == 'saturation') {
        layerFilter.adjustSaturation(def['filters']['saturation'] / 255);
      }
      if (filter == 'contrast') {
        layerFilter.adjustContrast(def['filters']['contrast'] / 255);
      }
      if (filter == 'blur') {
        filters.add(new BlurFilter(def['filters']['blur']));
      }
    }
    filters.add(layerFilter);
    applyCache(0,0, width, height);
    //children.toList().forEach((Deco deco) => deco.dispose());
  }

  // override render to support parallax
  @override updatePosition()  {
    if (stage != null) {
      num currentPercentX =
      (street.camera.x) / (street.bounds.width - stage.stageWidth);
      num currentPercentY =
      (street.camera.y) / (street.bounds.height - stage.stageHeight);

      //modify left and top
      x = -(width - stage.stageWidth) * currentPercentX;
      y = -(height - stage.stageHeight) * currentPercentY;
    }
  }
}

/// Parent layer class, handles parallax
class Layer extends Sprite {
  Street street;
  updatePosition() {
    if (street != null) {
      x = -street.camera.x - street.bounds.left;
      y = -street.camera.y - street.bounds.top;
    }
  }
}