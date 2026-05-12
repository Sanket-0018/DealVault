package com.dealvault.dealvault.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dealvault.dealvault.model.Application;
import com.dealvault.dealvault.model.Escrow;
import com.dealvault.dealvault.model.User;
import com.dealvault.dealvault.repository.ApplicationRepository;
import com.dealvault.dealvault.repository.EscrowRepository;
import com.dealvault.dealvault.repository.UserRepository;

@Service
public class EscrowService {

    @Autowired
    private EscrowRepository escrowRepository;

    @Autowired
    private ApplicationRepository applicationRepository;

    @Autowired
    private UserRepository userRepository;

    // 🔥 Deposit money (LOCK)
    public Escrow deposit(Long projectId, Double amount) {

        List<Escrow> existingList = escrowRepository.findAllByProjectId(projectId);

        if (!existingList.isEmpty()) {
            return existingList.get(0);
        }

        Escrow escrow = new Escrow();
        escrow.setProjectId(projectId);
        escrow.setAmount(amount);
        escrow.setStatus("LOCKED");

        return escrowRepository.save(escrow);
    }

    // 🔥 Release money (MOST IMPORTANT)
    public Escrow release(Long projectId) {

        Escrow escrow = escrowRepository.findByProjectId(projectId);
        if (escrow == null) return null;

        // 🔥 find completed application
        List<Application> apps = applicationRepository.findByProjectId(projectId);

        Application selectedApp = null;

        for (Application app : apps) {
            if ("COMPLETED".equals(app.getStatus())) {
                selectedApp = app;
                break;
            }
        }

        if (selectedApp == null) return escrow;

        // 🔥 find freelancer
        User freelancer = userRepository
                .findById(selectedApp.getFreelancerId())
                .orElse(null);

        if (freelancer == null) return escrow;

        // 🔥 SAFE BALANCE UPDATE
        Double currentBalance = freelancer.getBalance();
        if (currentBalance == null) currentBalance = 0.0;

        freelancer.setBalance(currentBalance + escrow.getAmount());

        userRepository.save(freelancer);

        // 🔥 update escrow
        escrow.setStatus("RELEASED");
        System.out.println("PAYING: " + escrow.getAmount());
        System.out.println("OLD BALANCE: " + freelancer.getBalance());
        System.out.println("NEW BALANCE: " + (freelancer.getBalance() + escrow.getAmount()));

        return escrowRepository.save(escrow);
        
    }

    // 🔥 Get total locked amount
    public double getLockedAmount() {

        List<Escrow> list = escrowRepository.findAll();

        double total = 0;

        for (Escrow e : list) {
            if ("LOCKED".equals(e.getStatus())) {
                total += e.getAmount();
            }
        }

        return total;
    }
    public Double getAmountByProject(Long projectId) {
        Escrow escrow = escrowRepository.findByProjectId(projectId);
        return escrow != null ? escrow.getAmount() : 0.0;
    }
    
}