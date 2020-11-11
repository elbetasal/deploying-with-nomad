package org.developer.elbeta.ratings.ratingscatalog

import java.time.Instant

data class Ratings(
    val userId: String,
    val productId: String,
    val profileName: String,
    val helpfulness: String,
    val score: Int,
    val summary: String,
    val summaryText: String,
    val createdAt: Instant = Instant.now()
)

data class Movie(
    val productId: String,
    val title: String,
    val releaseYear: Int
)

data class Recommendation(val movie: Movie, val rating: List<Ratings>)
