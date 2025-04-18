plugins {
    // this is necessary to avoid the plugins to be loaded multiple times
    // in each subproject's classloader
    alias(libs.plugins.androidApplication) apply false
    alias(libs.plugins.androidLibrary) apply false
    alias(libs.plugins.composeMultiplatform) apply false
    alias(libs.plugins.composeCompiler) apply false
    alias(libs.plugins.kotlinMultiplatform) apply false

//    alias(libs.plugins.vanniktech.mavenPublish) apply false
//    alias(libs.plugins.ktlint)
}

//subprojects {
//    apply(plugin = "org.jlleitschuh.gradle.ktlint") // Version should be inherited from parent
//
//    configure<org.jlleitschuh.gradle.ktlint.KtlintExtension> {
//        debug.set(true)
//        verbose.set(true)
//        android.set(true)
//        outputToConsole.set(true)
//        outputColorName.set("RED") // Change terminal output color
//        ignoreFailures.set(false) // Set to true to avoid build failures
//        filter {
//            exclude("**/generated/**")
//            include("**/kotlin/**")
//        }
//    }
//}
