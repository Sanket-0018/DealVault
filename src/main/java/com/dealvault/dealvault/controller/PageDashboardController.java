package com.dealvault.dealvault.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.dealvault.dealvault.model.*;
import com.dealvault.dealvault.service.*;

@Controller
public class PageDashboardController {

    @Autowired
    private UserService userService;

    @Autowired
    private ProjectService projectService;

    @Autowired
    private ApplicationService applicationService;

    @Autowired
    private EscrowService escrowService;

    // ✅ CLIENT DASHBOARD
    @GetMapping("/ui/client/dashboard")
    public String clientDashboard(@RequestParam Long clientId, Model model) {

        User user = userService.findById(clientId);
        List<Project> projects = projectService.getProjectsByClient(clientId);
        List<Application> applications = applicationService.getAllApplications();

        double lockedAmount = escrowService.getLockedAmount();

        model.addAttribute("user", user);
        model.addAttribute("projects", projects);
        model.addAttribute("applications", applications);
        model.addAttribute("lockedAmount", lockedAmount);

        return "client-dashboard";
    }

    // ✅ FREELANCER DASHBOARD
    @GetMapping("/ui/freelancer/dashboard")
    public String freelancerDashboard(@RequestParam Long freelancerId, Model model) {

        // 🔥 GET USER
        User user = userService.findById(freelancerId);

        // 🔥 GET DATA (YOU MISSED THIS)
        List<Project> projects = projectService.getAllProjects();
        List<Application> applications = applicationService.getAllApplications();

        // 🔥 CREATE MAP FOR PAYMENT
        Map<Long, Double> projectAmounts = new HashMap<>();

        for (Application app : applications) {
            Double amount = escrowService.getAmountByProject(app.getProjectId());
            projectAmounts.put(app.getProjectId(), amount);
        }

        // 🔥 SEND TO JSP
        model.addAttribute("user", user);
        model.addAttribute("projects", projects);
        model.addAttribute("applications", applications);
        model.addAttribute("projectAmounts", projectAmounts);

        return "dashboard";
    }
}