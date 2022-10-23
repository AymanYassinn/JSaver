package com.jucodes.jsaver
import io.flutter.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** JSaverPlugin */
private const val TAG = "JSaverProvider"
class JSaverPlugin: FlutterPlugin, ActivityAware, MethodCallHandler {
  private var jSaverProvider: JSaverProvider? = null
  private var activity: ActivityPluginBinding? = null
  private var pluginBinding: FlutterPlugin.FlutterPluginBinding? = null

  private var result: Result? = null
  private lateinit var channel : MethodChannel

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    pluginBinding = flutterPluginBinding
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "JSAVER")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    if (jSaverProvider == null) {
      initJSaverProvider()
    }

    try {
      this.result = result
      when (call.method) {
        "ClearCache" -> {
          jSaverProvider!!.clearCacheDirectory(result)
        }
           "SetDefaultPath" -> {
            jSaverProvider!!.setDefaultDirectory(result)
          }
           "GetDefaultPath" -> {
           jSaverProvider!!.getDefaultDirectory(result)
          }
          "SaverMain" -> {
            val toDefault = call.argument<Boolean>("default")
            val cleanCache = call.argument<Boolean>("cleanCache")
            val toDirectory = call.argument<String>("directory")
            val dataList = call.argument<List<Map<String,Any>>>("dataList")
            var fDirectory = ""
            if(toDefault == true){
              val de = jSaverProvider!!.getLDefaultDirectory()
              if(de != null){
                fDirectory = de
              }
            }
            if(toDirectory != null && toDirectory.isNotEmpty()){
              fDirectory = toDirectory
            }
            jSaverProvider!!.saveMain(dataList!!,fDirectory,cleanCache!!,result)
          }
          "GetCashDirectory" -> {
            jSaverProvider!!.getCacheDirectory(result)
          }
          "SetAccessDirectory" -> {
          jSaverProvider!!.setAccessToDirectory(result)
          }
          "GetAccessedDirectories" -> {
          jSaverProvider!!.getAccessedDirectories(result)

          }
          else -> {
            result.notImplemented()
          }
      }
    }  catch (e: Exception) {
      Log.e(TAG, e.toString())
    }

  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    pluginBinding = null
    if(jSaverProvider!=null) {
      activity?.removeActivityResultListener(jSaverProvider!!)
      jSaverProvider = null
    }
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    this.activity = binding
  }

  override fun onDetachedFromActivityForConfigChanges() {
    if (jSaverProvider != null) {
      activity?.removeActivityResultListener(jSaverProvider!!)
      jSaverProvider = null
    }
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    this.activity = binding
  }

  override fun onDetachedFromActivity() {
    if (jSaverProvider != null) {
      activity?.removeActivityResultListener(jSaverProvider!!)
      jSaverProvider = null
    }
    activity = null
  }
  private fun initJSaverProvider(): Boolean {
    var jProvider: JSaverProvider? = null
    if (activity != null) {
      jProvider = JSaverProvider(
        activity = activity!!.activity
      )
      activity!!.addActivityResultListener(jProvider)
    } else {
      if (result != null)
        result?.error("NullActivity", "Activity was Null", null)
    }
    this.jSaverProvider = jProvider
    return jProvider != null
  }
}
