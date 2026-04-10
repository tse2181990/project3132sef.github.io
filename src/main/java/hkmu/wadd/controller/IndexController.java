package hkmu.wadd.controller;

import hkmu.wadd.dao.LectureService;
import hkmu.wadd.dao.PollService;
import hkmu.wadd.dao.UserManagementService;
import hkmu.wadd.model.CourseUser;
import jakarta.annotation.Resource;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.security.Principal;

@Controller
public class IndexController {

    @Resource
    private LectureService lectureService;

    @Resource
    private PollService pollService;

    @Resource
    private UserManagementService umService;

    @GetMapping("/")
    public String index(ModelMap model) {
        model.addAttribute("lectures", lectureService.getLectures());
        model.addAttribute("polls", pollService.getPolls());
        return "index";
    }

    @GetMapping("/login")
    public String login() {
        return "login";
    }

    @GetMapping("/register")
    public String register() {
        return "register";
    }

    @PostMapping("/register")
    public String doRegister(@RequestParam String username,
                             @RequestParam String password,
                             @RequestParam String fullName,
                             @RequestParam String email,
                             @RequestParam(required = false) String phone) {
        try {
            umService.createCourseUser(username, password, fullName, email, phone, 
                    new String[]{"ROLE_STUDENT"});
            return "redirect:/login?registered";
        } catch (Exception e) {
            return "redirect:/register?error";
        }
    }

    @GetMapping("/profile")
    public String profile(Principal principal, Model model) {
        CourseUser user = umService.getCourseUser(principal.getName());
        model.addAttribute("user", user);
        return "profile";
    }

    @PostMapping("/profile")
    public String updateProfile(Principal principal,
                                @RequestParam(required = false) String password,
                                @RequestParam String fullName,
                                @RequestParam String email,
                                @RequestParam(required = false) String phone) {
        CourseUser user = umService.getCourseUser(principal.getName());
        String[] roles = user.getRoles().stream()
                .map(r -> r.getRole())
                .toArray(String[]::new);
        umService.updateCourseUser(principal.getName(), password, fullName, email, phone, roles);
        return "redirect:/profile?success";
    }
}
