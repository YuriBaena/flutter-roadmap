package com.backend.mobile.controllers;

import org.springframework.web.bind.annotation.*;
import org.springframework.http.ResponseEntity;
import com.backend.mobile.DTOs.LoginRequestDTO;
import com.backend.mobile.DTOs.RegisterRequestDTO;
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
    public ResponseEntity<String> login(@RequestBody LoginRequestDTO user){
        ReturnRegister resposta = this.service.login(user);
        return ResponseEntity.status(resposta.status()).body(resposta.mensagem());
    }

    @PostMapping("/register")
    public ResponseEntity<String> register(@RequestBody RegisterRequestDTO new_user){
        ReturnRegister resposta = this.service.registrar(new_user);
        return ResponseEntity.status(resposta.status()).body(resposta.mensagem());
    }

}
