library commander;

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


demo() {
  // default functions must be registered before a Node is created.
  CommandNode.DEFAULT_FUNCTIONS['print'] = print;

  // This Command Node is assembled from the 'cup' map.
  CommandNode tree = new CommandNode(cup);

  // A List of Strings represents the current state of a parent object.
  List bools = [
    'full'
  ];

  print(tree);

  // should 'drink' from the cup and drain it.
  tree.activate(bools);
  // should be unable to drink, since the cup is empty.
  tree.activate(bools);
}


class CommandNode {
  static Map<String, Function> DEFAULT_FUNCTIONS = {};
  Map<String, Function> functions = {};
  int depth;

  Map <String, String> commands = {};
  List<CommandNode> children = [];
  Map< String, List <CommandNode> > checks = {};
  Map< String, bool> sets = {};

  Map _tree;
  CommandNode(this._tree, [this.depth = 0]) {
    DEFAULT_FUNCTIONS.forEach((String key, Function fun) {
      functions[key] = fun;
    });

    _tree.forEach((String key, var value) {
      if (key == 'if') {
        for (String check in _tree['if'].keys) {
          checks[check] = [
            new CommandNode(_tree['if'][check], depth + 1),
            new CommandNode(_tree['else'], depth + 1)
          ];
        }
      } else if(key == 'else') {
        // dealt with above.
      } else if (key == 'children') {
        for (Map child in _tree['children']) {
          children.add(new CommandNode(child, depth + 1));
        }
      } else if(key == 'set') {
        for (String toSet in _tree['set'].keys) {
          sets[toSet] = _tree['set'][toSet];
        }
      } else  {
        commands[key] = value;
      }
    });
  }

  activate(List<String> bools) {
    for (String toSet in sets.keys) {
      if (sets[toSet] == true && !bools.contains(toSet)) {
        bools.add(toSet);
      } else if (sets[toSet] == false && bools.contains(toSet)) {
        bools.remove(toSet);
      }
    }

    for (String check in checks.keys) {
      if (bools.contains(check)) {
        checks[check][0].activate(bools);
      } else {
        checks[check][1].activate(bools);
      }
    }

    for (String command in commands.keys) {
      if (!functions.containsKey(command)) {
        throw('Function "$command" not in functions Map!');
      }
      functions[command](commands[command]);
    }

    for (CommandNode node in children) {
      node.activate(bools);
    }
  }

  @override
  String toString() {
    String string = '';
    String prefix = '';
    for (int i=0 ; i <= depth ; i++) {
      prefix+=' ';
    }

    for (String toSet in sets.keys) {
        string += '${prefix}SET "$toSet": ${sets[toSet]}\n';
    }

    for (String command in commands.keys) {
      string += '$prefix$command: ${commands[command]}\n';
    }

    for (String check in checks.keys) {
        string += '${prefix}IF "$check"\n';
        string += checks[check][0].toString();
        string += '${prefix}ELSE\n';
        string += checks[check][1].toString();
    }

    for (CommandNode node in children) {
        string += node.toString();
    }

    return string;
  }
}
