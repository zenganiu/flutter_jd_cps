package com.hm.dmcb.flutter_jd_cps;

import android.app.Application;
import android.content.Context;
import android.os.Handler;
import android.widget.Toast;

import androidx.annotation.NonNull;

import com.jd.kepler.res.ApkResources;
import com.kepler.jd.Listener.AsyncInitListener;
import com.kepler.jd.Listener.OpenAppAction;
import com.kepler.jd.Listener.OpenSchemeCallback;
import com.kepler.jd.login.KeplerApiManager;
import com.kepler.jd.sdk.bean.KelperTask;
import com.kepler.jd.sdk.bean.KeplerAttachParameter;

import org.json.JSONException;

import java.util.HashMap;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/**
 * FlutterJdCpsPlugin
 */
public class FlutterJdCpsPlugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context mContext;

    // 存储第三方传入参数
    private final KeplerAttachParameter mKeplerAttachParameter = new KeplerAttachParameter();
    KelperTask mKHelperTask;
    Handler mHandler = new Handler();

    private Result mResult;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_jd_cps");
        channel.setMethodCallHandler(this);
        mContext = flutterPluginBinding.getApplicationContext();
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("initJD")) {
            initJDSDK(call, result);
        } else if (call.method.equals("openUrl")) {
            openUrl(call, result);
        } else {
            result.notImplemented();
        }
    }

    /**
     * 初始化 京东 SDK
     */
    private void initJDSDK(@NonNull MethodCall call, @NonNull Result result) {
        String appKey = call.argument("appkey");
        String appSecret = call.argument("appSecret");
        KeplerApiManager.asyncInitSdk((Application) mContext,
                appKey,
                appSecret,
                "",
                () -> "",
                new AsyncInitListener() {
                    @Override
                    public void onSuccess() {
                        Map<String, Object> map = new HashMap<>();
                        map.put("code", "00000");
                        map.put("message", "KeplerSDK初始化成功");
                        result.success(map);
                    }

                    @Override
                    public void onFailure() {
                        Map<String, Object> map = new HashMap<>();
                        map.put("code", "99999");
                        map.put("message", "KeplerSDK初始化失败");
                        result.success(map);
                    }
                });
    }

    // 打开商品页
    private void openUrl(@NonNull MethodCall call, @NonNull Result result) {
        final String url = call.argument("url");
        mResult = result;
        try {
            mKHelperTask = KeplerApiManager.getWebViewService().openAppWebViewPage(mContext,
                    url,
                    mKeplerAttachParameter,
                    mOpenAppAction,
                    0, new OpenSchemeCallback() {
                        @Override
                        public void callback(String content) {

                        }
                    });
        } catch (JSONException exception) {
            exception.printStackTrace();
        }

    }

    OpenAppAction mOpenAppAction = (status, url) -> mHandler.post(() -> {
        if (status == OpenAppAction.OpenAppAction_result_NoJDAPP) {
            makeText("您未安装京东app，你可以手动打开以下链接地址：" + url + " ,code=" + status);
            if (mResult != null) {
                mResult.success(url);
            }
        } else if (status == OpenAppAction.OpenAppAction_result_BlackUrl) {
            makeText("url不在白名单，你可以手动打开以下链接地址：" + url + " ,code=" + status);
            if (mResult != null) {
                mResult.success(url);
            }
        } else if (status == OpenAppAction.OpenAppAction_result_ErrorScheme) {
            makeText("呼起协议异常" + " ,code=" + status);
        } else if (status == OpenAppAction.OpenAppAction_result_NetError) {
            makeText(ApkResources.getSingleton().getString("kepler_check_net") + " ,code=" + status + " ,url=" + url);
        }
    });

    private void makeText(String msg) {
        Toast.makeText(mContext, msg, Toast.LENGTH_SHORT).show();
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }
}
