package com.backend.mobile.controllers;

import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.backend.mobile.DTOs.PortfolioTickerRequestDTO;
import com.backend.mobile.DTOs.PortfolioTickerResponseDTO;
import com.backend.mobile.domain.CarteiraService;

@RestController
@RequestMapping("/api/carteira")
public class CarteiraController {

    private final CarteiraService carteiraService;

    public CarteiraController(CarteiraService carteiraService) {
        this.carteiraService = carteiraService;
    }

    @GetMapping
    public List<PortfolioTickerResponseDTO> listar(
        @AuthenticationPrincipal Jwt jwt
    ) {
        return carteiraService.listar(usuarioId(jwt));
    }

    @PostMapping
    public ResponseEntity<PortfolioTickerResponseDTO> adicionar(
        @AuthenticationPrincipal Jwt jwt,
        @RequestBody PortfolioTickerRequestDTO request
    ) {
        return ResponseEntity.status(HttpStatus.CREATED)
            .body(carteiraService.adicionar(usuarioId(jwt), request));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> remover(
        @AuthenticationPrincipal Jwt jwt,
        @PathVariable Long id
    ) {
        carteiraService.remover(usuarioId(jwt), id);
        return ResponseEntity.noContent().build();
    }

    private Long usuarioId(Jwt jwt) {
        return Long.valueOf(jwt.getClaimAsString("userId"));
    }
}
