package hkmu.wadd.controller;

import hkmu.wadd.dao.PollService;
import hkmu.wadd.exception.PollNotFound;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;
import org.springframework.web.servlet.view.RedirectView;

import java.security.Principal;
import java.util.List;

@Controller
@RequestMapping("/poll")
public class PollController {

    @Resource
    private PollService pollService;

    public static class PollForm {
        private String question;
        private List<String> options;

        public String getQuestion() {
            return question;
        }

        public void setQuestion(String question) {
            this.question = question;
        }

        public List<String> getOptions() {
            return options;
        }

        public void setOptions(List<String> options) {
            this.options = options;
        }
    }

    public static class CommentForm {
        private String content;

        public String getContent() {
            return content;
        }

        public void setContent(String content) {
            this.content = content;
        }
    }

    @GetMapping("/view/{id}")
    public String view(@PathVariable long id, ModelMap model,
            Principal principal) throws PollNotFound {
        model.addAttribute("poll", pollService.getPoll(id));
        model.addAttribute("commentForm", new CommentForm());
        if (principal != null) {
            model.addAttribute("userVote",
                    pollService.getUserVote(id, principal.getName()));
        }
        return "pollView";
    }

    @GetMapping("/create")
    public ModelAndView create() {
        return new ModelAndView("pollAdd", "pollForm", new PollForm());
    }

    @PostMapping("/create")
    public View create(PollForm form) {
        long id = pollService.createPoll(form.getQuestion(), form.getOptions());
        return new RedirectView("/poll/view/" + id, true);
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable long id) throws PollNotFound {
        pollService.delete(id);
        return "redirect:/";
    }

    @PostMapping("/{id}/vote")
    public String vote(@PathVariable long id,
            @RequestParam long optionId,
            Principal principal) throws PollNotFound {
        pollService.vote(id, optionId, principal.getName());
        return "redirect:/poll/view/" + id;
    }

    @PostMapping("/{id}/comment")
    public String addComment(@PathVariable long id,
            CommentForm form, Principal principal)
            throws PollNotFound {
        pollService.addComment(id, principal.getName(), form.getContent());
        return "redirect:/poll/view/" + id;
    }

    @PostMapping("/{id}/deleteComment/{commentId}")
    public String deleteComment(@PathVariable long id,
            @PathVariable long commentId) throws PollNotFound {
        pollService.deleteComment(id, commentId); 
        return "redirect:/poll/view/" + id;
    }

    @ExceptionHandler(PollNotFound.class)
    public ModelAndView error(Exception e) {
        return new ModelAndView("error", "message", e.getMessage());
    }
}
