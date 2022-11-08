package com.jucodes.jsaver

import android.app.Activity
import android.content.Context.MODE_PRIVATE
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.os.Build
import android.provider.DocumentsContract.EXTRA_INITIAL_URI
import androidx.documentfile.provider.DocumentFile
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.ActivityResultListener
import io.flutter.util.PathUtils
import java.io.BufferedInputStream
import java.io.BufferedOutputStream
import java.io.File
import java.util.*
import org.json.JSONObject
import java.net.URLDecoder

private const val SAVER_MAIN = 2022
private const val SET_DEFAULT_PATH = 2023
private const val SET_ACCESS_TO_PATH = 2024
private const val SHARED_BOX = "JSaverBox"
private const val DIR_BOX = "DIRECTORIES"
private const val DIR_MAIN = "MAIN_DIR"
private const val DE_STORAGE3 = "content://com.android.externalstorage.documents/tree/"
data class FilesModel(val fName : String, val fPath: String){
    private fun toMap(): Map<String, Any> {
        return mapOf("01" to fName, "02" to fPath)
    }
    override fun toString(): String {
        return JSONObject(toMap()).toString()
    }
}
class JSaverProvider(private val activity: Activity) : ActivityResultListener  {
    private var jSharedPref: SharedPreferences = activity.getSharedPreferences(SHARED_BOX, MODE_PRIVATE)
    private var jResult: Result? = null
    private var jDataList: List<Map<String,Any>>? = null
    private var jCleanCache = false
    /**
     * @param requestCode The integer request code originally supplied to `startActivityForResult()`, allowing you to identify who this result came from.
     * @param resultCode The integer result code returned by the child activity through its `setResult()`.
     * @param data An Intent, which can return result data to the caller (various data can be
     * attached to Intent "extras").
     * @return true if the result has been handled.
     */
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
       try {
           if(resultCode == Activity.RESULT_OK && data?.data != null){
               val zed = data.data
               activity.contentResolver
                   .takePersistableUriPermission(
                       zed!!,
                       Intent.FLAG_GRANT_READ_URI_PERMISSION
                               or Intent.FLAG_GRANT_WRITE_URI_PERMISSION)
               addAccessToDirectory(zed)
               when (requestCode) {
                   SAVER_MAIN -> {
                       saverMainMethod(zed.toString())
                       return true
                   }
                   SET_DEFAULT_PATH -> {
                       addDefaultDirectory(zed)
                       jResult?.success(FilesModel("DefaultDirectory", getPathFromUri(zed.encodedPath.toString())).toString())
                       return  true
                   }
                   SET_ACCESS_TO_PATH -> {
                       jResult?.success(FilesModel("AccessedToPath", getPathFromUri(zed.encodedPath.toString())).toString())
                       return  true
                   }
               }
               return  true
           }else{
               return  false
           }

       }catch (e:IllegalStateException){
           return false
       }catch (e:IllegalArgumentException){
           return  false
       } catch (e:SecurityException){
           return  false
       }catch (e:Exception){
           return  false
       }
    }

//GET ACCESS
fun setDefaultDirectory(result: Result){
    this.jResult = result
    startActivityHome(SET_DEFAULT_PATH)
}
fun clearCacheDirectory(result: Result, fCDefault:Boolean = false, fCAccessed: Boolean = false, fCCache:Boolean = true){
    this.jResult = result
    var fCl = ""
    var fCl0 = ""
    var fCl1 = ""
    if(fCDefault){
       jSharedPref.edit().remove(DIR_MAIN).apply()
        fCl = "Default,"
    }
    if(fCAccessed){
       jSharedPref.edit().remove(DIR_BOX).apply()
        fCl0 = "Accessed,"
    }
    if(fCCache){
       clearLCacheDirectory()
        fCl1 = "Cache"

    }
val fCl2 = "$fCl$fCl0$fCl1 Cleaned Successfully"
    jResult?.success(fCl2)
}
fun setAccessToDirectory(result: Result){
        this.jResult = result
    startActivityHome(SET_ACCESS_TO_PATH)
    }
