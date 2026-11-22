package id.fanajalh.absensi_pkl

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

class MainActivity : FlutterActivity() {
    companion object {
        private const val UPDATER_CHANNEL = "id.fanajalh.absensi_pkl/updater"
    }

    private var pendingApkPath: String? = null

    override fun onResume() {
        super.onResume()
        val waitingPath = pendingApkPath
        if (!waitingPath.isNullOrBlank()) {
            val allowed = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                packageManager.canRequestPackageInstalls()
            } else {
                true
            }
            if (allowed) {
                pendingApkPath = null
                launchApkInstaller(File(waitingPath))
            }
        }
    }

    private fun launchApkInstaller(apkFile: File) {
        val apkUri = FileProvider.getUriForFile(
            this,
            "$packageName.fileprovider",
            apkFile
        )
        val installIntent = Intent(Intent.ACTION_VIEW).apply {
            setDataAndType(apkUri, "application/vnd.android.package-archive")
            addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
            putExtra(Intent.EXTRA_NOT_UNKNOWN_SOURCE, true)
        }
        startActivity(installIntent)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            UPDATER_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "canInstallPackages" -> {
                    val allowed = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        packageManager.canRequestPackageInstalls()
                    } else {
                        true
                    }
                    result.success(allowed)
                }

                "openInstallPermissionSettings" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        val intent = Intent(
                            Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES,
                            Uri.parse("package:$packageName")
                        ).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        startActivity(intent)
                    }
                    result.success(true)
                }

                "installApk" -> {
                    val filePath = call.argument<String>("filePath")
                    if (filePath.isNullOrBlank()) {
                        result.error("INVALID_ARGS", "Path file APK kosong.", null)
                        return@setMethodCallHandler
                    }
                    val apkFile = File(filePath)
                    if (!apkFile.exists() || apkFile.length() < 100_000L) {
                        result.error(
                            "FILE_NOT_FOUND",
                            "File APK tidak ditemukan atau belum lengkap.",
                            null
                        )
                        return@setMethodCallHandler
                    }

                    val allowed = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        packageManager.canRequestPackageInstalls()
                    } else {
                        true
                    }

                    if (!allowed && Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        pendingApkPath = apkFile.absolutePath
                        val permIntent = Intent(
                            Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES,
                            Uri.parse("package:$packageName")
                        ).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        startActivity(permIntent)
                        result.success(true)
                        return@setMethodCallHandler
                    }

                    try {
                        pendingApkPath = null
                        launchApkInstaller(apkFile)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error(
                            "INSTALL_FAILED",
                            e.localizedMessage ?: "Gagal membuka installer APK.",
                            null
                        )
                    }
                }

                "updateHomeWidget" -> {
                    val streak = call.argument<String>("streak") ?: "🔥 15 Hari Streak"
                    val badge = call.argument<String>("badge") ?: "📍 Valid"
                    val title = call.argument<String>("title") ?: "Streak Absen Aman!"
                    val subtitle = call.argument<String>("subtitle")
                        ?: "Sen ✓ · Sel ✓ · Rab ✓ · Kam ✓ · Jum ★"
                    val cta = call.argument<String>("cta") ?: "📷 Absen"
                    AbsensiDuolingoWidgetProvider.saveAndRefresh(
                        applicationContext,
                        streak = streak,
                        badge = badge,
                        title = title,
                        subtitle = subtitle,
                        cta = cta
                    )
                    result.success(true)
                }

                "requestPinHomeWidget" -> {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        val manager = AppWidgetManager.getInstance(applicationContext)
                        if (manager.isRequestPinAppWidgetSupported) {
                            val provider = ComponentName(
                                applicationContext,
                                AbsensiDuolingoWidgetProvider::class.java
                            )
                            val pinned = manager.requestPinAppWidget(provider, null, null)
                            result.success(pinned)
                            return@setMethodCallHandler
                        }
                    }
                    result.success(false)
                }

                else -> result.notImplemented()
            }
        }
    }
}
