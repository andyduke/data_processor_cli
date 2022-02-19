import 'package:data_processor/options/csv/input.dart';
import 'package:data_processor/options/csv/output.dart';

class DataProcessorOptions {
  final InputCSVOptions inputCSV;
  final OutputCSVOptions outputCSV;

  const DataProcessorOptions({
    this.inputCSV = const InputCSVOptions(),
    this.outputCSV = const OutputCSVOptions(),
  });
}
