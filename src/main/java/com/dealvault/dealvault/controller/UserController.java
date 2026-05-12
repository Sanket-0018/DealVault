package com.dealvault.dealvault.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.dealvault.dealvault.model.User;
import com.dealvault.dealvault.service.UserService;

@RestController
@RequestMapping("/api/users")
public class UserController {

    @Autowired
    private UserService userService;

    // Register
    @PostMapping("/register")
    public User register(@RequestBody User user) {
        return userService.register(user);
    }

    // Login
    @PostMapping("/login")
    public String login(@RequestParam("email") String email,
                        @RequestParam("password") String password) {

        User user = userService.login(email, password);

        if (user != null) {
            return "Login Successful";
        } else {
            return "Invalid Credentials";
        }
    }
   
    
}