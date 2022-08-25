package com.jucodes.jsaver

import androidx.annotation.NonNull
import io.flutter.Log

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** JSaverPlugin */
class JSaverPlugin: FlutterPlugin, ActivityAware, MethodCallHandler {
  private var jFileProvider: JFileProvider? = null
  private var activity: ActivityPluginBinding? = null
  private var pluginBinding: FlutterPlugin.FlutterPluginBinding? = null

  private var result: Result? = null
  private val tag: String = "JSaver"
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    pluginBinding = flutterPluginBinding
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "JSAVER")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (jFileProvider == null) {
      initJFileProvider()
    }
    try {
      this.result = result
      if (call.method == "SaveFile") {
          val name = call.argument<String>("name")
          val data = call.argument<ByteArray>("data")
          jFileProvider!!.openFileManager(name!! , data, result)
      } else {
        result.notImplemented()
      }
    }  catch (e: Exception) {
      Log.d(tag,  e.message.toString())
    }

  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    pluginBinding = null
    if(jFileProvider!=null) {
      activity?.removeActivityResultListener(jFileProvider!!)
      jFileProvider = null
    }
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.activity = binding
  }

  override fun onDetachedFromActivityForConfigChanges() {
    if (jFileProvider != null) {
      activity?.removeActivityResultListener(jFileProvider!!)
      jFileProvider = null
    }
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {

    this.activity = binding
  }

  override fun onDetachedFromActivity() {
    if (jFileProvider != null) {
      activity?.removeActivityResultListener(jFileProvider!!)
      jFileProvider = null
    }
    activity = null
  }
  private fun initJFileProvider(): Boolean {
    var jProvider: JFileProvider? = null
    if (activity != null) {
      jProvider = JFileProvider(
        activity = activity!!.activity
      )
      activity!!.addActivityResultListener(jProvider)
    } else {
      if (result != null)
        result?.error("NullActivity", "Activity was Null", null)
    }
    this.jFileProvider = jProvider
    return jProvider != null
  }
}
