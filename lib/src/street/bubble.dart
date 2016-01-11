part of libstreet;


class ChatBubble extends Sprite {
  String text;
  ChatBubble(this.text) {
    TextField text = new TextField();
    //var format = new TextFormat('Fredoka One', 14, Color.Black);
    //text.defaultTextFormat = format;
    text.width = 300 - 30;
    text.wordWrap = true;
    text.text = this.text;
    text.autoSize = TextFieldAutoSize.LEFT;
    text.x = 15;
    text.y = 15;

    Shape back = new Shape();
    back.x = 0;
    back.y = 0;
    back.graphics.rectRound(0, 0, 300, text.height + 30, 8, 8);
    back.graphics.fillColor(Color.White);

    Shape nubbin = new Shape();
    nubbin.x = back.width/2 + 10;
    nubbin.y = back.height - 10;
    nubbin.graphics.rectRound(-15, -15, 30, 30, 3, 3);
    nubbin.graphics.fillColor(Color.White);
    nubbin.rotation = 45;

    addChild(back);
    addChild(nubbin);
    addChild(text);

    filters.add(
      new DropShadowFilter(3, 1.5708, 0x33000000, 3, 3)
    );
    applyCache(-10, -10, width + 20, height + 40);
    pivotX = width/2;
    pivotY = height;
    scaleX = 0;
    scaleY = 0;
    
    new Timer.periodic(new Duration(seconds: 4), (_) async {
      await open();
      await new Future.delayed(new Duration(seconds: 2));
      await close();
    });
	}

  open() async {
    Tween tween = new Tween(this, 0.5, Transition.easeOutElastic);
    StreetRenderer.juggler.add(tween);
    tween.animate.scaleY.to(1.0);
    tween.animate.scaleX.to(1.0);
    await new Future.delayed(new Duration(milliseconds: 500));
  }

  close() async {
    Tween tween = new Tween(this, 0.8, Transition.easeInElastic);
    StreetRenderer.juggler.add(tween);
    tween.animate.scaleY.to(0);
    tween.animate.scaleX.to(0);
    await new Future.delayed(new Duration(milliseconds: 800));
  }
}
