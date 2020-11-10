package org.developer.elbetasal.movies

import org.springframework.beans.factory.annotation.Value
import org.springframework.boot.SpringApplication
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController

@SpringBootApplication
class MovieApp


fun main(args: Array<String>) {
    SpringApplication.run(MovieApp::class.java, *args)
}

@RestController
@RequestMapping("/health")
class HealthController {

    @GetMapping
    fun ok() = "OK"

}

@RestController
@RequestMapping("/")
class RestController {

    @GetMapping
    fun hello() = "Hello"

}
