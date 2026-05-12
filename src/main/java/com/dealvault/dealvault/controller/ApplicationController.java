package com.dealvault.dealvault.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.dealvault.dealvault.model.Application;
import com.dealvault.dealvault.service.ApplicationService;

@RestController
@RequestMapping("/api/applications")
public class ApplicationController {

    @Autowired
    private ApplicationService applicationService;

    @PostMapping("/apply")
    public String apply(@RequestParam Long projectId,
                        @RequestParam Long freelancerId) {

        Application app = new Application();
        app.setProjectId(projectId);
        app.setFreelancerId(freelancerId);

        applicationService.apply(app);

        return "redirect:/"; // or dashboard later
    
    }
    @PostMapping("/select")
    public String selectFreelancer(@RequestParam("projectId") Long projectId,
                                   @RequestParam("freelancerId") Long freelancerId) {

        applicationService.selectFreelancer(projectId, freelancerId);

        return "Freelancer Selected Successfully";
        
    }
    
}