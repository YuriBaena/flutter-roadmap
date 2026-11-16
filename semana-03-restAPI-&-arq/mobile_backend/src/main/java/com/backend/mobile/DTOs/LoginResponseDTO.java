package com.backend.mobile.DTOs;

public record LoginResponseDTO(
    String accessToken,
    String tokenType,
    long expiresIn
) {}
