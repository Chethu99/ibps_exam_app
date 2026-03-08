buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Parentheses and double quotes are mandatory in .kts files
        classpath("com.android.tools.build:gradle:8.1.0")
        classpath("com.google.gms:google-services:4.3.15")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.8.22")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

rootProject.layout.buildDirectory.set(rootProject.projectDir.parentFile.resolve("build"))

subprojects {
    project.layout.buildDirectory.set(rootProject.layout.buildDirectory.get().asFile.resolve(project.name))
}

subprojects {
    evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}