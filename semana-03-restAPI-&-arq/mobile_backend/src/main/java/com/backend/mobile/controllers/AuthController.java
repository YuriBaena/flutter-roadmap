package com.backend.mobile.controllers;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import com.backend.mobile.DTOs.LoginRequestDTO;
import com.backend.mobile.DTOs.LoginResponseDTO;
import com.backend.mobile.DTOs.RegisterRequestDTO;
import com.backend.mobile.DTOs.CurrentUserResponseDTO;
import com.backend.mobile.domain.AuthService;
import com.backend.mobile.domain.AuthService.ReturnRegister;

@RestController
@RequestMapping("/auth")
public class AuthController {

    private final AuthService service;

    public AuthController(AuthService service){
        this.service = service;
    }

    @PostMapping("/login")
    public ResponseEntity<LoginResponseDTO> login(@RequestBody LoginRequestDTO user){
        return ResponseEntity.ok(this.service.login(user));
    }

    @PostMapping("/register")
    public ResponseEntity<String> register(@RequestBody RegisterRequestDTO new_user){
        ReturnRegister resposta = this.service.registrar(new_user);
        return ResponseEntity.status(resposta.status()).body(resposta.mensagem());
    }

    @GetMapping("/me")
    public CurrentUserResponseDTO currentUser(@AuthenticationPrincipal Jwt jwt) {
        return new CurrentUserResponseDTO(jwt.getClaimAsString("userId"), jwt.getSubject());
    }

}
