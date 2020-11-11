package org.developer.elbetasal.movies

import org.springframework.data.redis.core.RedisTemplate
import org.springframework.stereotype.Component

@Component
class MovieRepository(private val redisTemplate: RedisTemplate<String, Movie>) {

    fun findAll() = redisTemplate.keys("*").map {
        println(it)
        redisTemplate.opsForValue().get(it)
    }

    fun findById(id: String): Movie? = redisTemplate.opsForValue().get(id)

    fun createMovie(movie: Movie) = redisTemplate.opsForValue().set(movie.productId, movie)
}
