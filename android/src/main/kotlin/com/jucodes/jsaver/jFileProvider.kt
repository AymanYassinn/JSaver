package com.jucodes.jsaver

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.util.Log
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import java.io.FileOutputStream


private const val SAVE_FILE = 2022
class JFileProvider(private val activity: Activity) : PluginRegistry.ActivityResultListener  {
    private var result: MethodChannel.Result? = null
    private var bytes: ByteArray? = null
    private lateinit var fileNam: String

    private val tagT = "JSaver Activity"


    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        try {
            return if (requestCode == SAVE_FILE &&  resultCode == Activity.RESULT_OK && data?.data != null) {
                val zed = data.data
                createFile(zed!!)
                true
            }else{
                false
            }
        }catch (e:IllegalArgumentException){
            Log.d(tagT, e.toString())
            return  false
        } catch (e:SecurityException){
            Log.d(tagT, e.toString())
            return  false
        }catch (e:Exception){
            Log.d(tagT, e.toString())
            return  false
        }

    }

    private fun createFile(uri: Uri) {
        try {
            val pfd =  activity.contentResolver.openFileDescriptor(uri,  "w")
            if (pfd != null) {
                val fileOutputStream = FileOutputStream(pfd.fileDescriptor)
                fileOutputStream.write(bytes)
                fileOutputStream.close()
                pfd.close()
                result?.success(uri.path)
            }
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }


    fun openFileManager(
        fileName: String,
        bytes: ByteArray?,
        result: MethodChannel.Result,
    ) {
        this.result = result
        this.bytes = bytes
        this.fileNam = fileName

        val intent = Intent(Intent.ACTION_CREATE_DOCUMENT)
        intent.type = "*/*"
        intent.addCategory(Intent.CATEGORY_OPENABLE)
        intent.putExtra(Intent.EXTRA_TITLE , fileName)
        intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION
                and Intent.FLAG_GRANT_WRITE_URI_PERMISSION
                or Intent.FLAG_GRANT_PERSISTABLE_URI_PERMISSION)
        activity.startActivityForResult(intent, SAVE_FILE)
    }
}