package com.dealvault.dealvault.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.dealvault.dealvault.model.Escrow;
import com.dealvault.dealvault.service.EscrowService;

@RestController
@RequestMapping("/api/escrow")
public class EscrowController {

    @Autowired
    private EscrowService escrowService;

    // Deposit
    @PostMapping("/deposit")
    public Escrow deposit(@RequestParam("projectId") Long projectId,
                          @RequestParam("amount") Double amount) {

        return escrowService.deposit(projectId, amount);
    }

    // Release
    @PostMapping("/release")
    public Escrow release(@RequestParam("projectId") Long projectId) {

        return escrowService.release(projectId);
    }
}