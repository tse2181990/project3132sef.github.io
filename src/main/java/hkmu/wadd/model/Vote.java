package hkmu.wadd.model;

import jakarta.persistence.*;

@Entity
public class Vote {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    private String username;

    @ManyToOne
    @JoinColumn(name = "poll_option_id")
    private PollOption pollOption;

    @ManyToOne
    @JoinColumn(name = "poll_id")
    private Poll poll;

    // Getters and Setters
    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public PollOption getPollOption() { return pollOption; }
    public void setPollOption(PollOption pollOption) { this.pollOption = pollOption; }

    public Poll getPoll() { return poll; }
    public void setPoll(Poll poll) { this.poll = poll; }
}
