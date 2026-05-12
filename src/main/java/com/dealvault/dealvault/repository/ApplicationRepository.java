package com.dealvault.dealvault.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import com.dealvault.dealvault.model.Application;

public interface ApplicationRepository extends JpaRepository<Application, Long> {
	Application findByProjectIdAndFreelancerId(Long projectId, Long freelancerId);
	List<Application> findByProjectId(Long projectId);
}