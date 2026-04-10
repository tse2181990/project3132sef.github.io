package hkmu.wadd.dao;

import hkmu.wadd.model.Vote;
import org.springframework.data.jpa.repository.JpaRepository;

public interface VoteRepository extends JpaRepository<Vote, Long> {
    Vote findByUsernameAndPollId(String username, long pollId);
}
