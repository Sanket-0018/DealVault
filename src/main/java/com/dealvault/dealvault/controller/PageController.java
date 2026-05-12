package com.dealvault.dealvault.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class PageController {

    @GetMapping("/")
    public String showLoginPage() {
        return "login"; // opens login.jsp
    }
    @GetMapping("/dashboard")
    public String showDashboard() {
        return "dashboard";
    }
}