library flutter_jd_cps;

import 'flutter_jd_cps_platform_interface.dart';
import 'jd_cps_result.dart';

export 'jd_cps_result.dart';

class FlutterJdCps {
  Future<String?> getPlatformVersion() {
    return FlutterJdCpsPlatform.instance.getPlatformVersion();
  }

  /// 初始化
  ///
  /// [appKey] appKey
  /// [appSecret] 秘钥
  Future<JdCpsResult> initJD({required String appKey, required String appSecret}) async {
    final js = FlutterJdCpsPlatform.instance.initJD(appKey: appKey, appSecret: appSecret);
    final data = JdCpsResult.fromJson(js);
    return data;
  }

  /// 开启京东商品页
  Future<JdCpsResult> openUrl(String url) async {
    final js = FlutterJdCpsPlatform.instance.openUrl(url);
    final data = JdCpsResult.fromJson(js);
    return data;
  }
}
