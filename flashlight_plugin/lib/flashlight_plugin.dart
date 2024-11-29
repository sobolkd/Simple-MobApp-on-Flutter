import 'package:flutter/services.dart';

class FlashlightPlugin {
  static const MethodChannel _channel = MethodChannel('flashlight_plugin');

  static Future<String?> getPlatformVersion() async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<void> turnOn() async {
    await _channel.invokeMethod('turnOn');
  }

  static Future<void> turnOff() async {
    await _channel.invokeMethod('turnOff');
  }

  static Future<void> toggleFlashlight(bool isOn) async {
    if (isOn) {
      await turnOn();
    } else {
      await turnOff();
    }
  }
}
