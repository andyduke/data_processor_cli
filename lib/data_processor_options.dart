import 'package:data_processor/options/csv/input.dart';
import 'package:data_processor/options/csv/output.dart';
import 'package:data_processor/options/tsv/input.dart';
import 'package:data_processor/options/tsv/output.dart';

class DataProcessorOptions {
  final InputCSVOptions inputCSV;
  final OutputCSVOptions outputCSV;
  final InputTSVOptions inputTSV;
  final OutputTSVOptions outputTSV;

  const DataProcessorOptions({
    this.inputCSV = const InputCSVOptions(),
    this.outputCSV = const OutputCSVOptions(),
    this.inputTSV = const InputTSVOptions(),
    this.outputTSV = const OutputTSVOptions(),
  });
}
