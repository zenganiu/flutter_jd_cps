import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_jd_cps_platform_interface.dart';

/// An implementation of [FlutterJdCpsPlatform] that uses method channels.
class MethodChannelFlutterJdCps extends FlutterJdCpsPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_jd_cps');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<Map<dynamic, dynamic>> initJD({required String appKey, required String appSecret}) async {
    final result = await methodChannel.invokeMapMethod("initJD", {"appKey": appKey, 'appSecret': appSecret});
    return result ?? {};
  }

  @override
  Future<Map<dynamic, dynamic>> openUrl(String url) async {
    final result = await methodChannel.invokeMapMethod("openUrl", {"url": url});
    return result ?? {};
  }
}
