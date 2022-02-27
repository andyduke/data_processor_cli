import 'package:args/args.dart';

typedef MiniCommandRunner = void Function(Map<String, String> values);

class MiniCommand {
  final String name;
  final String? description;
  final MiniCommandRunner runner;

  MiniCommand({
    required this.name,
    this.description,
    required this.runner,
  });

  void run(Map<String, String> values) {
    runner.call(values);
  }

  void addFlag(ArgParser parser) {
    parser.addFlag(
      name,
      help: description,
      negatable: false,
    );
  }
}
