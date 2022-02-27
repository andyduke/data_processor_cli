import 'package:args/args.dart';
import 'package:data_processor/commands/command.dart';
import 'package:data_processor/commands/option.dart';

class MiniCommands {
  final List<MiniCommand> commands;
  final List<MiniCommandOption>? options;

  MiniCommands({
    required this.commands,
    this.options,
  });

  bool run(ArgResults arguments) {
    MiniCommand? command;
    for (var _command in commands) {
      if (arguments.wasParsed(_command.name)) {
        command = _command;
        break;
      }
    }

    if (command != null) {
      final commandOptions = <String, String>{};
      if (options != null) {
        for (var option in options!) {
          if (arguments.wasParsed(option.name)) {
            commandOptions[option.name] = arguments[option.name];
          }
        }
      }

      command.run(commandOptions);
      return true;
    } else {
      return false;
    }
  }

  void addOptions(ArgParser parser) {
    for (var command in commands) {
      command.addFlag(parser);
    }
    if (options != null) {
      for (var option in options!) {
        parser.addOption(
          option.name,
          help: option.description,
          allowed: option.allowed,
          defaultsTo: option.defaultsTo,
          valueHelp: option.valueHelp,
        );
      }
    }
  }
}
