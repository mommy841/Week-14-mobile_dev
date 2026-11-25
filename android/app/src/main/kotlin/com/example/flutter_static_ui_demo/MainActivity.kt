package com.example.flutter_static_ui_demo

import android.app.Activity
import android.content.Intent
import java.io.File
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val photoPickerChannel = "boring_app/photo_picker"
    private val photoPickerRequestCode = 501
    private var pendingPhotoResult: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, photoPickerChannel)
            .setMethodCallHandler { call, result ->
                if (call.method != "pickPhoto") {
                    result.notImplemented()
                } else if (pendingPhotoResult != null) {
                    result.error("PICKER_BUSY", "A photo picker is already open.", null)
                } else {
                    pendingPhotoResult = result
                    val intent = Intent(Intent.ACTION_GET_CONTENT).apply {
                        type = "image/*"
                        addCategory(Intent.CATEGORY_OPENABLE)
                    }
                    startActivityForResult(
                        Intent.createChooser(intent, "Choose a photo"),
                        photoPickerRequestCode,
                    )
                }
            }
    }

    @Suppress("DEPRECATION")
    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != photoPickerRequestCode) return

        val result = pendingPhotoResult ?: return
        pendingPhotoResult = null
        val uri = data?.data
        if (resultCode != Activity.RESULT_OK || uri == null) {
            result.success(null)
            return
        }

        try {
            val extension = contentResolver.getType(uri)
                ?.substringAfter('/')
                ?.substringBefore('+')
                ?.replace(Regex("[^A-Za-z0-9]"), "")
                ?.takeIf { it.isNotEmpty() } ?: "jpg"
            val cachedPhoto = File(cacheDir, "post_${System.currentTimeMillis()}.$extension")
            val input = contentResolver.openInputStream(uri)
                ?: throw IllegalStateException("Could not read the selected photo.")
            input.use { photoStream ->
                cachedPhoto.outputStream().use { output -> photoStream.copyTo(output) }
            }
            result.success(cachedPhoto.absolutePath)
        } catch (error: Exception) {
            result.error("PHOTO_READ_FAILED", error.message, null)
        }
    }
}
