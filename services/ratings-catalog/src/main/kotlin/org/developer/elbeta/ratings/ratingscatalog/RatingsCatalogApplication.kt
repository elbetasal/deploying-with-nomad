package org.developer.elbeta.ratings.ratingscatalog

import org.springframework.boot.SpringApplication
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.cloud.client.discovery.EnableDiscoveryClient

@SpringBootApplication
@EnableDiscoveryClient
class RatingsCatalogApplication

fun main(args: Array<String>) {
	SpringApplication.run(RatingsCatalogApplication::class.java,*args)
}
