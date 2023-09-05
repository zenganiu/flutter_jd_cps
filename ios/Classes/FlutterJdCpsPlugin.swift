import Flutter
import JDKeplerSDK
import UIKit

public class FlutterJdCpsPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "flutter_jd_cps", binaryMessenger: registrar.messenger())
        let instance = FlutterJdCpsPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    var rootViewController: UIViewController {
        if let rootVC = UIApplication.shared.windows.first?.rootViewController {
            return rootVC
        }
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            return rootVC
        }
        return UIViewController()
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "getPlatformVersion":
            result("iOS " + UIDevice.current.systemVersion)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // 初始化
    public func initJD(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let appkey = call.getString(key: "appkey")
        let appSecret = call.getString(key: "appSecret")

        KeplerApiManager.sharedKPService().asyncInitSdk(appkey, secretKey: appSecret) {
            debugPrint("JDKeplerSDK 初始化成功")
            let dict: Dictionary = ["code": "00000", "message": "JDKeplerSDK初始化成功"]
            result(dict)
        } failedCallback: { error in
            let msg = "JDKeplerSDK 初始化失败: \(error.debugDescription)"
            debugPrint(msg)
            let dict: Dictionary = ["code": "99999", "message": msg]
            result(dict)
        }
    }

    public func openUrl(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let url = call.getString(key: "url")
        KeplerApiManager.sharedKPService().isOpenByH5 = false
        KeplerApiManager.sharedKPService().openKeplerPage(withURL: url, sourceController: rootViewController, jumpType: 1, userInfo: [:])
        let dict: Dictionary = ["code": "00000", "message": "openKeplerPage已调用"]
        result(dict)
    }
}

// 随便定义一个数组，如果等于他就是空
private let EmptyNum: NSNumber = NSNumber(integerLiteral: 5285)
fileprivate extension FlutterMethodCall {
    func getString(key: String) -> String {
        guard let result = (arguments as? Dictionary<String, Any>)?[key] as? String else {
            return ""
        }
        return result
    }

    func getNumber(key: String) -> NSNumber {
        guard let result = (arguments as? Dictionary<String, Any>)?[key] as? NSNumber else {
            return EmptyNum
        }
        return result
    }

    func getBool(key: String) -> Bool {
        guard let result = (arguments as? Dictionary<String, Any>)?[key] as? Bool else {
            return false
        }
        return result
    }

    func getDict(key: String) -> Dictionary<String, Any>? {
        guard let result = (arguments as? Dictionary<String, Any>)?[key] as? Dictionary<String, Any> else {
            return nil
        }
        return result
    }
}
