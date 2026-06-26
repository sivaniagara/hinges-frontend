import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// ✅ Load keystore properties
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

// ✅ Facebook credentials
//val facebookAppId = "1503898344766011"
//val facebookClientToken = "3059a358c8d679e81f0d9d19fc82d757"
//val facebookLoginProtocolScheme = "fb$facebookAppId"

android {
    namespace = "com.example.hinges_frontend"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    // ✅ Signing config defined BEFORE buildTypes
    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    defaultConfig {
        applicationId = "com.hingesgames.app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

//        manifestPlaceholders["facebookAppId"] = facebookAppId
//        manifestPlaceholders["facebookClientToken"] = facebookClientToken
//        manifestPlaceholders["facebookLoginProtocolScheme"] = facebookLoginProtocolScheme
    }

    buildTypes {
        release {
            // ✅ Now uses real release signing, not debug
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false  // set true if you want code shrinking
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
//    implementation("com.facebook.android:facebook-android-sdk:latest.release")
//    implementation("com.facebook.android:facebook-login:latest.release")
}