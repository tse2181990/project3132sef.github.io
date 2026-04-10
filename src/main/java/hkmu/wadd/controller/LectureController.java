package hkmu.wadd.controller;

import hkmu.wadd.dao.LectureService;
import hkmu.wadd.exception.AttachmentNotFound;
import hkmu.wadd.exception.LectureNotFound;
import hkmu.wadd.model.Attachment;
import hkmu.wadd.view.DownloadingView;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.View;
import org.springframework.web.servlet.view.RedirectView;

import java.io.IOException;
import java.security.Principal;
import java.util.List;
import java.util.UUID;

@Controller
@RequestMapping("/lecture")
public class LectureController {

    @Resource
    private LectureService lectureService;

    public static class LectureForm {
        private String title;
        private String summary;
        private List<MultipartFile> attachments;

        public String getTitle() {
            return title;
        }

        public void setTitle(String title) {
            this.title = title;
        }

        public String getSummary() {
            return summary;
        }

        public void setSummary(String summary) {
            this.summary = summary;
        }

        public List<MultipartFile> getAttachments() {
            return attachments;
        }

        public void setAttachments(List<MultipartFile> attachments) {
            this.attachments = attachments;
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
    public String view(@PathVariable long id, ModelMap model)
            throws LectureNotFound {
        model.addAttribute("lecture", lectureService.getLecture(id));
        model.addAttribute("commentForm", new CommentForm());
        return "lectureView";
    }

    @GetMapping("/create")
    public ModelAndView create() {
        return new ModelAndView("lectureAdd", "lectureForm", new LectureForm());
    }

    @PostMapping("/create")
    public View create(LectureForm form) throws IOException {
        long id = lectureService.createLecture(
                form.getTitle(), form.getSummary(), form.getAttachments());
        return new RedirectView("/lecture/view/" + id, true);
    }

    @GetMapping("/edit/{id}")
    public ModelAndView showEdit(@PathVariable long id)
            throws LectureNotFound {
        var lecture = lectureService.getLecture(id);
        ModelAndView mav = new ModelAndView("lectureEdit");
        mav.addObject("lecture", lecture);
        LectureForm form = new LectureForm();
        form.setTitle(lecture.getTitle());
        form.setSummary(lecture.getSummary());
        mav.addObject("lectureForm", form);
        return mav;
    }

    @PostMapping("/edit/{id}")
    public String edit(@PathVariable long id, LectureForm form)
            throws IOException, LectureNotFound {
        lectureService.updateLecture(
                id, form.getTitle(), form.getSummary(), form.getAttachments());
        return "redirect:/lecture/view/" + id;
    }

    @GetMapping("/delete/{id}")
    public String delete(@PathVariable long id)
            throws LectureNotFound {
        lectureService.delete(id);
        return "redirect:/";
    }

    // FIX: Removed :.+ regex suffix — PathPatternParser handles UUID with dots
    // natively
    @GetMapping("/{id}/attachment/{attachmentId}")
    public View download(@PathVariable long id,
            @PathVariable UUID attachmentId)
            throws LectureNotFound, AttachmentNotFound {
        Attachment a = lectureService.getAttachment(id, attachmentId);
        return new DownloadingView(a.getName(), a.getMimeContentType(), a.getContents());
    }

    // FIX: Removed :.+ regex suffix
    @GetMapping("/{id}/deleteAttachment/{attachmentId}")
    public String deleteAttachment(@PathVariable long id,
            @PathVariable UUID attachmentId)
            throws LectureNotFound, AttachmentNotFound {
        lectureService.deleteAttachment(id, attachmentId);
        return "redirect:/lecture/view/" + id;
    }

    @PostMapping("/{id}/comment")
    public String addComment(@PathVariable long id,
            CommentForm form, Principal principal)
            throws LectureNotFound {
        lectureService.addComment(id, principal.getName(), form.getContent());
        return "redirect:/lecture/view/" + id;
    }

    @PostMapping("/{id}/deleteComment/{commentId}")
    public String deleteComment(@PathVariable long id,
            @PathVariable long commentId) throws LectureNotFound {
        lectureService.deleteComment(id, commentId); 
        return "redirect:/lecture/view/" + id;
    }

    @ExceptionHandler({ LectureNotFound.class, AttachmentNotFound.class })
    public ModelAndView error(Exception e) {
        return new ModelAndView("error", "message", e.getMessage());
    }
}