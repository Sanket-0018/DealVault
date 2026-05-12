package com.dealvault.dealvault.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import com.dealvault.dealvault.model.User;

public interface UserRepository extends JpaRepository<User, Long> {

    User findByEmail(String email);
}