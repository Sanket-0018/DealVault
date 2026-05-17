package com.dealvault.dealvault.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.dealvault.dealvault.model.Project;
import com.dealvault.dealvault.model.User;
import com.dealvault.dealvault.service.ProjectService;
import com.dealvault.dealvault.service.UserService;

@RestController
@RequestMapping("/api/projects")
public class ProjectController {

    @Autowired
    private ProjectService projectService;
    @Autowired
    private UserService userService;

    @PostMapping("/create")
    public Project createProject(@RequestBody Project project) {
        return projectService.createProject(project);
    }
    @GetMapping("/all")
    public List<Project> getAllProjects() {
        return projectService.getAllProjects();
    }

    @GetMapping("/get/{id}")
    public Project getProjectById(@PathVariable("id") Long id) {
        return projectService.getProjectById(id);
    }
    @PostMapping("/complete")
    public String completeProject(@RequestParam("projectId") Long projectId) {

        projectService.completeProject(projectId);

        return "Project Completed & Payment Released";
    }
    @PostMapping("/wallet/add")
    public String addMoney(@RequestParam Long userId,
                           @RequestParam Double amount){

        User user = userService.findById(userId);

        if(user.getBalance() == null){
            user.setBalance(0.0);
        }

        user.setBalance(user.getBalance() + amount);

        userService.register(user);

        return "redirect:/ui/client/dashboard?clientId=" + userId;
    }
    
}