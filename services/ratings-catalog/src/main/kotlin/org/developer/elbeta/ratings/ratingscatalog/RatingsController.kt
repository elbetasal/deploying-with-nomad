package org.developer.elbeta.ratings.ratingscatalog

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.client.RestTemplate

@RestController
@RequestMapping("/")
class RatingsController(
    private val restTemplate: RestTemplate,
    private val ratingsRepository: RatingsRepository
) {

    @GetMapping("health")
    fun health() = "OK"

    @GetMapping
    fun findAll() = ratingsRepository.findAll()

    @GetMapping("user/{id}")
    fun findRatingsByUserId(@PathVariable id: String) = ratingsRepository.findByUserId(id)

    @GetMapping("movie/{movieId}")
    fun findRatingsByMovieId(@PathVariable movieId: String): Recommendation {
        val movie = restTemplate
            .getForEntity("http://movies-catalog/$movieId", Movie::class.java)
            .body?.let {
                it
            }?: throw ResourceNotFoundException(movieId)

        val ratings = ratingsRepository.findByMovieId(movieId)
        return Recommendation(movie, ratings)
    }

}
