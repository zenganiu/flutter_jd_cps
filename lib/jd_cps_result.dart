import 'package:flutter/foundation.dart';

@immutable
class JdCpsResult {
  final String code;
  final String message;

  bool get isSucceed => code == '00000';

  const JdCpsResult({
    required this.code,
    required this.message,
  });

  factory JdCpsResult.fromJson(dynamic js) {
    var code = '99999';
    var msg = '';
    if (js is Map) {
      if (js['code'] is String) {
        code = js['code'];
      }
      if (js['message'] is String) {
        msg = js['message'];
      }
    }
    return JdCpsResult(code: code, message: msg);
  }

  @override
  String toString() {
    return 'JdCpsResult{code: $code, message: $message}';
  }
}
