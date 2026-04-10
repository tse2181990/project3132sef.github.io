package hkmu.wadd.dao;

import hkmu.wadd.model.Comment;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;

public interface CommentRepository extends JpaRepository<Comment, Long> {
    List<Comment> findByUsername(String username);

    List<Comment> findByUsernameOrderByCreatedAtDesc(String username);

}
