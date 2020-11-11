package org.developer.elbetasal.movies

import com.fasterxml.jackson.databind.ObjectMapper
import com.fasterxml.jackson.databind.SerializationFeature
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule
import com.fasterxml.jackson.module.kotlin.KotlinModule
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.data.redis.connection.RedisConnectionFactory
import org.springframework.data.redis.core.RedisTemplate
import org.springframework.data.redis.serializer.Jackson2JsonRedisSerializer
import org.springframework.data.redis.serializer.StringRedisSerializer
import org.springframework.http.converter.json.MappingJackson2HttpMessageConverter


@Configuration
class Configuration {
    @Bean
    fun mappingJackson2HttpMessageConverter(): MappingJackson2HttpMessageConverter {
        return MappingJackson2HttpMessageConverter().apply {
            this.objectMapper = objectMapper()
        }
    }

    @Bean
    fun redisTemplate(connectionFactory: RedisConnectionFactory?): RedisTemplate<String, Movie>? {
        val template = RedisTemplate<String, Movie>()
        val jackson2JsonRedisSerializer = Jackson2JsonRedisSerializer(Movie::class.java).apply {
            setObjectMapper(objectMapper())
        }
        template.connectionFactory = connectionFactory
        template.valueSerializer = jackson2JsonRedisSerializer
        template.defaultSerializer = StringRedisSerializer()
        // Add some specific configuration here. Key serializers, etc.
        return template
    }

    private fun objectMapper() = ObjectMapper().apply {
        registerModule(KotlinModule())
        registerModule(JavaTimeModule())
        configure(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS, false)
    }
}
