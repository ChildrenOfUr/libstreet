library commander;
import 'dart:async';

Map cup =  {
  "if" : {
    "full": {
      "set": {
        "full": false
      },
      "print": "I drank some water."
    },
  },
  "else": {
    "print": "This cup is empty!"
  }
};

//TODO
// delay and waitForFlag tokens

demo() {
  // default functions must be registered before a Node is created.
  CommandNode.DEFAULT_FUNCTIONS['print'] = print;

  // This Command Node is assembled from the 'cup' map.
  CommandNode tree = new CommandNode(cup);

  // A List of Strings represents the current state of a parent object.
  List flags = [
    'full'
  ];

  print(tree);

  // should 'drink' from the cup and drain it.
  tree.activate(flags);
  // should be unable to drink, since the cup is empty.
  tree.activate(flags);
}


class CommandNode {
  static Map<String, Function> DEFAULT_FUNCTIONS = {};
  Map<String, Function> functions = {};
  int depth;

  int delay = 0;
  List <String> waitFlags = [];
  Map <String, String> commands = {};
  List<CommandNode> children = [];
  Map< String, List <CommandNode> > checks = {};
  Map< String, bool> sets = {};

  Map _tree;
  CommandNode(this._tree, [this.depth = 0, this.functions]) {
    DEFAULT_FUNCTIONS.forEach((String key, Function fun) {
      functions[key] = fun;
    });

    _tree.forEach((String key, var value) {
      if (key == 'if') {
        for (String check in _tree['if'].keys) {
          checks[check] = [
            new CommandNode(_tree['if'][check], depth + 1, functions),
            new CommandNode(_tree['else'], depth + 1, functions)
          ];
        }
      } else if(key == 'else') {
        // dealt with above.
      } else if (key == 'children') {
        for (Map child in _tree['children']) {
          children.add(new CommandNode(child, depth + 1, functions));
        }
      } else if(key == 'set') {
        for (String toSet in _tree['set'].keys) {
          sets[toSet] = _tree['set'][toSet];
        }
      } else if(key == "when") {
        for (String flag in _tree['wait']) {
          waitFlags.add(flag);
        }
      } else if(key == "wait") {
        delay = _tree['wait'];
      } else  {
        commands[key] = value;
      }
    });
  }

  activate(List<String> flags) async {
    await new Future.delayed(new Duration(milliseconds: delay));

    bool ready = true;
    for (String flag in flags) {
      if (!flags.contains(flag)) {
        ready = false;
        break;
      }
    }
    if (ready != true) {
      await new Future.delayed(new Duration(seconds: 1));
      await activate(flags);
      return;
    }


    for (String toSet in sets.keys) {
      if (sets[toSet] == true && !flags.contains(toSet)) {
        flags.add(toSet);
      } else if (sets[toSet] == false && flags.contains(toSet)) {
        flags.remove(toSet);
      }
    }

    for (CommandNode node in children) {
      await node.activate(flags);
    }

    for (String check in checks.keys) {
      if (flags.contains(check)) {
        await checks[check][0].activate(flags);
      } else {
        await checks[check][1].activate(flags);
      }
    }

    for (String command in commands.keys) {
      if (!functions.containsKey(command)) {
        throw('Function "$command" not in functions Map!');
      }
      functions[command](commands[command]);
    }
  }

  @override
  String toString() {
    String string = '';
    String prefix = '';
    for (int i=0 ; i <= depth ; i++) {
      prefix+='  ';
    }

    string += '$prefix[$runtimeType]\n';

    if (delay != 0) {
      string += '${prefix} WAIT: $delay\n';
    }

    for (String toSet in sets.keys) {
        string += '${prefix} SET "$toSet": ${sets[toSet]}\n';
    }

    for (String command in commands.keys) {
      string += '$prefix- $command: ${commands[command]}\n';
    }

    for (String check in checks.keys) {
        string += '${prefix} IF "$check"\n';
        string += checks[check][0].toString();
        string += '${prefix} ELSE\n';
        string += checks[check][1].toString();
    }

    for (CommandNode node in children) {
        string += '$prefix\\\n' + node.toString();
    }

    return string;
  }
}
