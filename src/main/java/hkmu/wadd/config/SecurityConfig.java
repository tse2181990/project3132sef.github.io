package hkmu.wadd.config;

import jakarta.servlet.DispatcherType;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.util.matcher.AntPathRequestMatcher;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http)
            throws Exception {
        http
            .authorizeHttpRequests(authorize -> authorize
                .dispatcherTypeMatchers(DispatcherType.FORWARD, DispatcherType.ERROR).permitAll()

                // H2 Console 
                .requestMatchers(
                    AntPathRequestMatcher.antMatcher("/h2-console/**")
                ).permitAll()

                // Public pages
                .requestMatchers(
                    AntPathRequestMatcher.antMatcher("/"),
                    AntPathRequestMatcher.antMatcher("/login"),
                    AntPathRequestMatcher.antMatcher("/register"),
                    AntPathRequestMatcher.antMatcher("/error")
                ).permitAll()

                // Student + Teacher pages
                .requestMatchers(
                    AntPathRequestMatcher.antMatcher("/profile"),
                    AntPathRequestMatcher.antMatcher("/user/commentHistory")
                ).hasAnyRole("STUDENT", "TEACHER")

                // Teacher-only user management
                .requestMatchers(
                    AntPathRequestMatcher.antMatcher("/user"),
                    AntPathRequestMatcher.antMatcher("/user/"),
                    AntPathRequestMatcher.antMatcher("/user/list"),
                    AntPathRequestMatcher.antMatcher("/user/create"),
                    AntPathRequestMatcher.antMatcher("/user/edit/*"),
                    AntPathRequestMatcher.antMatcher("/user/delete/*")
                ).hasRole("TEACHER")

                // Teacher-only lecture write/delete actions
                .requestMatchers(
                    AntPathRequestMatcher.antMatcher("/lecture/create"),
                    AntPathRequestMatcher.antMatcher("/lecture/edit/*"),
                    AntPathRequestMatcher.antMatcher("/lecture/delete/*"),
                    AntPathRequestMatcher.antMatcher("/lecture/*/deleteAttachment/*"),
                    AntPathRequestMatcher.antMatcher("/lecture/*/deleteComment/*")
                ).hasRole("TEACHER")

                // Teacher-only poll write/delete actions
                .requestMatchers(
                    AntPathRequestMatcher.antMatcher("/poll/create"),
                    AntPathRequestMatcher.antMatcher("/poll/delete/*"),
                    AntPathRequestMatcher.antMatcher("/poll/*/deleteComment/*")
                ).hasRole("TEACHER")

                // Student + Teacher lecture/poll read and interaction pages
                .requestMatchers(
                    AntPathRequestMatcher.antMatcher("/lecture/view/*"),
                    AntPathRequestMatcher.antMatcher("/lecture/*/attachment/*"),
                    AntPathRequestMatcher.antMatcher("/lecture/*/comment"),
                    AntPathRequestMatcher.antMatcher("/poll/view/*"),
                    AntPathRequestMatcher.antMatcher("/poll/*/vote"),
                    AntPathRequestMatcher.antMatcher("/poll/*/comment")
                ).hasAnyRole("STUDENT", "TEACHER")

                // Other routes must be authenticated
                .anyRequest().authenticated()
            )
            .formLogin(form -> form
                .loginPage("/login")
                .defaultSuccessUrl("/", true)
                .failureUrl("/login?error")
                .permitAll()
            )
            .logout(logout -> logout
                .logoutUrl("/logout")
                .logoutSuccessUrl("/login?logout")
                .invalidateHttpSession(true)
                .deleteCookies("JSESSIONID")
            )
            .rememberMe(remember -> remember
                .key("uniqueAndSecret")
                .tokenValiditySeconds(86400)
            )
            //  Stop H2 Console  CSRF 
            .csrf(csrf -> csrf
                .ignoringRequestMatchers(
                    AntPathRequestMatcher.antMatcher("/h2-console/**")
                )
            )
            //  H2 Console with iframe
            .headers(headers -> headers
                .frameOptions(frame -> frame.sameOrigin())
            );

        return http.build();
    }
}