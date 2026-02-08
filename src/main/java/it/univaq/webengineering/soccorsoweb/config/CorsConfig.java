package it.univaq.webengineering.soccorsoweb.config;

import org.jspecify.annotations.NonNull;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.CorsRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class CorsConfig {

    @org.springframework.beans.factory.annotation.Value("${app.frontend-url}")
    private String frontendUrl;

    @Bean
    public WebMvcConfigurer corsConfigurer() {
        return new WebMvcConfigurer() {
            @Override
            public void addCorsMappings(@NonNull CorsRegistry registry) {
                registry.addMapping("/**") // Tutti gli endpoint
                        .allowedOriginPatterns("*") // Permetti tutte le origini in sviluppo
                        .allowedOrigins(
                                "http://127.0.0.1:5500",
                                "http://127.0.0.1:8080",
                                "http://localhost:5500",
                                "http://localhost:8080",
                                "http://localhost:3000",
                                "http://localhost:4200",
                                "http://localhost:5173",
                                "https://editor.swagger.io",
                                "https://soccorsoweb-swa-production.up.railway.app",
                                frontendUrl)
                        .allowedMethods("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS")
                        .allowedHeaders("*")
                        .allowCredentials(true)
                        .exposedHeaders("Authorization", "Content-Type", "Accept")
                        .maxAge(3600); // Cache preflight per 1 ora
            }
        };
    }
}
