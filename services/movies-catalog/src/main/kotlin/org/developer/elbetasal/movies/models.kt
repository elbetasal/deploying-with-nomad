package org.developer.elbetasal.movies

import java.time.Instant

data class Movie(val productId: String,
                 val title: String,
                 val releaseYear: Int,
                 val createdBy: String,
                 val createdAt: Instant = Instant.now()
)
