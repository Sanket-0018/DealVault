package com.dealvault.dealvault.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.dealvault.dealvault.model.Project;
import com.dealvault.dealvault.model.User;
import com.dealvault.dealvault.model.Application;
import com.dealvault.dealvault.service.ProjectService;
import com.dealvault.dealvault.service.UserService;
import com.dealvault.dealvault.service.ApplicationService;
import com.dealvault.dealvault.service.EscrowService;

@Controller
@RequestMapping("/ui/projects")
public class PageProjectController {

    @Autowired
    private ProjectService projectService;

    @Autowired
    private UserService userService;

    @Autowired
    private ApplicationService applicationService;

    @Autowired
    private EscrowService escrowService;

    // 🔥 CREATE PROJECT
    @PostMapping("/create")
    public String createProject(@RequestParam String title,
                               @RequestParam String description,
                               @RequestParam double budget,
                               @RequestParam Long clientId,
                               Model model) {

        Project p = new Project();
        p.setTitle(title);
        p.setDescription(description);
        p.setBudget(budget);
        p.setClientId(clientId);
        p.setStatus("OPEN");

        projectService.createProject(p);

        

        return "redirect:/ui/client/dashboard?clientId=" + clientId;
    }

    // 🔥 FREELANCER MARKS COMPLETE
    @PostMapping("/complete")
    public String markCompletedByFreelancer(@RequestParam Long projectId) {

        applicationService.updateStatusByProject(projectId, "COMPLETION_REQUESTED");
        Long freelancerId = applicationService.getFreelancerIdByProject(projectId);
        return "redirect:/ui/freelancer/dashboard?freelancerId=" + freelancerId;
    }

    @PostMapping("/approve")
    public String approveProject(@RequestParam Long projectId) {

        // 🔥 Step 1: mark project completed
        projectService.updateStatus(projectId, "COMPLETED");

        // 🔥 Step 2: update application status
        applicationService.updateStatusByProject(projectId, "COMPLETED");

        // 🔥 Step 3: release escrow
        escrowService.release(projectId);

        // 🔥 Step 4: get clientId from project
        Long clientId = projectService.getClientId(projectId);

        // 🔥 Step 5: redirect WITH clientId (IMPORTANT)
        return "redirect:/api/users/ui/client/dashboard?clientId=" + clientId;
    }
}