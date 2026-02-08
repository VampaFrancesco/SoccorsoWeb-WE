/**
 * 3. 🔐 Spring Security Filter Chain
 *    a) JWTAuthenticationFilter
 *       - Controlla se c'è un token JWT nell'header
 *       - Per /auth/login è .permitAll() → SALTA la validazione JWT
 *       - Passa avanti ✅
 *
 *    b) SecurityFilterChain
 *       - Verifica le regole di autorizzazione
 *       - /auth/** è .permitAll() → OK, può passare ✅
 */

package it.univaq.webengineering.soccorsoweb.config;

import it.univaq.webengineering.soccorsoweb.security.jwt.JWTAuthenticationFilter;
import it.univaq.webengineering.soccorsoweb.security.userdetails.CustomUserDetailsService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.AuthenticationProvider;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

    private final JWTAuthenticationFilter jwtAuthenticationFilter;
    private final CustomUserDetailsService customUserDetailsService;

    public SecurityConfig(JWTAuthenticationFilter jwtAuthenticationFilter,
                          CustomUserDetailsService customUserDetailsService) {
        this.jwtAuthenticationFilter = jwtAuthenticationFilter;
        this.customUserDetailsService = customUserDetailsService;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .cors(Customizer.withDefaults())
                .csrf(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests(auth -> auth
                        // ✅ File statici (CSS, JS, immagini)
                        .requestMatchers(
                                "/",
                                "/index.html",
                                "/css/**",
                                "/js/**",
                                "/img/**",
                                "/static/**",
                                "/favicon.ico"
                        ).permitAll()

                        // ✅ Pagine pubbliche (senza autenticazione)
                        .requestMatchers(
                                "/home",
                                "/convalida",
                                "/auth/**"
                        ).permitAll()

                        // ✅ API pubbliche (senza JWT)
                        .requestMatchers("/swa/open/**").permitAll()

                        // ✅ Swagger/OpenAPI
                        .requestMatchers(
                                "/api-docs/**",
                                "/api-docs.yaml",
                                "/swagger-ui/**",
                                "/swagger-ui.html"
                        ).permitAll()

                        // 🔒 Sezioni protette per ruolo
                        .requestMatchers("/admin/**").hasRole("ADMIN")
                        .requestMatchers("/operatore/**").hasRole("OPERATORE")

                        // 🔒 API protette (richiedono JWT)
                        .requestMatchers("/swa/api/**").authenticated()

                        // 🔒 Tutto il resto richiede autenticazione
                        .anyRequest().authenticated()
                )
                .sessionManagement(session -> session
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                )
                .authenticationProvider(authenticationProvider())
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public AuthenticationProvider authenticationProvider() {
        DaoAuthenticationProvider provider = new DaoAuthenticationProvider(customUserDetailsService);
        provider.setPasswordEncoder(passwordEncoder());
        return provider;
    }

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
        return config.getAuthenticationManager();
    }

}

