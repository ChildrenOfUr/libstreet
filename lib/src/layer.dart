part of libstreet;

class StreetLayer extends Layer {
  Sprite _decoHolder = new Sprite();
  Street street;
  Map def;

  num get width => def['w'];
  num get height => def['h'];
  num get z => def['z'];

  StreetLayer._(final this.def, {this.street}) {
    addChild(_decoHolder);

    // Sort by z values
    List decoList = new List.from(def['decos'])
      ..sort((Map A, Map B) => A['z'].compareTo(B['z']));

    for (Map decoMap in decoList) {
      if (street.loaded == false) throw ("Decos not loaded!");

      Deco deco = new Deco._(decoMap, layer: this);
      if (def['name'] == 'middleground') {
        //middleground has different layout needs
        deco.y += height;
        deco.x += width ~/ 2;
      }

      // Add to the layer
      addDeco(deco);
    }
    applyFilters();
  }

  addDeco(Deco deco) {
    _decoHolder.addChild(deco);
  }

  applyFilters() {
    // Apply filters
    print('${def['name']} ${def['filters']}');

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
        _decoHolder.filters.add(new BlurFilter(def['filters']['blur']));
      }
    }
    _decoHolder.filters.add(layerFilter);

    _decoHolder.applyCache(0,0, width, height);
  }
}


class ActorLayer extends Sprite {}

class CollisionLayer extends Sprite {
  Street street;
  CollisionLayer(this.street) {

    // Add ladders.
    List ladders = new List.from(street.def['dynamic']['layers']['middleground']['ladders']);
    for (Map ladderMap in ladders) {
      CollisionRect ladder = new CollisionRect(
          new Point(ladderMap['x'],ladderMap['y']),
          new Point(ladderMap['x'] - ladderMap['w'],ladderMap['y'] - ladderMap['h'])
      );
      addChild(ladder);
    }

    // Add collision lines.
    List lines = new List.from(street.def['dynamic']['layers']['middleground']['platformLines']);
    for (Map lineMap in lines) {
      CollisionLine line = new CollisionLine(
          new Point(lineMap['endpoints'].first['x'],lineMap['endpoints'].first['y']),
          new Point(lineMap['endpoints'].last['x'],lineMap['endpoints'].last['y']));
      addChild(line);
    }

  }

}

/// Parent layer class, handles parallax
class Layer extends Sprite {
  Street street;
  // override render to support parallax
  @override render(RenderState renderState) {
    num currentPercentX =
    (street.camera.x) / (street.bounds.width - stage.stageWidth);
    num currentPercentY =
    (street.camera.y) / (street.bounds.height - stage.stageHeight);

    //modify left and top
    x = -(width - stage.stageWidth) * currentPercentX;
    y = -(height - stage.stageHeight) * currentPercentY;
    super.render(renderState);
  }
}