fun getDefaultDirectory(result: Result){
    this.jResult = result
    val fDefaultDirectory = jSharedPref.getString(DIR_MAIN,"")
    if(fDefaultDirectory != null && fDefaultDirectory.isNotEmpty()){
        val fM = FilesModel("DefaultDirectory", getPathFromUri(Uri.parse(fDefaultDirectory).encodedPath.toString()))
        jResult?.success(fM.toString())
    }else{
        val fM = FilesModel("DefaultDirectory", "No Default Directory")
        jResult?.success(fM.toString())
    }
    }
fun getCacheDirectory(result: Result) {
    this.jResult = result
    jResult?.success(activity.cacheDir.path)
    }
fun getApplicationDirs(result: Result) {
        this.jResult = result
    val vv = PathUtils.getDataDirectory(activity)
        jResult?.success(vv)
    }
fun getAccessedDirectories(result: Result) {
    this.jResult = result
    val codedList: ArrayList<String> = ArrayList()
    try {

        val accessedD = jSharedPref.getStringSet(DIR_BOX, HashSet())
        if(accessedD != null && accessedD.isNotEmpty()){
            for(i in accessedD){
                val fTU =getPathFromUri(Uri.parse(i).encodedPath.toString())
                val fM = FilesModel("AccessedFolder", fTU)
                codedList.add(fM.toString())
            }
        }else{
            val fM = FilesModel("AccessedDirectories", "No Accessed Directories")
            codedList.add(fM.toString())
        }
        jResult?.success(codedList)
    }catch (e:Exception){
        val fM = FilesModel("Exception", e.toString())
        codedList.add(fM.toString())
        jResult?.success(codedList)
    }
    }
private fun addAccessToDirectory(uri: Uri): String {
        try {
            val set= jSharedPref.getStringSet(DIR_BOX,HashSet())
            val sh = jSharedPref.edit()
            val set2 : MutableSet<String> = HashSet()
            if(set != null){
                if(set.isNotEmpty()){
                    set2.addAll(set)
                    set2.add(uri.toString())
                }else{
                    set2.add(uri.toString())
                }
            }else{
                set2.add(uri.toString())
            }
            sh.putStringSet(DIR_BOX, set2)
            sh.apply()
            return uri.toString()
        }catch (e:Exception){
            return e.toString()
        }
    }
private fun addDefaultDirectory(uri: Uri): String? {
        val sh = jSharedPref.edit()
        sh.putString(DIR_MAIN, uri.toString())
        sh.apply()
        return jSharedPref.getString(DIR_MAIN, "")
    }
//SAVE MAIN
fun saveMain(fFilesModelList: List<Map<String, Any>>, fDefaultPath:String, fCleanCache:Boolean,result: Result){
    this.jResult = result
    this.jDataList = fFilesModelList
    this.jCleanCache = fCleanCache
    val fDirectoryCh = checkFileDirectory(fDefaultPath)
    if(fDirectoryCh.isEmpty()){
        var filePath = ""
        if(fDefaultPath.isNotEmpty()){
         val file = File(fDefaultPath)
            filePath = if(file.exists() && file.isDirectory){
                file.absolutePath
            }else{
                file.mkdirs()
                file.absolutePath
            }

  }
        startActivityHome(SAVER_MAIN, filePath)
    }else{
        saverMainMethod(fDirectoryCh)
    }
}
// Start Activity
private fun startActivityHome(requestCodeHome: Int, fFileP: String = ""){
    val intent = Intent(Intent.ACTION_OPEN_DOCUMENT_TREE)
    if(fFileP.isNotEmpty()){
       val fileU =  getFileTreeUri(fFileP)
        if(fileU != null){
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                intent.putExtra(EXTRA_INITIAL_URI, fileU)
            }
        }

    }
    activity.startActivityForResult(intent, requestCodeHome)
    }
