package com.dealvault.dealvault.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.dealvault.dealvault.model.Project;
import com.dealvault.dealvault.service.ProjectService;

@RestController
@RequestMapping("/api/projects")
public class ProjectController {

    @Autowired
    private ProjectService projectService;

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
    
    
}