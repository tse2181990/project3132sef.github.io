package hkmu.wadd.controller;

import hkmu.wadd.dao.CommentRepository;
import hkmu.wadd.dao.UserManagementService;
import hkmu.wadd.model.Comment;
import jakarta.annotation.Resource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import java.security.Principal;
import java.util.List;

@Controller
@RequestMapping("/user")
public class UserManagementController {

    @Resource
    UserManagementService umService;

    @Autowired                                   
    private CommentRepository commentRepository;

    // ===== Form =====
    public static class Form {
        private String username;
        private String password;
        private String fullName;
        private String email;
        private String phone;
        private String[] roles;

        public String getUsername() { return username; }
        public void setUsername(String username) { this.username = username; }

        public String getPassword() { return password; }
        public void setPassword(String password) { this.password = password; }

        public String getFullName() { return fullName; }
        public void setFullName(String fullName) { this.fullName = fullName; }

        public String getEmail() { return email; }
        public void setEmail(String email) { this.email = email; }

        public String getPhone() { return phone; }
        public void setPhone(String phone) { this.phone = phone; }

        public String[] getRoles() { return roles; }
        public void setRoles(String[] roles) { this.roles = roles; }
    }

    // ===== List =====
    @GetMapping({"", "/", "/list"})
    public String list(ModelMap model) {
        model.addAttribute("courseUsers", umService.getCourseUsers());
        return "listUser";
    }

    // ===== Create =====
    @GetMapping("/create")
    public ModelAndView create() {
        return new ModelAndView("addUser", "userForm", new Form());
    }

    @PostMapping("/create")
    public String create(Form form) {
        umService.createCourseUser(
                form.getUsername(), form.getPassword(),
                form.getFullName(), form.getEmail(),
                form.getPhone(), form.getRoles()
        );
        return "redirect:/user/list";
    }

    // ===== Edit (Teacher only) =====
    @GetMapping("/edit/{username}")
    public ModelAndView showEdit(@PathVariable String username) {
        var user = umService.getCourseUser(username);
        Form form = new Form();
        form.setUsername(user.getUsername());
        form.setFullName(user.getFullName());
        form.setEmail(user.getEmail());
        form.setPhone(user.getPhone());
        ModelAndView mav = new ModelAndView("editUser");
        mav.addObject("userForm", form);
        mav.addObject("currentRoles",
                user.getRoles().stream()
                    .map(r -> r.getRole()).toList());
        return mav;
    }

    @PostMapping("/edit/{username}")
    public String edit(@PathVariable String username, Form form) {
        umService.updateCourseUser(
                username, form.getPassword(),
                form.getFullName(), form.getEmail(),
                form.getPhone(), form.getRoles()
        );
        return "redirect:/user/list";
    }

    // ===== Delete =====
    @GetMapping("/delete/{username}")
    public String delete(@PathVariable String username) {
        umService.delete(username);
        return "redirect:/user/list";
    }

    // ===== Comment History =====
    @GetMapping("/commentHistory")
    public String commentHistory(Principal principal, Model model) {
        String username = principal.getName();
        List<Comment> comments = commentRepository.findByUsernameOrderByCreatedAtDesc(username);
        model.addAttribute("comments", comments);
        model.addAttribute("username", username);
        return "commentHistory";
    }
}
