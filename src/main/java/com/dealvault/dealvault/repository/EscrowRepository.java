package com.dealvault.dealvault.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.dealvault.dealvault.model.Escrow;
import java.util.List;



public interface EscrowRepository extends JpaRepository<Escrow, Long> {

    Escrow findByProjectId(Long projectId);
    List<Escrow> findAllByProjectId(Long projectId);
    
}