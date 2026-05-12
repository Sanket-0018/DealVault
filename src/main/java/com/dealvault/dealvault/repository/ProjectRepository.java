package com.dealvault.dealvault.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import com.dealvault.dealvault.model.Project;

public interface ProjectRepository extends JpaRepository<Project, Long> {
	List<Project> findByClientId(Long clientId);
}