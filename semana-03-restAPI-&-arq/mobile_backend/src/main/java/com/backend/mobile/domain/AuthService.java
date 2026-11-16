package com.backend.mobile.domain;

import org.springframework.http.HttpStatus;
import org.springframework.security.oauth2.jose.jws.MacAlgorithm;
import org.springframework.security.oauth2.jwt.JwtClaimsSet;
import org.springframework.security.oauth2.jwt.JwtEncoder;
import org.springframework.security.oauth2.jwt.JwtEncoderParameters;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.server.ResponseStatusException;

import com.backend.mobile.DTOs.LoginRequestDTO;
import com.backend.mobile.DTOs.LoginResponseDTO;
import com.backend.mobile.DTOs.RegisterRequestDTO;
import com.backend.mobile.models.Usuario;
import com.backend.mobile.repositories.AuthRepository;

import java.time.Duration;
import java.time.Instant;

@Service 
public class AuthService {
    private static final Duration TOKEN_VALIDITY = Duration.ofHours(1);

    private final AuthRepository repo;
    private final PasswordEncoder encoder;
    private final JwtEncoder jwtEncoder;

    public AuthService(AuthRepository repo, PasswordEncoder encoder, JwtEncoder jwtEncoder){
        this.repo = repo;
        this.encoder = encoder;
        this.jwtEncoder = jwtEncoder;
    }

    public LoginResponseDTO login(LoginRequestDTO requestedUser){
        var usuarioOpt = this.repo.findByEmail(requestedUser.email());

        if (usuarioOpt.isEmpty() || !this.encoder.matches(requestedUser.senha(), usuarioOpt.get().getSenha())) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "E-mail ou senha inválidos.");
        }

        Usuario usuario = usuarioOpt.get();
        Instant now = Instant.now();
        JwtClaimsSet claims = JwtClaimsSet.builder()
            .issuer("mobile-backend")
            .issuedAt(now)
            .expiresAt(now.plus(TOKEN_VALIDITY))
            .subject(usuario.getEmail())
            .claim("userId", usuario.getId().toString())
            .build();

        String token = jwtEncoder.encode(JwtEncoderParameters.from(
            org.springframework.security.oauth2.jwt.JwsHeader.with(MacAlgorithm.HS256).build(),
            claims
        )).getTokenValue();

        return new LoginResponseDTO(token, "Bearer", TOKEN_VALIDITY.toSeconds());
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