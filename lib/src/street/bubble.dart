part of libstreet;

class ChatBubble extends Sprite {
  String text;
  ChatBubble(this.text, [String username, int color, Map gains]) {
    int paddingX = 0;
    int paddingY = 0;

    TextField text = new TextField();
    text.width = 250 + paddingX - 30;
    text.wordWrap = true;
    text.text = this.text;
    text.autoSize = TextFieldAutoSize.LEFT;
    text.x = 15;
    text.y = 15;

    TextField usernameField;
    if (username != null) {
      text.y += 20;
      paddingY = 20;
      if (color == null) {
        color = Color.Brown;
      }
      usernameField = new TextField();
      var format = new TextFormat('Fredoka One', 12, color);
      usernameField.defaultTextFormat = format;
      usernameField.width = 250 + paddingX - 30;
      usernameField.text = username + ':';
      usernameField.x = 15;
      usernameField.y = 15;
    }

    Shape back = new Shape();
    back.x = 0;
    back.y = 0;
    back.graphics
        .rectRound(0, 0, 250 + paddingX, text.height + 30 + paddingY, 8, 8);
    back.graphics.fillColor(Color.White);

    Shape nubbin = new Shape();
    nubbin.x = back.width / 2 + 10;
    nubbin.y = back.height - 10;
    nubbin.graphics.rectRound(-15, -15, 30, 30, 3, 3);
    nubbin.graphics.fillColor(Color.White);
    nubbin.rotation = 45;

    addChild(back);
    addChild(nubbin);
    addChild(text);
    if (username != null) {
      addChild(usernameField);
    }

    filters.add(new DropShadowFilter(3, 1.5708, 0x33000000, 3, 3));
    applyCache(-10, -10, width + 20, height + 40);
    pivotX = width / 2;
    pivotY = height;
    scaleX = 0;
    scaleY = 0;
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
