package com.backend.mobile.repositories;

import org.springframework.stereotype.Repository;

import com.backend.mobile.models.Usuario;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

@Repository 

public interface AuthRepository extends JpaRepository<Usuario, Long>{
    Optional<Usuario> findByEmail(String email);
}
