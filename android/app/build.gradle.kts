import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

fun nonBlank(value: String?): String? = value?.trim()?.takeIf { it.isNotEmpty() }

val bundledKeystore = file("release-keystore.jks")
val ciStoreFile = nonBlank(System.getenv("KEYSTORE_PATH"))
    ?: nonBlank(keystoreProperties.getProperty("storeFile"))
    ?: if (bundledKeystore.exists()) bundledKeystore.absolutePath else null
val ciStorePassword = nonBlank(System.getenv("KEYSTORE_PASSWORD"))
    ?: nonBlank(keystoreProperties.getProperty("storePassword"))
    ?: "absensipkl2026"
val ciKeyAlias = nonBlank(System.getenv("KEY_ALIAS"))
    ?: nonBlank(keystoreProperties.getProperty("keyAlias"))
    ?: "absensipkl"
val ciKeyPassword = nonBlank(System.getenv("KEY_PASSWORD"))
    ?: nonBlank(keystoreProperties.getProperty("keyPassword"))
    ?: "absensipkl2026"

val hasReleaseKeystore = !ciStoreFile.isNullOrBlank() && file(ciStoreFile).exists()

val overrideVersionName = project.findProperty("appVersionName")?.toString()
val overrideVersionCode = project.findProperty("appVersionCode")?.toString()?.toIntOrNull()

android {
    namespace = "id.fanajalh.absensi_pkl"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "id.fanajalh.absensi_pkl"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = overrideVersionCode ?: flutter.versionCode
        versionName = overrideVersionName ?: flutter.versionName
    }

    signingConfigs {
        if (hasReleaseKeystore) {
            create("release") {
                storeFile = file(ciStoreFile!!)
                storePassword = ciStorePassword
                keyAlias = ciKeyAlias
                keyPassword = ciKeyPassword
            }
        }
    }

    buildTypes {
        release {
            signingConfig = if (hasReleaseKeystore) {
                signingConfigs.getByName("release")
            } else {
                signingConfigs.getByName("debug")
            }
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}
