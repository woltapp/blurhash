import com.vanniktech.maven.publish.SonatypeHost
import org.jetbrains.kotlin.gradle.ExperimentalKotlinGradlePluginApi
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

plugins {
    kotlin("plugin.allopen") version libs.versions.kotlin
    alias(libs.plugins.kotlinMultiplatform)
    alias(libs.plugins.kotlinxBenchmark)
    alias(libs.plugins.androidLibrary)
    alias(libs.plugins.kotlinxSerialization)
    alias(libs.plugins.vanniktech.mavenPublish)
}

group = "com.wolt.blurhashkt"
version = "1.0.0"

kotlin {
    jvm()
    androidTarget {
        publishLibraryVariants("release", "debug")
        @OptIn(ExperimentalKotlinGradlePluginApi::class)
        compilerOptions {
            jvmTarget.set(JvmTarget.JVM_11)
        }
    }
    macosX64()
    macosArm64()
    iosX64()
    iosArm64()
    iosSimulatorArm64()
//    mingwX64()
    linuxX64()
    linuxArm64()

    sourceSets {
        val commonMain by getting {
            dependencies {
                implementation(libs.kotlinx.benchmark.runtime)
                implementation(libs.kotlinx.serialization.core)
            }
        }
        val commonTest by getting {
            dependencies {
                implementation(libs.kotlin.test)
            }
        }
        val androidMain by getting {
            dependencies {
                implementation(libs.androidx.core.ktx)
            }
        }
        val androidInstrumentedTest by getting {
            dependencies {
                implementation(libs.androidx.test.runner)
                implementation(libs.androidx.test.junit)
            }
        }
    }
}

tasks.withType<Test> {
    useJUnitPlatform()

    // Enable verbose output
    testLogging {
        events("passed", "skipped", "failed")
        showExceptions = true
        showStandardStreams = true
        exceptionFormat = org.gradle.api.tasks.testing.logging.TestExceptionFormat.FULL
    }
}

android {
    namespace = "com.wolt.blurhashkt"
    compileSdk = libs.versions.android.compileSdk.get().toInt()
    defaultConfig {
        minSdk = libs.versions.android.minSdk.get().toInt()
        testInstrumentationRunner = "androidx.test.runner.AndroidJUnitRunner"
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
}

allOpen {
    // Required to ensure benchmark classes and methods are open
    annotation("org.openjdk.jmh.annotations.State")
}

benchmark {
    targets {
        register("jvm")
        register("android")
        register("macosX64")
        register("macosArm64")
        register("iosX64")
        register("iosArm64")
        register("iosSimulatorArm64")
        // register("mingwX64")
        register("linuxX64")
        register("linuxArm64")
    }
    configurations {
        named("main") {
            warmups = 1
            iterations = 1
            iterationTime = 1000
            iterationTimeUnit = "ms"
            outputTimeUnit = "ms"
        }
    } // TODO: Finalize any missing changes
}

mavenPublishing {
    publishToMavenCentral(SonatypeHost.CENTRAL_PORTAL)

    signAllPublications()

    coordinates(group.toString(), "library", version.toString())

    pom {
        name = "Thumbhash Kotlin"
        description = "A Kotlin implementation for Thumbhash."
        inceptionYear = "2025"
        url = "https://github.com/woltapp/blurhash"
        licenses {
            license {
                name = "MIT"
                url = "https://opensource.org/license/MIT/"
                distribution = "repo"
            }
        }
        developers {
//            developer {
//                id = ""
//                name = ""
//                url = ""
//            }
        }
        scm {
            url = "https://github.com/woltapp/blurhash"
            connection = "https://github.com/woltapp/blurhash.git"
            developerConnection = "https://github.com/woltapp/blurhash.git"
        }
    }
}
