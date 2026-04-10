package hkmu.wadd.dao;

import hkmu.wadd.model.CourseUser;
import org.springframework.data.jpa.repository.JpaRepository;

public interface CourseUserRepository extends JpaRepository<CourseUser, String> {
}
