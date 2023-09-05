import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_jd_cps_method_channel.dart';
import 'jd_cps_result.dart';

abstract class FlutterJdCpsPlatform extends PlatformInterface {
  /// Constructs a FlutterJdCpsPlatform.
  FlutterJdCpsPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterJdCpsPlatform _instance = MethodChannelFlutterJdCps();

  /// The default instance of [FlutterJdCpsPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterJdCps].
  static FlutterJdCpsPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterJdCpsPlatform] when
  /// they register themselves.
  static set instance(FlutterJdCpsPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<Map<dynamic, dynamic>> initJD({required String appKey, required String appSecret}) async {
    throw UnimplementedError('initJD() has not been implemented.');
  }

  Future<Map<dynamic, dynamic>> openUrl(String url) async {
    throw UnimplementedError('openUrl() has not been implemented.');
  }
}
