import 'package:flutter_jd_cps/flutter_jd_cps_method_channel.dart';
import 'package:flutter_jd_cps/flutter_jd_cps_platform_interface.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final FlutterJdCpsPlatform initialPlatform = FlutterJdCpsPlatform.instance;

  test('$MethodChannelFlutterJdCps is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterJdCps>());
  });

  test('getPlatformVersion', () async {});
}
