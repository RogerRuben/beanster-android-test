plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "com.beanstersips.v11"
    compileSdk = 35

    defaultConfig {
        applicationId = "com.beanstersips.v11"
        minSdk = 26
        targetSdk = 35
        versionCode = 41
        versionName = "17.8-ci"
    }

    buildTypes {
        debug { isDebuggable = true }
        release { isMinifyEnabled = false }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions { jvmTarget = "17" }

    packaging {
        jniLibs { useLegacyPackaging = true }
        resources { excludes += setOf("META-INF/AL2.0", "META-INF/LGPL2.1") }
    }
}

dependencies {
    implementation("dev.ffmpegkit-maintained:tesseract-android:5.5.0")
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.10.2")
}
