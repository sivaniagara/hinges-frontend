plugins {
    id("com.android.application")
    id("com.google.gms.google-services")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

// ✅ Your Facebook credentials (PUT REAL VALUES HERE)
val facebookAppId = "1503898344766011"
val facebookClientToken = "3059a358c8d679e81f0d9d19fc82d757"
val facebookLoginProtocolScheme = "fb$facebookAppId"

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

    defaultConfig {
        applicationId = "com.example.hinges_frontend"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // ✅ THIS FIXES YOUR ERROR
        manifestPlaceholders["facebookAppId"] = facebookAppId
        manifestPlaceholders["facebookClientToken"] = facebookClientToken
        manifestPlaceholders["facebookLoginProtocolScheme"] = facebookLoginProtocolScheme
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}