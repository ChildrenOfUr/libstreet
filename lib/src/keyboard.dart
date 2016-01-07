part of libstreet;

abstract class Keyboard {
  static List<int> _pressedKeys = [];
  static List _memory = [];
  static bool active = true;
  static bool started = false;

  /// returns a list of the last [number] keypresses.
  static List<int> last(int number) {
    List last = [];
    last.addAll(
      _memory.getRange(_memory.length - 1 - number, _memory.length - 1)
      .toList().reversed);
    return last;
  }

  static bool pressed(int) {

    return _pressedKeys.contains(int);
  }

  static init() {
    if (started == false) {
      html.document.onKeyDown.listen((html.KeyboardEvent e) {
        if (!_pressedKeys.contains(e.keyCode) && active) {
          _pressedKeys.add(e.keyCode);
        }
      });
      html.document.onKeyUp.listen((html.KeyboardEvent e) {
        if (_pressedKeys.contains(e.keyCode)) {
          _pressedKeys.remove(e.keyCode);
          _memory.add(e.keyCode);
          // keep last 10 keystrokes;
          if (_memory.length > 10) {
            _memory.removeAt(0);
          }
        }
      });
      started = true;
    }
  }

}
