import 'package:flutter/foundation.dart';

@immutable
class JdCpsResult {
  final String code;
  final String message;

  const JdCpsResult({
    required this.code,
    required this.message,
  });

  factory JdCpsResult.fromJson(dynamic js) {
    return const JdCpsResult(code: "", message: "");
  }

  @override
  String toString() {
    return 'JdCpsResult{code: $code, message: $message}';
  }
}
