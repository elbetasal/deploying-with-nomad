package org.developer.elbetasal.movies

import org.springframework.stereotype.Component

@Component
class MovieRepository {

    private val movies = mutableSetOf<Movie>()

    fun findAll() = movies

    fun findById(id: String): Movie? = movies.find { it.productId == id }

    fun createMovie(movie: Movie) = movies.add(movie)

}
