// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class UsageException implements Exception {
  static const String defaultHeadingTail = '\n\n';

  final String? heading;
  final String headingTail;
  final String message;
  final String usage;

  UsageException({
    required this.message,
    required this.usage,
    this.heading,
    this.headingTail = defaultHeadingTail,
  });

  @override
  String toString() => ((heading != null) ? '$heading$headingTail' : '') + 'Error: $message\n\n$usage';
}
