package com.dealvault.dealvault.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.dealvault.dealvault.model.Application;
import com.dealvault.dealvault.model.User;
import com.dealvault.dealvault.model.Project;
import com.dealvault.dealvault.service.ApplicationService;
import com.dealvault.dealvault.service.EscrowService;
import com.dealvault.dealvault.service.ProjectService;
import com.dealvault.dealvault.service.UserService;

@Controller
@RequestMapping("/ui/applications")
public class PageApplicationController {

    @Autowired
    private ApplicationService applicationService;

    @Autowired
    private UserService userService;

    @Autowired
    private ProjectService projectService;

    @Autowired
    private EscrowService escrowService;

    // 🔥 APPLY FROM UI
 
    @PostMapping("/apply")
    public String apply(@RequestParam Long projectId,
                        @RequestParam Long freelancerId) {

        if (projectId == null || freelancerId == null) {
            return "redirect:/login";
        }

        Application app = new Application();
        app.setProjectId(projectId);
        app.setFreelancerId(freelancerId);

        applicationService.apply(app);

        // 🔥 REDIRECT (IMPORTANT)
        return "redirect:/ui/freelancer/dashboard?freelancerId=" + freelancerId;
    }
    @PostMapping("/select-ui")
    public String selectFreelancer(@RequestParam Long projectId,
                                   @RequestParam Long freelancerId,
                                   @RequestParam Long clientId,
                                   Model model) {

        applicationService.selectFreelancer(projectId, freelancerId);

        // 🔥 reload client dashboard
        User user = userService.findById(clientId);
        List<Project> projects = projectService.getProjectsByClient(clientId);
        List<Application> applications = applicationService.getAllApplications();

        double lockedAmount = escrowService.getLockedAmount();

        model.addAttribute("user", user);
        model.addAttribute("projects", projects);
        model.addAttribute("applications", applications);
        model.addAttribute("lockedAmount", lockedAmount);
        model.addAttribute("message", "Freelancer Selected Successfully");

        return "redirect:/ui/client/dashboard?clientId=" + clientId;
    }
}