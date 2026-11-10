package com.backend.mobile.domain;

import org.springframework.http.HttpStatus;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.backend.mobile.DTOs.LoginRequestDTO;
import com.backend.mobile.DTOs.RegisterRequestDTO;
import com.backend.mobile.models.Usuario;
import com.backend.mobile.repositories.AuthRepository;

@Service 
public class AuthService {
    private final AuthRepository repo;
    private final PasswordEncoder encoder;

    public AuthService(AuthRepository repo, PasswordEncoder encoder){
        this.repo = repo;
        this.encoder = encoder;
    }

    public ReturnRegister login(LoginRequestDTO requestedUser){
        var usuarioOpt = this.repo.findByEmail(requestedUser.email());

        // Se o usuário não existe OU a senha está incorreta, retorna erro
        if (usuarioOpt.isEmpty() || !this.encoder.matches(requestedUser.senha(), usuarioOpt.get().getSenha())) {
            return new ReturnRegister(HttpStatus.UNAUTHORIZED, "E-mail ou senha inválidos.");
        }

        return new ReturnRegister(HttpStatus.ACCEPTED, "Usuário logado com sucesso.");
    }

    public ReturnRegister registrar(RegisterRequestDTO newUser){
        if (existsWithEmail(newUser.email())) {
            return new ReturnRegister(HttpStatus.CONFLICT, "Já existe um usuário cadastrado com este e-mail.");
        }

        String senhaHash = encoder.encode(newUser.senha());
        this.repo.save(new Usuario(newUser.email(), senhaHash));
        
        return new ReturnRegister(HttpStatus.CREATED, "Usuário registrado com sucesso.");
    }

    private boolean existsWithEmail(String email){
        return this.repo.findByEmail(email).isPresent();
    }

    public record ReturnRegister(
        HttpStatus status,
        String mensagem
    ){}
}