plugins {
    kotlin("jvm") version "1.4.10"
    id("com.google.cloud.tools.jib") version "2.6.0"

    id("org.springframework.boot") version "2.2.7.RELEASE"
    id("io.spring.dependency-management") version "1.0.9.RELEASE"
    kotlin("plugin.spring") version "1.3.72"
}


repositories {
    mavenCentral()
}

dependencies {
    implementation(kotlin("stdlib"))

    implementation("org.springframework.boot:spring-boot-starter")
    implementation("org.springframework.boot:spring-boot-starter-web")
    implementation("org.springframework.boot:spring-boot-starter-data-redis")
    implementation("com.fasterxml.jackson.module:jackson-module-kotlin:2.11.3")
    implementation("com.fasterxml.jackson.datatype:jackson-datatype-jsr310:2.6.1")
}

jib {
    from {
        image ="openjdk:alpine"
    }
    to {
        image = "pleymo/${project.name}"
        tags = setOf("latest", "${project.version}")
    }
}
