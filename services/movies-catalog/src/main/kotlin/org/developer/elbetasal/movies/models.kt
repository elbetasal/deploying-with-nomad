package org.developer.elbetasal.movies

import com.fasterxml.jackson.annotation.JsonIgnoreProperties
import java.time.Instant

@JsonIgnoreProperties(ignoreUnknown = true)
data class Movie(val productId: String,
                 val title: String,
                 val releaseYear: Int,
                 val createdBy: String,
                 val createdAt: Instant = Instant.now()
)
