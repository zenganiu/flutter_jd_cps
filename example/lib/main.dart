import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_jd_cps/flutter_jd_cps.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  final _flutterJdCpsPlugin = FlutterJdCps();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _flutterJdCpsPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Center(child: Text('Running on: $_platformVersion\n')),
              Center(
                child: OutlinedButton(
                  onPressed: () async {
                    final result = await _flutterJdCpsPlugin.initJD(
                      appKey: "760e9fa49765a185f06812d7454abdeb",
                      appSecret: "b4220bcc0286402487534cf94ae7c8ea",
                    );
                    debugPrint(result.toString());
                  },
                  child: const Text('初始化'),
                ),
              ),
              Center(
                child: OutlinedButton(
                  onPressed: () async {
                    final result = await _flutterJdCpsPlugin.openUrl("https://u.jd.com/TLp0MTT");
                    debugPrint(result.toString());
                  },
                  child: const Text('打开链接'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
