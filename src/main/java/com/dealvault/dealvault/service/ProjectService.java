package com.dealvault.dealvault.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dealvault.dealvault.model.Project;
import com.dealvault.dealvault.repository.ProjectRepository;

@Service
public class ProjectService {

    @Autowired
    private ProjectRepository projectRepository;

    public Project createProject(Project project) {
        project.setStatus("OPEN");
        return projectRepository.save(project);
    }

public List<Project> getAllProjects() {
    return projectRepository.findAll();
}

public Project getProjectById(Long id) {
    return projectRepository.findById(id).orElse(null);
}
@Autowired
private EscrowService escrowService;

public void completeProject(Long projectId) {

    Project project = projectRepository.findById(projectId).orElse(null);

    if (project != null) {
        project.setStatus("COMPLETED");
        projectRepository.save(project);

        // 🔥 Release payment
        escrowService.release(projectId);
    }
}public List<Project> getProjectsByClient(Long clientId) {
    return projectRepository.findByClientId(clientId);
}
public void updateStatus(Long projectId, String status) {
    Project p = projectRepository.findById(projectId).get();
    p.setStatus(status);
    projectRepository.save(p);
}
public Long getClientId(Long projectId) {
    return projectRepository.findById(projectId).get().getClientId();
}
}