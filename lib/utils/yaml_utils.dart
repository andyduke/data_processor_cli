import 'package:yaml/yaml.dart';

/*
extension YamlMapConverter on YamlMap {
  dynamic _convertNode(dynamic v) {
    if (v is YamlMap) {
      // ignore: unnecessary_cast
      return (v as YamlMap).toMap();
    } else if (v is YamlList) {
      var list = <dynamic>[];
      for (var e in v) {
        list.add(_convertNode(e));
      }
      return list;
    } else {
      return v;
    }
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    nodes.forEach((k, v) {
      map[(k as YamlScalar).value.toString()] = _convertNode(v.value);
    });
    return map;
  }
}
*/

extension YamlNodeConverter on YamlNode {
  dynamic _convertNode(dynamic v) {
    if (v is YamlMap) {
      return v._toMap();
    } else if (v is YamlList) {
      return v._toList();
    } else {
      return v;
    }
  }

  dynamic toDynamic() {
    return _convertNode(this);
  }

  List _toList() {
    var list = <dynamic>[];
    var l = (this as YamlList);
    for (var e in l) {
      list.add(_convertNode(e));
    }
    return list;
  }

  Map<String, dynamic> _toMap() {
    var map = <String, dynamic>{};
    (this as YamlMap).nodes.forEach((k, v) {
      map[(k as YamlScalar).value.toString()] = _convertNode(v.value);
    });
    return map;
  }
}
