package org.developer.elbetasal.movies

import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.SerializationFeature
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule
import com.fasterxml.jackson.module.kotlin.KotlinModule
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter

@Configuration
class Configuration {
    @Bean
    fun mappingJackson2HttpMessageConverter(): MappingJackson2HttpMessageConverter {
        return MappingJackson2HttpMessageConverter().apply {
            this.objectMapper = ObjectMapper().apply {
                registerModule(KotlinModule())
                registerModule(JavaTimeModule())
                configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false)
            }
        }
    }
}
