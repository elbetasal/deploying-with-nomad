package org.developer.elbetasal.movies

import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestBody
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.RestController
import org.springframework.web.client.HttpClientErrorException
import org.springframework.web.servlet.function.ServerRequest

@RestController
@RequestMapping("/")
class MovieController(private val repository: MovieRepository) {

    @GetMapping("health")
    fun health() = "OK"

    @GetMapping
    fun findMovies() = repository.findAll()

    @GetMapping("/{id}")
    fun findMovieById(@PathVariable id: String) = repository.findById(id)?: throw ResourceNotFoundException(id)

    @PostMapping
    fun createMovie(@RequestBody movie: Movie) {
        repository.createMovie(movie)
    }

}

