class MiniCommandOption {
  final String name;
  final String? description;
  final Iterable<String>? allowed;
  final String? defaultsTo;
  final String? valueHelp;

  MiniCommandOption({
    required this.name,
    this.description,
    this.allowed,
    this.defaultsTo,
    this.valueHelp,
  });
}
