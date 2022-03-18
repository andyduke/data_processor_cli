import 'package:data_processor/data_processor_app.dart';

void main(List<String> arguments) {
  try {
    final app = DataProcessorApp(arguments);
    app.run();
  } on Exception catch (exception) {
    print('$exception');
  }
}
