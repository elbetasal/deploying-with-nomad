import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
	kotlin("jvm") version "1.4.10"
	id("org.springframework.boot") version "2.2.7.RELEASE"
	id("io.spring.dependency-management") version "1.0.9.RELEASE"
	id("com.google.cloud.tools.jib") version "2.6.0"
	kotlin("plugin.spring") version "1.3.72"
}

group = "org.developer.elbeta.ratings"

repositories {
	mavenCentral()
}

extra["springCloudVersion"] = "Hoxton.SR9"

dependencies {
	implementation(kotlin("stdlib"))

//	implementation("org.springframework.cloud:spring-cloud-starter-consul-config")
	implementation("org.springframework.cloud:spring-cloud-starter-consul-discovery")
	implementation("org.springframework.boot:spring-boot-starter-web")
}

dependencyManagement {
	imports {
		mavenBom("org.springframework.cloud:spring-cloud-dependencies:${property("springCloudVersion")}")
	}
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