//FILES METHODS PRIVATE
private fun writeFileBytesFromUri(fTargetUri: Uri, fSourceUri:Uri): Uri? {
    try {
        val inP = BufferedInputStream(activity.contentResolver.openInputStream(fSourceUri))
        val bytes = BufferedOutputStream(activity.contentResolver.openOutputStream(fTargetUri,"w"))
        var read: Int
        val bufferSize = 1024
        val buffers = ByteArray(bufferSize)
        while (inP.read(buffers).also { read = it } != -1) {
            bytes.write(buffers, 0, read)
        }
        inP.close()
        bytes.close()
        return  fTargetUri
    } catch (_: Exception) {

    }
    return  null
}
private fun saverMainMethod(fTargetDir:String) {
    val errorList: ArrayList<String> = ArrayList()
   try {
       if(jDataList.isNullOrEmpty()){
           errorList.add(FilesModel("SourceData", "SourceData Is Empty").toString())
       }else{
           val fTargetUri = documentFromTree(Uri.parse(fTargetDir))
           if(fTargetUri != null) {
               val successList = subSaverMain(fTargetUri, jDataList!!)
               if(successList.isNotEmpty()){
                   for(i in successList){
                       val fM = FilesModel(getFileName(i), i)
                       errorList.add(fM.toString())
                   }
               }else{
                   errorList.add(FilesModel("SuccessList", "SuccessList Is Empty").toString())

               }
           }else{
               startActivityHome(SAVER_MAIN)
           }
       }
       if(jCleanCache){
           clearLCacheDirectory()
       }
       jResult?.success(errorList)
   }catch (e:Exception){
       errorList.add(FilesModel("Exception", e.toString()).toString())
       jResult?.success(errorList)
   }
}
private fun subSaverMain(fTargetUri: Uri,fDataList:List<Map<String,Any>> ): ArrayList<String> {
    val errorList: ArrayList<String> = ArrayList()
    for(i in fDataList){
        val fPath = i["02"].toString()
        if(fPath.isNotEmpty()){
            val fName = getFileName(fPath)
            val fSource = DocumentFile.fromFile(File(fPath))
            if(fSource.exists()){
                val fCreated = createDocumentFileFromUri(fName,fTargetUri)
                if(fCreated != null){
                    val fLastFile = writeFileBytesFromUri(fCreated.uri,fSource.uri)
                    if(fLastFile != null){
                        val fTUU = getPathFromUri(fLastFile.encodedPath.toString())
                        errorList.add(fTUU)
                    }else{
                        errorList.add("Couldn't Write $fName Check Your Storage")
                    }
                }else{
                    errorList.add("Couldn't Create $fName Check Permission")
                }
            }else{
                errorList.add("File $fName Not Exist In Source")
            }
        }else{
            errorList.add("Empty Source Element")
        }
    }
    return errorList
}
private fun getPathFromUri(fFileRPath:String): String {
    val fTCheck = URLDecoder.decode(fFileRPath,"Utf8").split("/tree/")
    var fTU = ""
    if(fTCheck.size >1){
        val fN = fTCheck[1]
        if(fN.isNotEmpty()){
             fTU = if(fN.contains("primary:")){
                 fN.replace("primary:","/storage/emulated/0/" )
            }else{
                "/storage/"+fN.replace(":","/")
            }
        }
    }
    val fTU2 =  if(fTU.contains("document/")){
        fTU.split("document/")[1]
    }else{
        fTU
    }
    return fTU2
}
private fun documentFromTree(fTargetParentUri:Uri): Uri? {
  try{
      val fTargetFromTree =  DocumentFile.fromTreeUri(activity, fTargetParentUri)
      if(fTargetFromTree!= null && fTargetFromTree.exists()){
          if(fTargetFromTree.canRead() && fTargetFromTree.canWrite()){
              return  fTargetFromTree.uri
          }
      }
      return null
  }catch (e:SecurityException){
      return null
  }catch (e:Exception){
      return null
  }

}
private fun createDocumentFileFromUri(path: String, rootUri: Uri): DocumentFile? {
        return try {
            val fileB: DocumentFile? = DocumentFile.fromTreeUri(activity, rootUri)
            fileB?.createFile(getFileType(path),path)
        }catch (e:Exception){
            null
        }

    }
