package hkmu.wadd.dao;

import hkmu.wadd.model.CourseUser;
import jakarta.annotation.Resource;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class UserManagementService {

    @Resource
    private CourseUserRepository courseUserRepo;

    @Resource
    private PasswordEncoder passwordEncoder;

    @Transactional
    public List<CourseUser> getCourseUsers() {
        return courseUserRepo.findAll();
    }

    @Transactional
    public CourseUser getCourseUser(String username) {
        return courseUserRepo.findById(username).orElseThrow(
                () -> new UsernameNotFoundException("User '" + username + "' not found.")
        );
    }

    @Transactional
    public void createCourseUser(String username, String password,
                                 String fullName, String email,
                                 String phone, String[] roles) {
        String encodedPassword = passwordEncoder.encode(password);
        CourseUser user = new CourseUser(username, encodedPassword, fullName, email, phone, roles);
        courseUserRepo.save(user);
    }

    @Transactional
    public void updateCourseUser(String username, String password,
                                 String fullName, String email,
                                 String phone, String[] roles) {
        CourseUser user = getCourseUser(username);
        if (password != null && !password.isBlank()) {
            user.setPassword(passwordEncoder.encode(password));
        }
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);
        user.getRoles().clear();
        for (String role : roles) {
            hkmu.wadd.model.UserRole ur = new hkmu.wadd.model.UserRole();
            ur.setRole(role);
            ur.setUser(user);
            user.getRoles().add(ur);
        }
        courseUserRepo.save(user);
    }

    @Transactional
    public void delete(String username) {
        CourseUser user = courseUserRepo.findById(username).orElseThrow(
                () -> new UsernameNotFoundException("User '" + username + "' not found.")
        );
        courseUserRepo.delete(user);
    }
}
