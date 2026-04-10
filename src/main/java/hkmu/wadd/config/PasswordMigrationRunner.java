package hkmu.wadd.config;

import hkmu.wadd.dao.CourseUserRepository;
import hkmu.wadd.model.CourseUser;
import org.springframework.boot.ApplicationArguments;
import org.springframework.boot.ApplicationRunner;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Component
public class PasswordMigrationRunner implements ApplicationRunner {

    private static final String NOOP_PREFIX = "{noop}";

    private final CourseUserRepository courseUserRepository;
    private final PasswordEncoder passwordEncoder;

    public PasswordMigrationRunner(CourseUserRepository courseUserRepository,
                                   PasswordEncoder passwordEncoder) {
        this.courseUserRepository = courseUserRepository;
        this.passwordEncoder = passwordEncoder;
    }

    @Override
    @Transactional
    public void run(ApplicationArguments args) {
        for (CourseUser user : courseUserRepository.findAll()) {
            String storedPassword = user.getPassword();
            if (storedPassword != null && storedPassword.startsWith(NOOP_PREFIX)) {
                String rawPassword = storedPassword.substring(NOOP_PREFIX.length());
                user.setPassword(passwordEncoder.encode(rawPassword));
                courseUserRepository.save(user);
            }
        }
    }
}
