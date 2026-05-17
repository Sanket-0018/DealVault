package com.dealvault.dealvault.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dealvault.dealvault.model.Application;
import com.dealvault.dealvault.model.Project;
import com.dealvault.dealvault.repository.ApplicationRepository;
import com.dealvault.dealvault.repository.ProjectRepository;
import com.dealvault.dealvault.service.EscrowService;

@Service
public class ApplicationService {

    @Autowired
    private ApplicationRepository applicationRepository;

    @Autowired
    private ProjectRepository projectRepository;

    @Autowired
    private EscrowService escrowService; // 🔥 YOU MISSED THIS

    // ✅ Apply for project
    public Application apply(Application application) {

        // 🔥 check if already applied
        Application existing = applicationRepository
            .findByProjectIdAndFreelancerId(
                application.getProjectId(),
                application.getFreelancerId()
            );

        if (existing != null) {
            return existing; // already applied
        }

        application.setStatus("APPLIED");
        return applicationRepository.save(application);
    }
    // ✅ Select freelancer
    public void selectFreelancer(Long projectId, Long freelancerId) {

        List<Application> applications = applicationRepository.findAll();

        for (Application app : applications) {
            if (app.getProjectId().equals(projectId)) {

                if (app.getFreelancerId().equals(freelancerId)) {
                    app.setStatus("ACCEPTED");
                } else {
                    app.setStatus("REJECTED");
                }

                applicationRepository.save(app);
            }
        }

        // 🔥 Update project status
        Project project = projectRepository.findById(projectId).orElse(null);

        if (project != null) {
            project.setStatus("IN_PROGRESS");
            projectRepository.save(project);

            // 🔥 AUTO CREATE ESCROW
         // 🔥 AUTO CREATE ESCROW (ONLY ONCE)
            escrowService.deposit(projectId, project.getBudget());
        }
        
    }
    public List<Application> getAllApplications() {
        return applicationRepository.findAll();
    }
    public void updateStatusByProject(Long projectId, String status) {

        List<Application> apps = applicationRepository.findByProjectId(projectId);

        for (Application app : apps) {

            // 🔥 update ANY active application
            if ("ACCEPTED".equals(app.getStatus()) ||
                "COMPLETION_REQUESTED".equals(app.getStatus())) {

                app.setStatus(status);
                applicationRepository.save(app);
            }
        }
    }
	public Long getFreelancerIdByProject(Long projectId) {

    List<Application> apps = applicationRepository.findByProjectId(projectId);

    for (Application app : apps) {
    	if ("ACCEPTED".equals(app.getStatus()) ||
    		    "COMPLETION_REQUESTED".equals(app.getStatus()) ||
    		    "COMPLETED".equals(app.getStatus())) {

    		    return app.getFreelancerId();
    		}
    }

    return null;

	}
	public List<Application> getApplicationsByProject(Long projectId) {
	    return applicationRepository.findByProjectId(projectId);
	}
    
}