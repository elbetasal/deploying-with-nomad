package org.developer.elbeta.ratings.ratingscatalog

import org.springframework.beans.factory.annotation.Autowired
import org.springframework.boot.SpringApplication
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.cloud.client.discovery.EnableDiscoveryClient
import org.springframework.cloud.client.loadbalancer.LoadBalanced
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.client.RestTemplate
import org.springframework.web.client.getForEntity

@SpringBootApplication
@EnableDiscoveryClient
class RatingsCatalogApplication

fun main(args: Array<String>) {
	SpringApplication.run(RatingsCatalogApplication::class.java,*args)
}

@Configuration
class RestConfiguration {

	@Bean
	@LoadBalanced
	fun restTemplate() = RestTemplate()

}

@RestController
@RequestMapping("/health")
class HealthController {
	@GetMapping
	fun health() = "OK"

}

@RestController
@RequestMapping("/")
class RestController {

	@Autowired
	lateinit var restTemplate: RestTemplate

	@GetMapping
	fun call(): String {
		val response = restTemplate.getForEntity("http://movies-catalog/", String::class.java)
		return response.body?.let { "Hello $it" }?: "No value"

	}

}
