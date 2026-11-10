package com.backend.mobile.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.web.cors.CorsConfigurationSource;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(
            HttpSecurity http,
            CorsConfigurationSource corsConfigurationSource) throws Exception {
        http
            .cors(cors -> cors.configurationSource(corsConfigurationSource))
            // Desabilita CSRF se você estiver construindo uma API REST stateless (com token JWT, por exemplo)
            .csrf(csrf -> csrf.disable())
            
            // Configura as regras de autorização das rotas
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/auth/**").permitAll() // Rotas livres
                .anyRequest().authenticated() // Qualquer outra rota exige estar logado
            )
            
            // Configura o formulário de login padrão do Spring (ou você pode apontar para uma página customizada)
            .formLogin(form -> form
                .loginPage("/login") // Opcional: página de login personalizada
                .defaultSuccessUrl("/home", true)
                .permitAll()
            )
            
            // Configuração de Logout
            .logout(logout -> logout
                .logoutSuccessUrl("/login?logout")
                .permitAll()
            );

        return http.build();
    }

    // Define o algoritmo de criptografia de senhas (BCrypt é o padrão recomendado)
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
}