package org.developer.elbeta.ratings.ratingscatalog

import org.springframework.stereotype.Component

@Component
class RatingsRepository {
    private val ratings = listOf<Ratings>()

    fun findAll() = ratings
    fun findByUserId(userId: String) = ratings.find { it.userId == userId }
    fun findByMovieId(movieId: String) = ratings.filter { it.productId == movieId }


}
