import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

// Load keystore properties
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {

    namespace = "com.aditya.cookapp"
    compileSdk = 36
    ndkVersion = "28.2.13676358"


    buildFeatures {
        prefab = false
    }


    defaultConfig {

        applicationId = "com.aditya.cookapp"

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode
        versionName = flutter.versionName

        multiDexEnabled = true
    }

    // Signing configuration
    signingConfigs {

        create("release") {

            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String

            storeFile = keystoreProperties["storeFile"]?.let { file(it) }

            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    // Build types
    buildTypes {

        release {

            isMinifyEnabled = false
            isShrinkResources = false

            // Fix for strip debug symbols error
            ndk {
                debugSymbolLevel = "SYMBOL_TABLE"
            }

            signingConfig = signingConfigs.getByName("release")
        }

        debug {

            // Use release signing to avoid NDK strip errors
            signingConfig = signingConfigs.getByName("release")
        }
    }

    // Fix JNI packaging issues
    packaging {

        jniLibs {

            useLegacyPackaging = true
        }
    }

    // Java compatibility
    compileOptions {

        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8

        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {

        jvmTarget = "1.8"
    }
}

// Flutter config
flutter {

    source = "../.."
}

// Dependencies
dependencies {

    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
}
