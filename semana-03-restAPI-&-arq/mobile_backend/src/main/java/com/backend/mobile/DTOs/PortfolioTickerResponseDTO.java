package com.backend.mobile.DTOs;

import java.math.BigDecimal;

public record PortfolioTickerResponseDTO(
    Long id,
    String symbol,
    BigDecimal averagePrice
) {}
