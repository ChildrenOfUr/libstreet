part of libstreet;


class Quoin extends Entity {
  QuoinRing ring;
  int value = 1;
  String type = 'None';

  Quoin(this.type) {
    value = 1 + new Math.Random().nextInt(10);
  }

  bool disabled = false;
  bool collected = false;

  pop() async {
    collected = true;
    animation.visible = false;
    await ring.pop();
  }

  load() async {
    await animation.load(animationDef);
    animation.set(type);
    ring = new QuoinRing('+$value $type');
    addChild(ring);
    addChild(animation);
  }

  Map animationDef = {
    'image': 'https://raw.githubusercontent.com/RobertMcDermot/coUspritesheets/master/spritesheets/quoin/quoin__x1_1_x1_2_x1_3_x1_4_x1_5_x1_6_x1_7_x1_8_png_1354829599.png',
    'height': 8,
    'width': 24,
    'animations': {
      'img': {
        'frames': [
          [0, 23]
        ],
        'loop': true
      },
      'mood': {
        'frames': [
          [24, 47]
        ],
        'loop': true
      },
      'energy': {
        'frames': [
          [48, 71]
        ],
        'loop': true
      },
      'currant': {
        'frames': [
          [72, 95]
        ],
        'loop': true
      },
      'mystery': {
        'frames': [
          [96, 119]
        ],
        'loop': true
      },
      'favor': {
        'frames': [
          [120, 143]
        ],
        'loop': true
      },
      'time': {
        'frames': [
          [144, 167]
        ],
        'loop': true
      },
      'quarazy': {
        'frames': [
          [168, 191]
        ],
        'loop': true
      }
    }
  };
}


class QuoinRing extends Sprite {
  Shape ring;
  TextField text;
  QuoinRing(String message) {
    ring = new Shape();
    ring.graphics.circle(0,0,30);
    ring.graphics.strokeColor(0xFFFFFFFF, 3);
    ring.graphics.fillColor(0x44FFFFFF);
    ring.applyCache(-35, -35, (35)*2, (35)*2);
    ring.y -= 20;

    text = new TextField();
    var format = new TextFormat('Fredoka One', 32, 0xFFFFFFFF, align:TextFormatAlign.CENTER);
    text.defaultTextFormat = format;
    text.text = message;
    text.width = 600;
    text.filters.add(
      new DropShadowFilter(5, 1.5708, 0x55000000, 5, 5)
    );
    text.applyCache(-20, -20, text.width + 20, text.height + 20);
    text.pivotX = text.width/2;
    text.y = -10;
    text.pivotY = text.height/2 - 20;
    close();
    addChild(ring);
    addChild(text);
  }

  open() async {
    Tween textTween = new Tween(text, 0.9, Transition.easeInOutElastic);
    StreetRenderer.juggler.add(textTween);
    textTween.animate.scaleY.to(1.0);
    textTween.animate.scaleX.to(1.0);
    await new Future.delayed(new Duration(milliseconds: 100));

    Tween ringTween = new Tween(ring, 0.9, Transition.easeInOutElastic);
    StreetRenderer.juggler.add(ringTween);
    ringTween.animate.scaleY.to(1.0);
    ringTween.animate.scaleX.to(1.0);
    await new Future.delayed(new Duration(milliseconds: 250));
  }
  close() async {
    Tween ringTween = new Tween(ring, 0.9, Transition.easeInOutElastic);
    StreetRenderer.juggler.add(ringTween);
    ringTween.animate.scaleY.to(0);
    ringTween.animate.scaleX.to(0);
    await new Future.delayed(new Duration(milliseconds: 100));

    Tween textTween = new Tween(text, 0.9, Transition.easeInOutElastic);
    StreetRenderer.juggler.add(textTween);
    textTween.animate.scaleY.to(0.0);
    textTween.animate.scaleX.to(0.0);
    await new Future.delayed(new Duration(milliseconds: 250));
  }


  pop() async {
    await open();
    await new Future.delayed(new Duration(milliseconds: 600));
    await close();
  }
}
