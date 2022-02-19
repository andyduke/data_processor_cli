// Credits to initCommerce https://github.com/initCommerce/gato
class MapPath {
  /// Get value from a `Map` by path
  ///
  /// Use dot notation in [path] to access nessted keys
  ///
  /// Use [convertor] to cast the valeu to your custom type
  ///
  /// Returns [T?]
  ///
  /// ```dart
  /// Map map = {'a': {'b': 1}};
  /// MapPath.get(map, 'a.b');
  /// ```
  static T? get<T>(Map<String, dynamic> map, String path, {T Function(dynamic)? converter}) {
    List<String> keys = path.split('.');

    if (map[keys[0]] == null) {
      return null;
    }

    if (keys.length == 1) {
      return converter != null ? converter(map[keys[0]]) : map[keys[0]] as T;
    }

    return MapPath.get(map[keys.removeAt(0)], keys.join('.'));
  }

  /// Sets the value at path of map.
  ///
  /// Use dot notation in [path] to access nessted keys
  ///
  /// Returns updated map
  ///
  /// ```dart
  /// Map map = {'a': {'b': 1}};
  /// map = MapPath.set(map, 'a.b', 2);
  /// ```
  static Map<String, dynamic> set<T>(
    Map<String, dynamic>? map,
    String path,
    T value,
  ) {
    List<String> keys = path.split('.');

    if (keys.length == 1) {
      return Map<String, dynamic>.from({
        ...map ?? {},
        keys.removeAt(0): value,
      });
    }

    return Map<String, dynamic>.from({
      ...map ?? {},
      keys[0]: MapPath.set(map![keys.removeAt(0)] ?? {}, keys.join('.'), value),
    });
  }

  /// Removes the property at path of map.
  ///
  /// Use dot notation in [path] to access nessted keys
  ///
  /// Returns updated map
  ///
  /// ```dart
  /// Map map = {'a': {'b': 1}, 'c': 2};
  /// map = MapPath.unset(map, 'c'); // {'a': {'b': 1}}
  /// ```
  static Map<String, dynamic> unset(Map<String, dynamic>? map, String path) {
    List<String> keys = path.split('.');

    if (keys.length == 1) {
      map!.remove(keys.removeAt(0));

      return map;
    }

    return Map<String, dynamic>.from({
      ...map ?? {},
      keys[0]: MapPath.unset(map![keys.removeAt(0)] ?? {}, keys.join('.')),
    });
  }
}
