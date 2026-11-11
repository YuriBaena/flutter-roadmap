package com.backend.mobile.DTOs;

public record StockResponseDTO(
    String symbol,
    String longName,
    Double regularMarketPrice,
    String regularMarketTime,
    String logourl
) {}