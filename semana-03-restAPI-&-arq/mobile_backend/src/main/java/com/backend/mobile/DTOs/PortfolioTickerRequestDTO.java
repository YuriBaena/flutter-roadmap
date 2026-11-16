package com.backend.mobile.DTOs;

import java.math.BigDecimal;

public record PortfolioTickerRequestDTO(
    String symbol,
    BigDecimal averagePrice
) {}