private fun checkFileDirectory(fDir: String): String {
        if(fDir.isNotEmpty()){
            if(fDir.startsWith("content:")){
                val fDir2 = DocumentFile.fromTreeUri(activity,Uri.parse(fDir))
                if(fDir2!= null){
                    if(fDir2.canRead() && fDir2.canWrite()){
                        return fDir2.uri.toString()
                    }
                }

            }else{
                val fVolume = getStorageJVolumes()
                var fTU31 = ""
                if(fVolume.isNotEmpty()){
                    for(i in fVolume){
                        val fTU = if(i.contains("emulated")){
                            "primary%3A"
                        }else if (i.contains("storage")){
                            i.split("storage/")[1]+"%3A"
                        }else{
                            "primary%3A"
                        }
                        val fTP2 = fDir.replace(i,"")
                        val fTP3 = if(fTP2.startsWith("/")){
                            fTP2.substring(1)
                        }else{
                            fTP2
                        }
                        val fTP4 = fTP3.replace("/", "%2F")
                        val fTU2 = "$DE_STORAGE3$fTU$fTP4"
                        val fDir2 = documentFromTree(Uri.parse(fTU2))
                        if(fDir2!= null){
                            fTU31 = fDir2.toString()
                        }
                    }
                    if(fTU31.isNotEmpty()){
                       return fTU31
                    }

                }
            }

        }
        return ""
    }
private fun getFileTreeUri(filePath: String):Uri?{
    val fVolume = getStorageJVolumes()
    var fTU31 : Uri?= null
   if(filePath.isNotEmpty()){
       var fTU15 = ""
       if(fVolume.isNotEmpty()){
           for(i in fVolume){
               var fTU: String
               if(i.contains(filePath.split("/")[1])){
                   fTU = if(i.contains("emulated")){
                       "primary%3A"
                   }else if (i.contains("storage")){
                       i.split("storage/")[1]+"%3A"
                   }else{
                       "primary%3A"
                   }
                   val fTP2 = filePath.replace(i,"")
                   val fTP3 = if(fTP2.startsWith("/")){
                       fTP2.substring(1)
                   }else{
                       fTP2
                   }
                   val fTP4 = fTP3.replace("/", "%2F").replace(" ", "%20")
                   fTU15 = "$DE_STORAGE3$fTU$fTP4/document/$fTU$fTP4"

               }
           }
          fTU31 = Uri.parse(fTU15)
       }
       return fTU31
   }else{
       return  null
   }
}
private fun getFileName(filePath: String):String{
    return if(filePath.isNotEmpty()){
        filePath.substring(filePath.lastIndexOf("/".toRegex().toString()) +1)
    }else{
        ""
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
private fun getStorageJVolumes(): ArrayList<String> {
        val volumes: ArrayList<String> = ArrayList()
        val vv = activity.getExternalFilesDirs("")
        for(i in vv){
            val iPa = i.absolutePath.split("/Android")[0]
            volumes.add(iPa)
        }
        return volumes
    }
// Directories Private
fun getLDefaultDirectory():String?{
    return jSharedPref.getString(DIR_MAIN,"")
}
private fun clearLCacheDirectory(): String {
    return try{
        activity.cacheDir.deleteRecursively()
        "Application Cache Cleaned"
    }catch (e:Exception){
        e.toString()
    }

}
}