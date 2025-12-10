buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Classpath untuk Android Gradle Plugin
        classpath("com.android.tools.build:gradle:8.1.0") 
        // Classpath untuk Kotlin Plugin
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.10") 
        
        // Classpath untuk Google Services/Firebase (Sekarang sudah bisa di-resolve)
        classpath("com.google.gms:google-services:4.4.1")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Logika kustom untuk mengatur build directory
val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}