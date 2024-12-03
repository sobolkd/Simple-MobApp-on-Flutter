package com.example.flashlight_plugin

import android.content.Context
import android.hardware.camera2.CameraAccessException
import android.hardware.camera2.CameraManager
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class FlashlightPlugin: FlutterPlugin, MethodCallHandler {
    private lateinit var channel : MethodChannel
    private lateinit var cameraManager: CameraManager
    private lateinit var cameraId: String

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "flashlight_plugin")
        channel.setMethodCallHandler(this)
        cameraManager = flutterPluginBinding.applicationContext.getSystemService(Context.CAMERA_SERVICE) as CameraManager
        try {
            cameraId = cameraManager.cameraIdList[0]
        } catch (e: CameraAccessException) {
            e.printStackTrace()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "turnOn" -> {
                try {
                    cameraManager.setTorchMode(cameraId, true)
                    result.success(null)
                } catch (e: CameraAccessException) {
                    result.error("UNAVAILABLE", "Camera is unavailable", null)
                }
            }
            "turnOff" -> {
                try {
                    cameraManager.setTorchMode(cameraId, false)
                    result.success(null)
                } catch (e: CameraAccessException) {
                    result.error("UNAVAILABLE", "Camera is unavailable", null)
                }
            }
            else -> result.notImplemented()
        }
    }
}
