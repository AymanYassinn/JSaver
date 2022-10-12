package com.jucodes.jsaver

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.util.Log
import androidx.documentfile.provider.DocumentFile
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import java.io.FileOutputStream
import kotlin.collections.ArrayList


private const val SAVE_FILE = 2022
private const val SAVE_FILE_LIST = 2023
class JFileProvider(private val activity: Activity) : PluginRegistry.ActivityResultListener   {
    private var result: MethodChannel.Result? = null
    private var bytes: ByteArray? = null
    private var dataListO: List<Map<String,Any>>? = null
    private lateinit var fileNam: String
    private val tagT = "JSaver Activity"
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        try {
            return if (requestCode == SAVE_FILE &&  resultCode == Activity.RESULT_OK && data?.data != null) {
                val zed = data.data
                Log.e(tagT, zed.toString())
                createFile(zed!!)
                true
            } else if (requestCode == SAVE_FILE_LIST &&  resultCode == Activity.RESULT_OK && data?.data != null){
                val zed = data.data
                activity.contentResolver
                    .takePersistableUriPermission(
                        zed!!,
                        Intent.FLAG_GRANT_READ_URI_PERMISSION
                                or Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
                createFilesList(zed)
                true
            }else{
                false
            }
        }catch (e:IllegalArgumentException){
            Log.e(tagT, e.toString())
            return  false
        } catch (e:SecurityException){
            Log.e(tagT, e.toString())
            return  false
        }catch (e:Exception){
            Log.e(tagT, e.toString())
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

    fun openListFileManager(dListA: List<Map<String, Any>>, result: MethodChannel.Result){
        this.result = result
        this.dataListO = dListA
        val intent = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            Intent(Intent.ACTION_OPEN_DOCUMENT_TREE)
        } else {
            Intent(Intent.ACTION_OPEN_DOCUMENT)
        }
        activity.startActivityForResult(intent, SAVE_FILE_LIST)
    }

    private fun createFilesList(treeUriN:Uri){
        val resultList: ArrayList<String> = ArrayList()
        try{
            val split = treeUriN.path.toString().split(":".toRegex()).toTypedArray()
            if(dataListO!= null){
                if(dataListO!!.isNotEmpty()){
                    for(i in dataListO!!){
                        val io = i["01"]
                        val io2 = i["02"]
                        val createdFile = getDocumentFile(io.toString(),treeUriN)
                        if(createdFile != null){
                            val lastFile = createFile3(createdFile.uri,io2 as ByteArray)
                            if(lastFile != null){
                                resultList.add(split[1]+"/"+io)
                            }
                        }
                    }
                }
            }
            result?.success(resultList)
        }catch (e: Exception){
            resultList.add(e.toString())
            result?.success(resultList)
        }
    }
    private fun createFile3(uri: Uri, byt:ByteArray): Uri? {
        try {
            val pfd =  activity.contentResolver.openFileDescriptor(uri,  "w")
            if (pfd != null) {
                val fileOutputStream = FileOutputStream(pfd.fileDescriptor)
                fileOutputStream.write(byt)
                fileOutputStream.close()
                pfd.close()
                return uri
            }
        } catch (_: Exception) {

        }
        return  null
    }

    private fun getDocumentFile(
        path: String,
        rootUri: Uri,
    ): DocumentFile? {
        return try {
            val fileB: DocumentFile? = DocumentFile.fromTreeUri(activity, rootUri)
            fileB?.createFile(getFileType(path),path)
        }catch (e:Exception){
            null
        }

    }
    private fun getFileType(filePath: String): String {
        return when (filePath.substring(filePath.lastIndexOf(".") +1)) {
            "3gp" -> "video/3gpp"
            "torrent" -> "application/x-bittorrent"
            "kml" -> "application/vnd.google-earth.kml+xml"
            "gpx" -> "application/gpx+xml"
            "apk" -> "application/vnd.android.package-archive"
            "asf" -> "video/x-ms-asf"
            "avi" -> "video/x-msvideo"
            "bin", "class", "exe" -> "application/octet-stream"
            "bmp" -> "image/bmp"
            "c" -> "text/plain"
            "conf" -> "text/plain"
            "cpp" -> "text/plain"
            "doc" -> "application/msword"
            "docx" -> "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
            "xls", "csv" -> "application/vnd.ms-excel"
            "xlsx" -> "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
            "gif" -> "image/gif"
            "gtar" -> "application/x-gtar"
            "gz" -> "application/x-gzip"
            "h" -> "text/plain"
            "htm" -> "text/html"
            "html" -> "text/html"
            "jar" -> "application/java-archive"
            "java" -> "text/plain"
            "jpeg" -> "image/jpeg"
            "jpg" -> "image/jpeg"
            "js" -> "application/x-javascript"
            "log" -> "text/plain"
            "m3u" -> "audio/x-mpegurl"
            "m4a" -> "audio/mp4a-latm"
            "m4b" -> "audio/mp4a-latm"
            "m4p" -> "audio/mp4a-latm"
            "m4u" -> "video/vnd.mpegurl"
            "m4v" -> "video/x-m4v"
            "mov" -> "video/quicktime"
            "mp2" -> "audio/x-mpeg"
            "mp3" -> "audio/x-mpeg"
            "mp4" -> "video/mp4"
            "mpc" -> "application/vnd.mpohun.certificate"
            "mpe" -> "video/mpeg"
            "mpeg" -> "video/mpeg"
            "mpg" -> "video/mpeg"
            "mpg4" -> "video/mp4"
            "mpga" -> "audio/mpeg"
            "msg" -> "application/vnd.ms-outlook"
            "ogg" -> "audio/ogg"
            "pdf" -> "application/pdf"
            "png" -> "image/png"
            "pps" -> "application/vnd.ms-powerpoint"
            "ppt" -> "application/vnd.ms-powerpoint"
            "pptx" -> "application/vnd.openxmlformats-officedocument.presentationml.presentation"
            "prop" -> "text/plain"
            "rc" -> "text/plain"
            "rmvb" -> "audio/x-pn-realaudio"
            "rtf" -> "application/rtf"
            "sh" -> "text/plain"
            "tar" -> "application/x-tar"
            "tgz" -> "application/x-compressed"
            "txt" -> "text/plain"
            "wav" -> "audio/x-wav"
            "wma" -> "audio/x-ms-wma"
            "wmv" -> "audio/x-ms-wmv"
            "wps" -> "application/vnd.ms-works"
            "xml" -> "text/plain"
            "z" -> "application/x-compress"
            "zip" -> "application/x-zip-compressed"
            else -> "*/*"
        }
    }
}