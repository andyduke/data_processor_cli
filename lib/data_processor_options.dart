import 'package:data_processor/options/csv/input.dart';
import 'package:data_processor/options/csv/output.dart';
import 'package:data_processor/options/toml/output.dart';

class DataProcessorOptions {
  final InputCSVOptions inputCSV;
  final OutputCSVOptions outputCSV;
  final OutputTomlOptions outputToml;

  const DataProcessorOptions({
    this.inputCSV = const InputCSVOptions(),
    this.outputCSV = const OutputCSVOptions(),
    this.outputToml = const OutputTomlOptions(),
  });
}
