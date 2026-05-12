package com.dealvault.dealvault.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.dealvault.dealvault.model.User;
import com.dealvault.dealvault.model.Application;
import com.dealvault.dealvault.model.Project;
import com.dealvault.dealvault.service.UserService;
import com.dealvault.dealvault.service.ProjectService;
import com.dealvault.dealvault.service.ApplicationService;
import com.dealvault.dealvault.service.EscrowService;

@Controller
@RequestMapping("/api/users")
public class PageUserController {

    @Autowired
    private UserService userService;

    @Autowired
    private ProjectService projectService;

    @Autowired
    private EscrowService escrowService; // 🔥 NEW
    @Autowired
    private ApplicationService applicationService;

    // 🔥 LOGIN FROM JSP
    @PostMapping("/login-ui")
    public String loginUser(@RequestParam String email,
                            @RequestParam String password,
                            Model model) {

        User user = userService.login(email, password);

        if (user != null) {

            model.addAttribute("user", user); // IMPORTANT

            // 🔥 ROLE CHECK
            if ("CLIENT".equals(user.getRole())) {

                List<Project> projects = projectService.getProjectsByClient(user.getId());
                List<Application> applications = applicationService.getAllApplications();

                double lockedAmount = escrowService.getLockedAmount();

                model.addAttribute("user", user);
                model.addAttribute("projects", projects);
                model.addAttribute("applications", applications);
                model.addAttribute("lockedAmount", lockedAmount);
                model.addAttribute("escrowService", escrowService);

                return "client-dashboard";
            } else {
            	// FREELANCER FLOW
            	List<Project> projects = projectService.getAllProjects();
            	List<Application> applications = applicationService.getAllApplications();

            	// 🔥 ADD THIS BLOCK
            	Map<Long, Double> projectAmounts = new HashMap<>();

            	for (Application app : applications) {
            	    Double amount = escrowService.getAmountByProject(app.getProjectId());
            	    projectAmounts.put(app.getProjectId(), amount);
            	}

            	model.addAttribute("projects", projects);
            	model.addAttribute("user", user);
            	model.addAttribute("applications", applications);
            	model.addAttribute("projectAmounts", projectAmounts); // 🔥 VERY IMPORTANT

            	return "dashboard";
            }

        } else {
            model.addAttribute("error", "Invalid Credentials");
            return "login";
        }
    }
    @PostMapping("/register-ui")
    public String registerUser(@RequestParam String email,
                               @RequestParam String password,
                               @RequestParam String role,
                               Model model) {

        User user = new User();
        user.setEmail(email);
        user.setPassword(password);
        user.setRole(role);

        userService.register(user);

        model.addAttribute("message", "Registration successful");
        return "login";
    }
    @GetMapping("/ui/client/dashboard")
    public String clientDashboard(@RequestParam Long clientId, Model model) {

        User user = userService.findById(clientId);
        List<Project> projects = projectService.getProjectsByClient(clientId);
        List<Application> applications = applicationService.getAllApplications();

        double lockedAmount = escrowService.getLockedAmount();
        double totalBalance = 50000; // initial wallet
        double availableBalance = totalBalance - lockedAmount;

        model.addAttribute("totalBalance", totalBalance);
        model.addAttribute("availableBalance", availableBalance);

        model.addAttribute("user", user);
        model.addAttribute("projects", projects);
        model.addAttribute("applications", applications);
        model.addAttribute("lockedAmount", lockedAmount);

        return "client-dashboard";
    }
    @GetMapping("/ui/freelancer/dashboard")
    public String freelancerDashboard(@RequestParam Long freelancerId, Model model) {

        User user = userService.findById(freelancerId);

        List<Project> projects = projectService.getAllProjects();
        List<Application> applications = applicationService.getAllApplications();

        Map<Long, Double> projectAmounts = new HashMap<>();

        for (Application app : applications) {
            Double amount = escrowService.getAmountByProject(app.getProjectId());
            projectAmounts.put(app.getProjectId(), amount);
        }

        model.addAttribute("user", user);
        model.addAttribute("projects", projects);
        model.addAttribute("applications", applications);
        model.addAttribute("projectAmounts", projectAmounts);

        return "dashboard";
    }
    @GetMapping("/signup")
    public String showSignupPage() {
        return "signup";
    }
}