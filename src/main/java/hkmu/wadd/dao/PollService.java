package hkmu.wadd.dao;

import hkmu.wadd.exception.PollNotFound;
import hkmu.wadd.model.*;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class PollService {

    @Resource
    private PollRepository pollRepo;

    @Resource
    private VoteRepository voteRepo;

    @Resource
    private CommentRepository commentRepo;

    @Transactional
    public List<Poll> getPolls() {
        return pollRepo.findAll();
    }

    @Transactional
    public Poll getPoll(long id) throws PollNotFound {
        Poll poll = pollRepo.findById(id).orElse(null);
        if (poll == null)
            throw new PollNotFound(id);
        return poll;
    }

    @Transactional
    public long createPoll(String question, List<String> optionTexts) {
        Poll poll = new Poll();
        poll.setQuestion(question);
        for (String text : optionTexts) {
            PollOption option = new PollOption();
            option.setOptionText(text);
            option.setPoll(poll);
            poll.getOptions().add(option);
        }
        pollRepo.save(poll);
        return poll.getId();
    }

    @Transactional
    public void delete(long id) throws PollNotFound {
        pollRepo.delete(getPoll(id));
    }

    @Transactional
    public void vote(long pollId, long optionId, String username) throws PollNotFound {
        Poll poll = getPoll(pollId);
        // 檢查是否已投票
        Vote existing = voteRepo.findByUsernameAndPollId(username, pollId);
        if (existing != null) {
            // 修改舊票
            existing.getPollOption().setVoteCount(
                    existing.getPollOption().getVoteCount() - 1);
            existing.setPollOption(
                    poll.getOptions().stream()
                            .filter(o -> o.getId() == optionId)
                            .findFirst().orElseThrow());
            existing.getPollOption().setVoteCount(
                    existing.getPollOption().getVoteCount() + 1);
            voteRepo.save(existing);
        } else {
            // 新投票
            PollOption option = poll.getOptions().stream()
                    .filter(o -> o.getId() == optionId)
                    .findFirst().orElseThrow();
            option.setVoteCount(option.getVoteCount() + 1);
            Vote vote = new Vote();
            vote.setUsername(username);
            vote.setPollOption(option);
            vote.setPoll(poll);
            voteRepo.save(vote);
        }
    }

    @Transactional
    public Vote getUserVote(long pollId, String username) {
        return voteRepo.findByUsernameAndPollId(username, pollId);
    }

    @Transactional
    public void addComment(long pollId, String username, String content)
            throws PollNotFound {
        Poll poll = getPoll(pollId);
        Comment comment = new Comment();
        comment.setUsername(username);
        comment.setContent(content);
        comment.setPoll(poll);
        poll.getComments().add(comment);
        pollRepo.save(poll);
    }

    @Transactional
    public void deleteComment(long pollId, long commentId) throws PollNotFound {
        Poll poll = getPoll(pollId);
        poll.getComments().removeIf(c -> c.getId() == commentId);
        pollRepo.save(poll);
    }

}
